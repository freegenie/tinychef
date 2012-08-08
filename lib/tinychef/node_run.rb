module Tinychef
  class NodeRun

    class OptionsError < Exception
      def initialize
        super <<-EOH

Required arguments:

  NODE:     node file to execute
  DEST:     ssh username@host string to use to connect to host
  RUN_LIST: an optional RUN_LIST to be passed to chef-solo executable.

        EOH
      end
    end

    RECIPES_DIR="recipes"

    attr_reader :dest, :node, :run_list, :run_list_command

    def initialize(node, dest, run_list)
      @node = node
      @dest = dest
      @run_list = run_list

      validate!
    end

    def apply
      sync_files
      ensure_remote_data_bag_file_exits
      run_code
      remove_files
    end

    private

    def validate!
      if node.nil?
        raise OptionsError.new
      end

      if dest.nil?
        raise OptionsError.new
      end

      unless run_list.nil?
        @run_list_command = "-o #{run_list}"
      end
    end


    def ensure_remote_data_bag_file_exits
    end

    def sync_files
      system %Q{ rsync -rvcL --exclude .git --exclude vendor/* --exclude *.swp --exclude *.swo .  #{dest}:#{RECIPES_DIR} }

      system %Q{ ssh -t #{dest} "sudo mkdir -p /etc/chef " }
      system %Q{ ssh -t #{dest} "sudo cp #{RECIPES_DIR}/data_bags/secret.key /etc/chef/encrypted_data_bag_secret" }
    end

    def run_code
      system %Q{ ssh -t #{dest} "cd #{RECIPES_DIR} && sudo chef-solo -c solo.rb -j #{node} #{run_list_command}" }
    end

    def remove_files
      system %Q{ ssh -t #{dest} "sudo rm -rf #{RECIPES_DIR} /etc/chef/encrypted_data_bag_secret" }
    end

  end
end
