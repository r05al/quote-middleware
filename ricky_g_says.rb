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
    elsif env['PATH_INFO'] == '/qod'
      status, headers, response = @app.call(env)
      response.push("\n" + TheySaidSo.new.quote)
      [status, headers, response]
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

class TheySaidSo
  require 'httparty'
  include HTTParty
  base_uri 'api.theysaidso.com'
  attr_reader :qod_response

  def initialize
    @qod_response = qod
  end

  def qod
    self.class.get("/qod")
  end

  def random
    self.class.get("/quote?api_key=<key>")
  end

  def quote
    qod_response["contents"]["quotes"][0]["quote"] +
    " -" +
    qod_response["contents"]["quotes"][0]["author"]
  end
end
