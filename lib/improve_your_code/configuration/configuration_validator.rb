# frozen_string_literal: true

module ImproveYourCode
  module Configuration
    #
    # Configuration validator module.
    #
    module ConfigurationValidator
      private

      # :improve_your_code:UtilityFunction
      def smell_type?(key)
        case key
        when Class
          true
        when String
          begin
            ImproveYourCode::SmellDetectors.const_defined? key
          rescue NameError
            false
          end
        end
      end

      # :improve_your_code:UtilityFunction
      def key_to_smell_detector(key)
        case key
        when Class
          key
        else
          ImproveYourCode::SmellDetectors.const_get key
        end
      end

      def error_message_for_file_given(pathname)
        "Configuration error: `#{pathname}` is supposed to be a directory but is a file"
      end

      def with_valid_directory(path)
        directory = Pathname.new path.to_s.chomp('/')
        abort(error_message_for_file_given(directory)) if directory.file?
        yield directory if block_given?
      end
    end
  end
end
