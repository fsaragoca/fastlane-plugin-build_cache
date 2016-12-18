module Fastlane
  module Actions
    class UnarchiveDerivedDataAction < Action
      def self.run(params)
        build_identifier = params[:build_identifier]
        workspace_path = params[:workspace_path]
        Helper::BuildCacheHelper.ensure_workspace_folder_exists(workspace_path)

        derived_data_path = params[:derived_data_path]
        derived_data_path_components = derived_data_path.split('/')
        derived_data_path_components.pop

        derived_data_root_folder_path = derived_data_path_components.join('/')
        zip_path = File.join(workspace_path, build_identifier)

        if File.exist?(zip_path)
          Actions.sh("unzip #{zip_path} -d #{derived_data_root_folder_path}", log: $verbose)
        else
          UI.user_error! "Unable to find cache for build '#{build_identifier}' 🚫"
        end
      end

      def self.description
        "Unarchives derived data folder from a zip file"
      end

      def self.authors
        ["Fernando Saragoca"]
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :derived_data_path,
                                  env_name: "BUILD_CACHE_DERIVED_DATA_PATH",
                               description: "Path to derived data folder",
                             default_value: ENV['DERIVED_DATA_PATH'],
                                      type: String),
          FastlaneCore::ConfigItem.new(key: :workspace_path,
                                  env_name: "BUILD_CACHE_WORKSPACE_PATH",
                               description: "Build cache workspace",
                                      type: String),
          FastlaneCore::ConfigItem.new(key: :build_identifier,
                                  env_name: "BUILD_CACHE_BUILD_IDENTIFIER",
                               description: "Identifier for current build",
                             default_value: Helper::BuildCacheHelper.build_identifier,
                                      type: String)
        ]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
