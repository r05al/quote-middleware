class RickyGSays
  def initialize(app)
    @app = app
  end

  def call(env)
    if env['PATH_INFO'] == '/quote'
      request = Rack::Request.new(env)
      case request.request_method
      when 'GET'
        status, headers, response = @app.call(env)
        response.push(" -Ricky Gervais")
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
