module Tinychef
  module Commands
    
    def new_command
      dir_name = ARGV[1]
      Tinychef::NewDirectory.new(dir_name).create
    end

    def boot_command
      dest = ARGV[1] ; script = ARGV[2]
      Tinychef::BootScript.new(dest, script).run
    end

    def bag_create_command
      recipe = ARGV[1] ; name = ARGV[2]
      Tinychef::DataBag.new(recipe, name).create
    end

    def bag_encrypt_command
      recipe = ARGV[1] ; name = ARGV[2]
      Tinychef::DataBag.new(recipe, name).encrypt
    end

    def bag_decrypt_command
      recipe = ARGV[1] ; name = ARGV[2]
      Tinychef::DataBag.new(recipe, name).decrypt
    end

    def key_lock_command
      Tinychef::Key.new(ARGV[1]).password_protect
    end

    def key_unlock_command
      Tinychef::Key.new(ARGV[1]).unlock_and_restore
    end

    def key_generate_command
      Tinychef::Key.new(ARGV[1]).generate
    end

    def secure_command
    end

    def unsecure_command
    end

    def run_command
      options = {}

      options[:node] = ARGV[1]

      if ARGV.size == 3 # assume the destination is not given
        options[:dest] = nil ; options[:run_list] = ARGV[2]
      else
        options[:dest] = ARGV[2] ; options[:run_list] = ARGV[3]
      end

      Tinychef::NodeRun.new(options).start
    end
  end
end
