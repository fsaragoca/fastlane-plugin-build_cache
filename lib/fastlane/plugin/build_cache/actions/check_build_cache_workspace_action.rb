module Fastlane
  module Actions
    class CheckBuildCacheWorkspaceAction < Action
      def self.run(params)
        workspace_path = params[:workspace_path]
        build_identifier = params[:build_identifier]
        full_path = File.join(workspace_path, build_identifier)
        File.file?(full_path)
      end

      def self.description
        "Check if cache for current build is avaiable"
      end

      def self.authors
        ["Fernando Saragoca"]
      end

      def self.return_value
        "Boolean indicating if cache for current build is available"
      end

      def self.available_options
        [
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
