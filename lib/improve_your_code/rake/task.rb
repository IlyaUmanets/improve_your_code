# frozen_string_literal: true

require 'rake'
require 'rake/tasklib'
require 'pathname'
require 'English'

module ImproveYourCode
  module Rake
    class Task < ::Rake::TaskLib
      attr_writer :name
      attr_accessor :config_file
      attr_reader :source_files
      attr_accessor :improve_your_code_opts
      attr_writer :fail_on_error
      attr_writer :verbose

      def initialize(name = :improve_your_code)
        @config_file   = ENV['IMPROVE_YOUR_CODE_CFG']
        @name          = name
        @improve_your_code_opts     = ENV['IMPROVE_YOUR_CODE_OPTS'] || ''
        @fail_on_error = true
        @verbose       = false

        yield self if block_given?

        if (improve_your_code_src = ENV['IMPROVE_YOUR_CODE_SRC'])
          @source_files = FileList[improve_your_code_src]
        end
        @source_files ||= FileList['lib/**/*.rb']
        define_task
      end

      def source_files=(files)
        unless files.is_a?(String) || files.is_a?(FileList)
          raise ArgumentError, 'File list should be a FileList or a String that can contain'\
            " a glob pattern, e.g. '{app,lib,spec}/**/*.rb'"
        end
        @source_files = FileList[files]
      end

      private

      attr_reader :fail_on_error, :name, :verbose

      def define_task
        desc 'Check for code smells'
        task(name) { run_task }
      end

      def run_task
        puts "\n\n!!! Running 'improve_your_code' rake command: #{command}\n\n" if verbose
        system(*command)
        abort("\n\n!!! ImproveYourCode has found smells - exiting!") if sys_call_failed? && fail_on_error
      end

      def command
        ['improve_your_code', *config_file_as_argument, *improve_your_code_opts_as_arguments, *source_files].
          compact.
          reject(&:empty?)
      end

      def sys_call_failed?
        !$CHILD_STATUS.success?
      end

      def config_file_as_argument
        config_file ? ['-c', config_file] : []
      end

      def improve_your_code_opts_as_arguments
        improve_your_code_opts.split(/\s+/)
      end
    end
  end
end
