require 'pathname'

module Tinychef
  class NewDirectory

    DIR_MAP = {
      'cookbooks' => nil,
      'data_bags' => nil,
      'imported_cookbooks' => nil,
      'nodes' => nil,
      'roles' => nil,
      'vendor' => nil,
    }

    attr_reader :path

    def initialize(name)
      @path = Pathname.new(name)
    end

    def create
      path.mkpath unless path.exist?

      DIR_MAP.each do |key, value|
        path.join(key).mkpath
      end
    end
  end
end
