require 'tinychef/node'
require 'tinychef/destination'
require 'tinychef/new_directory'

module Tinychef
  class NodeRun

    OPTIONS_ERROR = <<-EOH
Required arguments:

  NODE:     node file to execute
  DEST:     ssh username@host string to use to connect to host.
            If missing, this is guessed by the node file name.
  RUN_LIST: an optional RUN_LIST to be passed to chef-solo executable.

EOH

    RECIPES_DIR = "recipes"

    attr_reader :dest, :node, :run_list, :run_list_command

    def initialize(options)
      node     = options[:node]
      dest     = options[:dest]
      run_list = options[:run_list]

      @node = Tinychef::Node.new(node)
      @dest = Tinychef::Destination.new(dest || @node.host)

      @run_list = run_list

      prepare_run_list_command

    rescue => e
      raise OptionsError.new NodeRun::OPTIONS_ERROR
    end

    def start
      sync_files
      ensure_remote_data_bag_file_exits
      run_code
      remove_files
    end

    private

    def prepare_run_list_command
      unless run_list.nil?
        @run_list_command = "-o #{run_list}"
      end
    end

    def ensure_remote_data_bag_file_exits
    end

    def sync_files
      puts "Destination is #{dest}"

      system %Q{ rsync -rvcL --exclude .git --exclude vendor/* --exclude *.swp --exclude *.swo .  #{dest}:#{RECIPES_DIR} }
      system %Q{ ssh -t #{dest} "sudo mkdir -p /etc/chef " }
      system %Q{ ssh -t #{dest} "sudo cp #{RECIPES_DIR}/secret.key /etc/chef/encrypted_data_bag_secret" }
    end

    def run_code
      system %Q{ ssh -t #{dest} "cd #{RECIPES_DIR} && sudo chef-solo -c solo.rb -j #{node.path} #{run_list_command}" }
    end

    def remove_files
      system %Q{ ssh -t #{dest} "sudo rm -rf #{RECIPES_DIR} /etc/chef/encrypted_data_bag_secret" }
    end

  end
end
