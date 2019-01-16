require 'uri'
require 'cgi'
require 'json'
require 'faraday'
require 'nokogiri'
require 'active_support/core_ext/hash'
require 'active_support/xml_mini'
require 'aws-record'

ActiveSupport::XmlMini.backend = 'Nokogiri'

require_relative 'src/myenv'
require_relative 'src/hello_world'
require_relative 'src/plos_search'
require_relative 'src/plos_search_table'

PlosSearchTable.create!

def handler(event:, context:)
  HelloWorld.new(event, context).perform
end
