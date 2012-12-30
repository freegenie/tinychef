module Tinychef 
  class DataBag
    
    OPTIONS_ERROR = <<-EOH
Required arguments:

  RECIPE:   Databags must be archived under the name of a recipe.
  NAME:     Name of this databag. 
  
EOH
    
    attr_reader :recipe, :name, :file_name, :path
    
    def initialize(recipe, name)
      
      if recipe.nil? || name.nil? 
        raise OptionsError.new OPTIONS_ERROR 
      end
      
      @name = name 
      @file_name = "#{name}.rb"      
      @recipe = recipe
    end
    
    def create 
      prepare_dir
      create_empty_file
    end
    
    private 
    
    def prepare_dir
      dir = Pathname.new(File.join 'data_bags', recipe)
      dir.mkpath unless dir.exist? 
    end
      
    def create_empty_file
      @path = Pathname.new(File.join 'data_bags', recipe, file_name)
      if path.exist? 
        RuntimeError.new 'File #{path.to_s} already exists.'
      else
        file = File.new path, 'a'
        file.write %Q^{
  "id" => "#{name}"
}
^
        file.close
      end
    end
      
  end
end