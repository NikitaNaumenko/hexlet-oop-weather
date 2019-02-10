require 'weather/version'
require 'JSON'

module Weather
  class Error < StandardError; end
  # Your code goes here...
  class Client
    def initialize(config)
      http_client = config[:http_client]
      api_key = config[:api_key]
      @service = config[:service].new(http_client: http_client,
                                      api_key: api_key)
    end

    def get_info(city:)
      @service.get_info(city: city)
    end
  end

  class MetaWeather
    HOST = 'www.metaweather.com'.freeze

    def initialize(http_client:, api_key: nil)
      @http_client = http_client
      @api_key = api_key
    end

    def get_info(city:)
      woeid_url = URI::HTTPS.build(host: HOST,
                                   path: '/api/location/search/',
                                   query: "query=#{city}")
      woeid = JSON.parse(@http_client.get(woeid_url)).first['woeid']
      weather_url = URI::HTTPS.build(host: HOST,
                                     path: "/api/location/#{woeid}/")
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
      url = URI::HTTPS.build(host: HOST,
                             path: '/v1/current.json',
                             query: "key=#{@api_key}&q=#{city}")
      @http_client.get(url)
    end
  end
end
