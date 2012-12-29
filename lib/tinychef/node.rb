require 'pathname'

module Tinychef
  class Node
    
    EXT = '.json'
    
    class NofileError < Exception; end 
    
    attr_reader :name, :path
    
    def initialize(name)
      @name = name
      normalize_name
      find_file
    end 
    
    def host
      path.basename.to_s.gsub(EXT, '')
    end
    
    private 
    
    def find_file
      path = Pathname.new(File.join 'nodes', name)
      path = Pathname.new(name) unless path.exist? 
      raise NofileError unless path.exist?
      @path = path
    end
    
    def normalize_name
      unless json_extension? 
        @name = "#{name}#{EXT}"
      end
    end
    
    def json_extension? 
      name.end_with? EXT
    end
  end
end