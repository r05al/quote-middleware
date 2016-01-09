class RickyGSays
  def initialize(app)
    @app = app
    @quotes = RickyText.new
  end

  def call(env)
    if env['PATH_INFO'] == '/quote'
      request = Rack::Request.new(env)
      case request.request_method
      when 'GET'
        status, headers, response = @app.call(env)
        response.push("\n" + @quotes.random_quote + " -Ricky Gervais")
        [status, headers, response]
      when 'POST'
        [404, {}, [""]]
      else
        @app.call(env)
      end
    else
      @app.call(env)
    end
  end
end

class RickyText
  attr_reader :quotes

  def initialize
    @quotes = IO.readlines('./fixtures/rickygervais.txt')
  end

  def random_quote
    @quotes[rand(@quotes.length)]
  end
end
