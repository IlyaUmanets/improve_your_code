# frozen_string_literal: true

require_relative 'context/attribute_context'
require_relative 'context/class_context'
require_relative 'context/ghost_context'
require_relative 'context/method_context'
require_relative 'context/module_context'
require_relative 'context/root_context'
require_relative 'context/send_context'
require_relative 'context/singleton_attribute_context'
require_relative 'context/singleton_method_context'
require_relative 'ast/node'

module ImproveYourCode
  class ContextBuilder
    attr_reader :context_tree

    def initialize(syntax_tree)
      @exp = syntax_tree
      @current_context = Context::RootContext.new(exp)
      @context_tree = build(exp)
    end

    private

    attr_accessor :current_context
    attr_reader :exp

    def build(exp, parent_exp = nil)
      context_processor = "process_#{exp.type}"
      if context_processor_exists?(context_processor)
        send(context_processor, exp, parent_exp)
      else
        process exp
      end
      current_context
    end

    def process(exp)
      exp.children.grep(AST::Node).each { |child| build(child, exp) }
    end

    def process_module(exp, _parent)
      inside_new_context(Context::ModuleContext, exp) do
        process(exp)
      end
    end

    alias process_class process_module

    def process_sclass(exp, _parent)
      inside_new_context(Context::GhostContext, exp) do
        process(exp)
      end
    end

    def process_casgn(exp, parent)
      if exp.defines_module?
        process_module(exp, parent)
      else
        process(exp)
      end
    end

    def process_def(exp, parent)
      inside_new_context(current_context.method_context_class, exp, parent) do
        increase_statement_count_by(exp.body)
        process(exp)
      end
    end

    def process_defs(exp, parent)
      inside_new_context(Context::SingletonMethodContext, exp, parent) do
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

    def process_op_asgn(exp, _parent)
      current_context.record_call_to(exp)
      process(exp)
    end

    def process_ivar(exp, _parent)
      current_context.record_use_of_self
      process(exp)
    end

    alias process_ivasgn process_ivar

    def process_self(_, _parent)
      current_context.record_use_of_self
    end

    def process_zsuper(_, _parent)
      current_context.record_use_of_self
    end

    def process_super(exp, _parent)
      current_context.record_use_of_self
      process(exp)
    end

    def process_block(exp, _parent)
      increase_statement_count_by(exp.block)
      process(exp)
    end

    def process_begin(exp, _parent)
      increase_statement_count_by(exp.children)
      decrease_statement_count
      process(exp)
    end

    alias process_kwbegin process_begin

    def process_if(exp, _parent)
      children = exp.children
      increase_statement_count_by(children[1])
      increase_statement_count_by(children[2])
      decrease_statement_count
      process(exp)
    end

    def process_while(exp, _parent)
      increase_statement_count_by(exp.children[1])
      decrease_statement_count
      process(exp)
    end

    alias process_until process_while

    def process_for(exp, _parent)
      increase_statement_count_by(exp.children[2])
      decrease_statement_count
      process(exp)
    end

    def process_rescue(exp, _parent)
      increase_statement_count_by(exp.children.first)
      decrease_statement_count
      process(exp)
    end

    def process_resbody(exp, _parent)
      increase_statement_count_by(exp.children[1..-1].compact)
      process(exp)
    end

    def process_case(exp, _parent)
      increase_statement_count_by(exp.else_body)
      decrease_statement_count
      process(exp)
    end

    def process_when(exp, _parent)
      increase_statement_count_by(exp.body)
      process(exp)
    end

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
