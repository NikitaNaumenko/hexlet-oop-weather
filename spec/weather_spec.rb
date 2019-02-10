RSpec.describe Weather do
  class FakeHTTP
    def get(_url)
      { city: city, weather: 'good' }.to_json
    end
  end

  class FakeWeatherApi
    def initialize(http_client:, api_key:)
      @http_client = http_client
      @api_key = api_key
    end

    def get_info(city:)
      { city: city, weather: 'good' }
    end
  end

  it 'returns info' do
    client = Weather::Client.new(api_key: '1234', http_client: FakeHTTP, service: FakeWeatherApi)
    result = client.get_info(city: 'berlin')
    expect(result[:city]).to eq('berlin')
    expect(result[:weather]).to eq('good')
  end
end
