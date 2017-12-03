# frozen_string_literal: true

require_relative 'context/attribute_context'
require_relative 'context/method_context'
require_relative 'context/module_context'
require_relative 'context/root_context'
require_relative 'context/send_context'
require_relative 'context/singleton_attribute_context'
require_relative 'context/singleton_method_context'
require_relative 'ast/node'

module ImproveYourCode
  class ContextBuilder
    attr_reader :syntax_tree

    def initialize(syntax_tree)
      @syntax_tree = syntax_tree
      @current_context = Context::RootContext.new(syntax_tree)
    end

    def build(exp = syntax_tree, parent_exp = nil)
      context_processor = "process_#{exp.type}"

      if context_processor_exists?(context_processor)
        send(context_processor, exp, parent_exp)
      else
        process exp
      end

      current_context
    end

    private

    attr_accessor :current_context

    def process(exp)
      exp.children.grep(AST::Node).each { |child| build(child, exp) }
    end

    def process_module(exp, _parent)
      inside_new_context(Context::ModuleContext, exp) do
        process(exp)
      end
    end

    alias process_class process_module

    def process_def(exp, parent)
      inside_new_context(current_context.method_context_class, exp, parent) do
        increase_statement_count_by(exp.body)
        process(exp)
      end
    end

    def process_send(exp, _parent)
      process(exp)
      case current_context
      when Context::ModuleContext
        handle_send_for_modules exp
      when Context::MethodContext
        handle_send_for_methods exp
      end
    end

    def process_begin(exp, _parent)
      increase_statement_count_by(exp.children)
      decrease_statement_count
      process(exp)
    end

    alias process_kwbegin process_begin

    def context_processor_exists?(name)
      self.class.private_method_defined?(name)
    end

    def increase_statement_count_by(sexp)
      current_context.statement_counter.increase_by sexp
    end

    def decrease_statement_count
      current_context.statement_counter.decrease_by 1
    end

    def inside_new_context(klass, *args)
      new_context = append_new_context(klass, *args)

      orig = current_context
      self.current_context = new_context
      yield
      self.current_context = orig
    end

    def append_new_context(klass, *args)
      klass.new(*args).tap do |new_context|
        new_context.register_with_parent(current_context)
      end
    end

    def handle_send_for_modules(exp)
      arg_names = exp.args.map { |arg| arg.children.first }
      current_context.track_visibility(exp.name, arg_names)
      register_attributes(exp)
    end

    def handle_send_for_methods(exp)
      append_new_context(Context::SendContext, exp, exp.name)
      current_context.record_call_to(exp)
    end

    def register_attributes(exp)
      return unless exp.attribute_writer?
      klass = current_context.attribute_context_class
      exp.args.each do |arg|
        append_new_context(klass, arg, exp)
      end
    end
  end
end
