module Fastlane
  module Helper
    class BuildCacheHelper
      # class methods that you define here become available in your action
      # as `Helper::BuildCacheHelper.your_method`
      #
      def self.build_identifier
        commits = Actions.sh('git rev-list HEAD', log: $verbose).chomp
        identifier = Digest::SHA256.hexdigest(commits)
        identifier + '.zip'
      end

      def self.ensure_workspace_folder_exists(workspace_path)
        `mkdir #{workspace_path}` unless File.exist?(workspace_path)
      end
    end
  end
end
