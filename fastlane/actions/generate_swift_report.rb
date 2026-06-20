module Fastlane
  module Actions
    module SharedValues
      GENERATE_SWIFT_REPORT_CUSTOM_VALUE = :GENERATE_SWIFT_REPORT_CUSTOM_VALUE
    end

    class GenerateSwiftReportAction < Action
      def self.run(params)
        size = params[:list_size] || 30

        UI.message "Preparing to grep the top #{size} Swift compile lines..."
        list_string = sh "< #{params[:log_path]} egrep '\\.[0-9]ms' | sort -t \".\" -k 1 -n | tail -#{size} | sort -n -r"

        UI.success 'grep completed. List of top lines:'
        UI.important list_string

        list = list_string.split("\n")

        UI.message 'Generating Jenkins report...'
        File.open('swift_report.xml', 'w') do |file|
          file.write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n")
          file.write("<testsuites>\n")
          file.write("   <testsuite name=\"swift.report\">\n")

          list.each do |line|
            line.match(/([0-9]+\.[0-9]+ms)(.*)/) do |match|
              method_name = match[2].split('/').last
              time_in_seconds = match[1].to_i / 1000.0
              file.write("       <testcase classname=\"swift.report\" name=\"#{method_name}\" time=\"#{time_in_seconds}\"></testcase>\n")
            end
          end

          file.write("   </testsuite>\n")
          file.write("</testsuites>\n")
        end

        list
      end

      def self.description
        'Takes a log file from the gym command and generates a Swift compile time report.'
      end

      def self.details
        'Sorts a log file by compile time and emits a Jenkins-compatible XML report.'
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :log_path,
            env_name: 'FL_GENERATE_SWIFT_REPORT_LOG_PATH',
            description: 'The path to the xcodebuild log',
            verify_block: proc do |value|
              UI.user_error!("No log path was given, pass using `log_path: 'path'`") unless value && !value.empty?
            end,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :list_size,
            env_name: 'FL_GENERATE_SWIFT_REPORT_LIST_SIZE',
            description: 'The number of lines to generate for the report',
            default_value: 30,
            type: Integer
          )
        ]
      end

      def self.output
        [
          ['GENERATE_SWIFT_REPORT_LIST', 'A list of lines sorted descending by Swift compile time.']
        ]
      end

      def self.return_value
        'Returns lines sorted descending by Swift compile time.'
      end

      def self.authors
        ['croberts22']
      end

      def self.is_supported?(platform)
        platform == :ios
      end
    end
  end
end
