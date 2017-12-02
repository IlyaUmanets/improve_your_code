# frozen_string_literal: true

module ImproveYourCode
  module AST
    module SexpExtensions
      module ConstantDefiningNodeBase
        def full_name(outer)
          [outer, name].reject(&:empty?).join('::')
        end

        def simple_name
          name.split('::').last
        end
      end

      module ModuleNodeBase
        include ConstantDefiningNodeBase

        def name
          children.first.format_to_ruby
        end
      end

      module ModuleNode
        include ModuleNodeBase
      end

      module ClassNode
        include ModuleNodeBase
      end

      module CasgnNode
        include ConstantDefiningNodeBase

        def defines_module?
          call = constant_definition
          call&.module_creation_call?
        end

        def name
          children[1].to_s
        end

        def value
          children[2]
        end

        private

        def constant_definition
          return nil unless value

          case value.type
          when :block
            call = value.call
            call if call.type == :send
          when :send
            value
          end
        end
      end
    end
  end
end
