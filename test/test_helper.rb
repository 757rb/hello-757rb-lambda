ENV['STAGE'] = 'test'
require 'bundler/setup'
Bundler.require :development, :test
require_relative '../app/app'

require 'minitest/spec'
require 'minitest/pride'
require 'minitest/autorun'
require_relative 'test_helper/mock_response_test_helper'

class HelloSpec < Minitest::Spec
  include MockResponseTestHelper
end
