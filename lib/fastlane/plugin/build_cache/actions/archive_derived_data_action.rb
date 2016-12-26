module Fastlane
  module Actions
    class ArchiveDerivedDataAction < Action
      def self.run(params)
        build_identifier = params[:build_identifier]
        workspace_path = params[:workspace_path]
        Helper::BuildCacheHelper.ensure_workspace_folder_exists(workspace_path)

        derived_data_path = params[:derived_data_path]
        derived_data_path_components = derived_data_path.split('/')
        derived_data_folder_name = derived_data_path_components.pop

        zip_tmp_path = File.join(derived_data_path_components.join('/'), build_identifier)
        zip_final_path = File.join(workspace_path, build_identifier)
        build_intermediates_path = File.join(derived_data_path, 'Build', 'Intermediates')

        files_to_delete = [File.join(derived_data_path, 'ModuleCache'),
                           File.join(derived_data_path, 'Logs')]

        code_coverage_path = File.join(build_intermediates_path, 'CodeCoverage')
        if File.exist?(code_coverage_path)
          files_to_delete << File.join(code_coverage_path, 'Intermediates')
        else
          files_to_delete << build_intermediates_path
        end

        files_to_delete << zip_tmp_path
        files_to_delete << zip_final_path

        files_to_delete.each do |file|
          Actions.sh("rm -rf #{file}", log: $verbose)
        end

        Actions.sh("cd #{derived_data_path} && cd ../ && zip -r #{build_identifier} #{derived_data_folder_name}", log: $verbose)
        Actions.sh("mv #{zip_tmp_path} #{zip_final_path}", log: $verbose)

        zip_final_path
      end

      def self.description
        "Archives derived data folder in a zip file for later use"
      end

      def self.authors
        ["Fernando Saragoca"]
      end

      def self.return_value
        "Returns path for archived zip file"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :derived_data_path,
                                  env_name: "BUILD_CACHE_DERIVED_DATA_PATH",
                               description: "Path to derived data folder",
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
