require 'rubygems'
require 'chef/encrypted_data_bag_item'
require 'pp'

require "tinychef/version"
require 'tinychef/key'
require 'tinychef/data_bag'
require 'tinychef/boot_script'
require 'tinychef/node_run'

module Tinychef
  class OptionsError < Exception; end
end

