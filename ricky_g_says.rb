class RickyGSays
  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, response = @app.call(env)
    response.push(" -Ricky Gervais")
    [status, headers, response]
  end
end
