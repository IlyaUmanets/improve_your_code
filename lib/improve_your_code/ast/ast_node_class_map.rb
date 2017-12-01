# frozen_string_literal: true

require_relative 'node'
require_relative 'sexp_extensions'

module ImproveYourCode
  module AST
    class ASTNodeClassMap
      def initialize
        @klass_map = {}
      end

      def klass_for(type)
        klass_map[type] ||= Class.new(Node).tap do |klass|
          extension = extension_map[type]

          klass.send :include, extension if extension
        end
      end

      def extension_map
        @extension_map ||=
          begin
            assoc = SexpExtensions.constants.map do |const|
              [
                const.to_s.sub(/Node$/, '').downcase.to_sym,
                SexpExtensions.const_get(const)
              ]
            end
            Hash[assoc]
          end
      end

      private

      attr_reader :klass_map
    end
  end
end
