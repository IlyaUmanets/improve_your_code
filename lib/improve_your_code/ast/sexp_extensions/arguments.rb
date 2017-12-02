# frozen_string_literal: true

module ImproveYourCode
  module AST
    module SexpExtensions
      module ArgNodeBase
        def name
          children.first
        end

        def marked_unused?
          plain_name.start_with?('_')
        end

        def plain_name
          name.to_s
        end

        def block?
          false
        end

        def optional_argument?
          false
        end

        def anonymous_splat?
          false
        end

        def components
          [self]
        end
      end

      module ArgNode
        include ArgNodeBase
      end

      module KwargNode
        include ArgNodeBase
      end

      module OptargNode
        include ArgNodeBase

        def optional_argument?
          true
        end
      end

      module KwoptargNode
        include ArgNodeBase

        def optional_argument?
          true
        end
      end

      module BlockargNode
        include ArgNodeBase

        def block?
          true
        end
      end

      module RestargNode
        include ArgNodeBase

        def anonymous_splat?
          !name
        end
      end

      module KwrestargNode
        include ArgNodeBase

        def anonymous_splat?
          !name
        end
      end

      module ShadowargNode
        include ArgNodeBase
      end
    end
  end
end
