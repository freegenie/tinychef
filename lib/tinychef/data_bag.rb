module Tinychef 
  class DataBag
    
    OPTIONS_ERROR = <<-EOH
Required arguments:

  RECIPE:   Databags must be archived under the name of a recipe.
  NAME:     Name of this databag. 
  
EOH
    
    attr_reader :recipe, :name, :ruby_name, :ruby_path, :json_name, :json_path
    
    def initialize(recipe, name)
      
      if recipe.nil? || name.nil? 
        raise OptionsError.new OPTIONS_ERROR 
      end
      
      @name      = name
      @ruby_name = "#{name}.rb"
      @json_name = "#{name}.json"
      @recipe    = recipe

      @dir = Pathname.new(File.join('data_bags', @recipe))

      @ruby_path      = @dir.join @ruby_name
      @json_path      = @dir.join @json_name
    end
    
    def create 
      prepare_dir
      create_empty_file
    end

    def decrypt
      data = JSON.parse File.read(json_path)
      secret = Chef::EncryptedDataBagItem.load_secret( key.path )
      encrypted_data = Chef::EncryptedDataBagItem.new(data, secret)
      new_hash = {}
      data.keys.each do |key|
        new_hash[key] = encrypted_data[key]
      end
      file = File.open ruby_path, 'w'
      file.write new_hash.inspect
      file.close
    end

    def encrypt
      data = eval File.read(ruby_path)
      secret = Chef::EncryptedDataBagItem.load_secret( key.path )
      encrypted_data = Chef::EncryptedDataBagItem.encrypt_data_bag_item(data, secret)
      file = File.open json_path, 'w'
      file.write encrypted_data.to_json
      file.close
    end
    
    private 
    
    def key
      Tinychef::Key.new
    end

    def prepare_dir
      dir = Pathname.new(File.join 'data_bags', recipe)
      dir.mkpath unless dir.exist? 
    end
      
    def create_empty_file
      if ruby_path.exist?
        RuntimeError.new 'File #{ruby_path.to_s} already exists.'
      else
        file = File.new ruby_path, 'a'
        file.write %Q^{ "id" => "#{name}" }^
        file.close
      end
    end
      
  end
end
