module Fastlane
  module Actions
    module SharedValues
      UPDATE_XCODEPROJ_CUSTOM_VALUE = :UPDATE_XCODEPROJ_CUSTOM_VALUE
    end

    class UpdateXcodeprojAction < Action
      def self.run(params)
        require 'xcodeproj'

        options = params[:options]
        project_path = params[:xcodeproj]
        project = Xcodeproj::Project.open(project_path)

        options.each do |key, value|
          configs = project.objects.select do |object|
            object.isa == 'XCBuildConfiguration' && !object.build_settings[key.to_s].nil?
          end
          UI.user_error!("Xcodeproj does not contain the key '#{key}'.") if configs.count.zero?

          configs.each do |configuration|
            configuration.build_settings[key.to_s] = value
          end
        end

        project.save

        UI.success("Updated '#{params[:options]}' in #{params[:xcodeproj]}.")
      end

      def self.description
        'Updates build setting values in an Xcode project.'
      end

      def self.details
        'Finds every build configuration containing a requested build setting and replaces its value.'
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :xcodeproj,
            env_name: 'UPDATE_XCODEPROJ_XCODEPROJ',
            description: 'Path to your Xcode project',
            optional: true,
            default_value: Dir['*.xcodeproj'].first,
            type: String,
            verify_block: proc do |value|
              UI.user_error!('Please pass the path to the project, not the workspace') unless value.end_with?('.xcodeproj')
              UI.user_error!('Could not find Xcode project') unless File.exist?(value)
            end
          ),
          FastlaneCore::ConfigItem.new(
            key: :options,
            env_name: 'UPDATE_XCODEPROJ_OPTIONS',
            description: 'A hash of key/value pairs you want to update',
            optional: false,
            type: Hash
          )
        ]
      end

      def self.output
        [
          ['UPDATE_XCODEPROJ_CUSTOM_VALUE', 'The updated build setting values.']
        ]
      end

      def self.return_value; end

      def self.authors
        ['croberts22']
      end

      def self.is_supported?(platform)
        platform == :ios
      end
    end
  end
end
