class MyApp
  def call(env)
    [200, { "Content-Type" => "text/plain" }, ["Application's Response"]]
  end
end
