# frozen_string_literal: true

require_relative 'base_error'

module ImproveYourCode
  module Errors
    class BadDetectorInCommentError < BaseError
      UNKNOWN_SMELL_DETECTOR_MESSAGE = <<-MESSAGE.freeze

        Error: You are trying to configure an unknown smell detector '%s' in one
        of your source code comments.
        The source is '%s' and the comment belongs to the expression starting in line %d.
        Here's the original comment:

        %s

        Please see the ImproveYourCode docs for:
          * how to configure ImproveYourCode via source code comments: https://github.com/troessner/improve_your_code/blob/master/docs/Smell-Suppression.md
          * what smell detectors are available: https://github.com/troessner/improve_your_code/blob/master/docs/Code-Smells.md
        Update the offensive comment (or remove it if no longer applicable) and re-run ImproveYourCode.

      MESSAGE

      def initialize(detector_name:, source:, line:, original_comment:)
        message = format(UNKNOWN_SMELL_DETECTOR_MESSAGE,
                         detector_name,
                         source,
                         line,
                         original_comment)
        super message
      end
    end
  end
end
