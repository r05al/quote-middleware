class Loud
  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, response = @app.call(env)
    response.map!(&:upcase)
    [status, headers, response]
  end
end
