require 'cgi'
require 'json'

require_relative 'src/hello_world'

def handler(event:, context:)
  HelloWorld.new(event, context).perform
end
