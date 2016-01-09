require 'rspec'
require 'rack'
require './my_app'
require './ricky_g_says'
require './loud'

describe RickyGSays do
  describe "#call" do
    let(:app) { MyApp.new }
    let(:middleware) { RickyGSays.new(app) }
    let(:request) { Rack::MockRequest.new(middleware) }

    describe 'get /quote request' do
      let(:response) { request.get('/quote') }
      let(:quotes) { RickyText.new.quotes }

      it 'appends a quote to the body' do
        expect(quotes).to include(response.body.split("\n")[1] + "\n")
      end

      it 'has text/plain content-type' do
        expect(response.headers["Content-Type"]).to eq("text/plain")
      end
    end

    describe 'post request' do
      let(:response) { request.post('/quote') }

      it 'has an error response' do
        expect(response.client_error?).to be true
      end

      it 'returns status 404' do
        expect(response.status).to eq(404)
      end

      it 'returns an empty body' do
        expect(response.body).to be_empty
      end
    end

    describe 'get /quote request through Loud middleware' do
      let(:loud_middleware) { Loud.new(middleware) }
      let(:loud_request) { Rack::MockRequest.new(loud_middleware) }
      let(:loud_response) { loud_request.get('/quote') }

      it 'returns status 200' do
        expect(loud_response.status).to eq(200)
      end
    end
  end
end
