# frozen_string_literal: true

require 'rake'
require 'rake/tasklib'
require 'pathname'
require 'English'

module ImproveYourCode
  #
  # Defines a task library for running ImproveYourCode.
  #
  # @public
  module Rake
    # A Rake task that runs ImproveYourCode on a set of source files.
    #
    # Example:
    #
    #   require 'improve_your_code/rake/task'
    #
    #   ImproveYourCode::Rake::Task.new do |t|
    #     t.fail_on_error = false
    #   end
    #
    # This will create a task that can be run with:
    #
    #   rake improve_your_code
    #
    # Examples:
    #
    #   rake improve_your_code                                # checks lib/**/*.rb
    #   rake improve_your_code IMPROVE_YOUR_CODE_SRC=just_one_file.rb      # checks a single source file
    #   rake improve_your_code IMPROVE_YOUR_CODE_OPTS=-s                   # sorts the report by smell
    #
    # @public
    #
    # :improve_your_code:TooManyInstanceVariables: { max_instance_variables: 6 }
    # :improve_your_code:Attribute
    class Task < ::Rake::TaskLib
      # Name of ImproveYourCode task. Defaults to :improve_your_code.
      # @public
      attr_writer :name

      # Path to ImproveYourCode's config file.
      # Setting the IMPROVE_YOUR_CODE_CFG environment variable overrides this.
      # @public
      attr_accessor :config_file

      # Glob pattern to match source files.
      # Setting the IMPROVE_YOUR_CODE_SRC environment variable overrides this.
      # Defaults to 'lib/**/*.rb'.
      # @public
      attr_reader :source_files

      # String containing commandline options to be passed to ImproveYourCode.
      # Setting the IMPROVE_YOUR_CODE_OPTS environment variable overrides this value.
      # Defaults to ''.
      # @public
      attr_accessor :improve_your_code_opts

      # Whether or not to fail Rake when an error occurs (typically when smells are found).
      # Defaults to true.
      # @public
      attr_writer :fail_on_error

      # Use verbose output. If this is set to true, the task will print
      # the improve_your_code command to stdout. Defaults to false.
      # @public
      attr_writer :verbose

      # @public
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

      # @public
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

      # :improve_your_code:UtilityFunction
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
