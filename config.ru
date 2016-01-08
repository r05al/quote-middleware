require './my_app'
require './ricky_g_says'
use Rack::Reloader
use RickyGSays
run MyApp.new
