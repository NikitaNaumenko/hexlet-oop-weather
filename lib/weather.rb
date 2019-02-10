require 'weather/version'
require 'JSON'

module Weather
  class Error < StandardError; end
  # Your code goes here...
  class Client
    def initialize(config)
      @http_client = config[:http_client]
      @service = config[:service] || MetaWeather
      @api_key = config[:api_key]
    end

    def get_info(city:)
      service = @service.new(http_client: @http_client, api_key: @api_key)
      service.get_info(city: city)
    end
  end

  class MetaWeather
    HOST = 'www.metaweather.com'.freeze

    def initialize(http_client:, api_key: nil)
      @http_client = http_client
      @api_key = api_key
    end

    def get_info(city:)
      woeid_url = URI("https://#{HOST}/api/location/search/?query=#{city}")
      woeid = JSON.parse(@http_client.get(woeid_url)).first['woeid']
      weather_url = URI("https://#{HOST}/api/location/#{woeid}/")
      result = @http_client.get(weather_url)
      JSON.parse(result)
    end
  end

  class Apixu
    HOST = 'api.apixu.com'.freeze

    def initialize(http_client:, api_key:)
      @http_client = http_client
      @api_key = api_key
    end

    def get_info(city:)
      url = URI("https://#{HOST}/v1/current.json?key=#{@api_key}&q=#{city}")
      @http_client.get(url)
    end
  end
end
