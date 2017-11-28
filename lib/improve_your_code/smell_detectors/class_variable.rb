# frozen_string_literal: true

require 'set'
require_relative 'base_detector'

module ImproveYourCode
  module SmellDetectors
    class ClassVariable < BaseDetector
      def self.contexts
        [:class, :module]
      end

      def sniff
        class_variables_in_context.map do |variable, lines|
          smell_warning(
            context: context,
            lines: lines,
            message: "declares the class variable '#{variable}'",
            parameters: { name: variable.to_s })
        end
      end

      def class_variables_in_context
        result = Hash.new { |hash, key| hash[key] = [] }
        collector = proc do |cvar_node|
          result[cvar_node.name].push(cvar_node.line)
        end
        [:cvar, :cvasgn, :cvdecl].each do |stmt_type|
          expression.each_node(stmt_type, [:class, :module], &collector)
        end
        result
      end
    end
  end
end
