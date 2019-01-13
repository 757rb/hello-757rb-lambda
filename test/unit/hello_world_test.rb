require 'test_helper'

class HelloWorldTest < HelloSpec
  let(:app) { HelloWorld.new mock_event, mock_context }

  it '#status_code' do
    app.status_code.must_equal 200
  end

  it '#headers' do
    app.headers['Content-Type'].must_equal 'text/html'
  end
end
