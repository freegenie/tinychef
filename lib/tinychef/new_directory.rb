require 'pathname'
require 'fileutils'

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

      copy_solo_file
    end

    def copy_solo_file
      solo_file = Pathname.new(File.join(File.expand_path('../../../files', __FILE__), 'solo.rb'))
      FileUtils.cp solo_file, path.join('solo.rb')
    end
  end
end
