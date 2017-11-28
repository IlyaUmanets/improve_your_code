# frozen_string_literal: true

require_relative 'simple_warning_formatter'

module ImproveYourCode
  module Report
    module Formatter
      class WikiLinkWarningFormatter < SimpleWarningFormatter
        BASE_URL_FOR_HELP_LINK = 'https://github.com/troessner/improve_your_code/blob/master/docs/'.freeze

        def format(warning)
          "#{super} [#{explanatory_link(warning)}]"
        end

        def format_hash(warning)
          super.merge('wiki_link' => explanatory_link(warning))
        end

        private

        def explanatory_link(warning)
          "#{BASE_URL_FOR_HELP_LINK}#{class_name_to_param(warning.smell_type)}.md"
        end

        def class_name_to_param(name)
          name.split(/(?=[A-Z])/).join('-')
        end
      end
    end
  end
end
