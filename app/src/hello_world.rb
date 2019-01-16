class HelloWorld
  attr_reader :event, :context

  def initialize(event, context)
    @event = event
    @context = context
  end

  def perform
    {
      statusCode: status_code,
      body: body,
      headers: headers
    }
  end

  def status_code
    200
  end

  def body
    debug_html
  end

  def headers
    { 'Content-Type' => 'text/html' }
  end

  private

  def plos_search
    @plos_search ||= begin
      qsp = event['queryStringParameters']
      title = qsp && qsp['query'] ? qsp['query'] : 'Ruby'
      PlosSearch.new(title)
    end
  end

  def debug_html
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
          <h2>PLOS Search</h2>
          <code>
            #{CGI::escapeHTML(plos_search.search.inspect)}
          </code>
        </body>
      </html>
    HTML
  end
end
