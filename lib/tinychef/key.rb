module Tinychef
  class Key 

    OPTIONS_ERROR = <<-EOH
Required arguments:

  NAME:     the name of the secret file. 

EOH

    attr_reader :name, :path

    def initialize(name='secret')
      raise if name.nil? 

      @name = name
      @path = Pathname.new "#{name}.key"
    rescue 
      raise OptionsError.new OPTIONS_ERROR
    end

    def password_protect
      system "openssl aes-256-cbc -salt -in #{path} -out #{path}.aes"
    end

    def unlock_and_restore
      system "openssl aes-256-cbc -d -salt -in #{path}.aes -out #{path}"
    end

    def generate 
      if path.exist?
        raise RuntimeError.new "File #{path} exists." 
      else
        system "openssl rand -base64 512 | tr -d '\r\n' > #{path}"
      end
    end
    
  end
end
