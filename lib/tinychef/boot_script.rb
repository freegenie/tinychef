require 'pathname'
require 'tinychef/node'
require 'tinychef/destination'

module Tinychef
  class BootScript 
    
    OPTIONS_ERROR = <<-EOH
Required arguments:

  DEST:     ssh username@host string to use to connect to host.
  SCRIPT:   optional path to the boot script (boot.sh by default).
            You must craft your Chef Solo boot script by yourself, 
            something like this: https://gist.github.com/3153784

EOH
    
    attr_reader :dest, :script
    
    def initialize(dest, script='boot.sh') 
      @dest = Tinychef::Destination.new(dest)
      @script = Pathname.new(script)
      file_check
      
    rescue => e
      raise OptionsError.new BootScript::OPTIONS_ERROR
    end
    
    def run
      push_to_remote
      execute_remote
    end
    
    private
    
    def file_check
      unless script.exist? 
        raise "File #{script} not found. Craft your boot script, something like this: https://gist.github.com/3153784"
      end
      unless script.extname == '.sh'
        raise "File must be a shell script (.sh extension please)"
      end
    end
    
    def push_to_remote      
      system %Q{ scp #{script} #{dest}: }
    end
    
    def execute_remote
      system %Q{ ssh -t #{dest} "sh #{script.basename}" }
    end
    
  end
end