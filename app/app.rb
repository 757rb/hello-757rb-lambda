require 'uri'
require 'cgi'
require 'json'
require 'faraday'
require 'nokogiri'
require 'active_support/core_ext/hash'
require 'active_support/xml_mini'

ActiveSupport::XmlMini.backend = 'Nokogiri'

require_relative 'src/hello_world'
require_relative 'src/plos_search'

def handler(event:, context:)
  HelloWorld.new(event, context).perform
end
