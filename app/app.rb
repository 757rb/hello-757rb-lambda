require 'httparty'
require 'json'

def helloworld(event:, context:)
  {
    statusCode: 200,
    body: debug_html(event, context),
    headers: {
      'Content-Type' => 'text/html'
    }
  }
end

private

def debug_html(event, context)
  <<-HTML
    <!DOCTYPE html>
    <html>
      <body>
        <h1>Hello 757rb Lambda</h1>
        <h2>Event</h2>
        <pre>
          #{JSON.pretty_generate(event)}
        </pre>
        <h2>#{context.class.name}</h2>
        <code>
          #{CGI::escapeHTML(context.inspect)}
        </code>
        <h2>Environment</h2>
        <pre>
          #{JSON.pretty_generate(ENV.to_h)}
        </pre>
      </body>
    </html>
  HTML
end
