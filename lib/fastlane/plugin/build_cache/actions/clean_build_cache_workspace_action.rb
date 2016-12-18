module Fastlane
  module Actions
    class CleanBuildCacheWorkspaceAction < Action
      def self.run(params)
        workspace_path = params[:workspace_path]
        max_build_count = params[:max_build_count]

        files = Dir[workspace_path + '/*.zip']
        number_of_files_to_delete = files.count - max_build_count
        if number_of_files_to_delete > 0
          # `File.atime` returns the last access time for the named file as a Time object.
          sorted_files = files.sort_by { |filename| File.atime(filename) }
          sorted_files.take(number_of_files_to_delete).each do |file|
            Actions.sh("rm -rf #{file}", log: $verbose)
          end
        end
      end

      def self.description
        "Cleans workspace by removing old builds, using last access time for comparison"
      end

      def self.authors
        ["Fernando Saragoca"]
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :workspace_path,
                                  env_name: "BUILD_CACHE_WORKSPACE_PATH",
                               description: "Build cache workspace",
                                      type: String),
          FastlaneCore::ConfigItem.new(key: :max_build_count,
                                  env_name: "BUILD_CACHE_MAX_BUILD_COUNT",
                               description: "Number of archives to keep in workspace",
                             default_value: 10,
                                      type: Integer)
        ]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
