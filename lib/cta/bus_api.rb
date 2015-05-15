require 'net/http'
require 'nokogiri'
require 'json'
require 'active_support/core_ext/hash'
require 'time'

module CTA
  class MissingAPIKeyException < ArgumentError

  end
  class BusAPI
    DEFAULT_BASE_URL  = 'http://www.ctabustracker.com/bustime/api/v1'

    attr_accessor :api_key

    def initialize(api_key,base_url=nil)
      raise CTA::MissingAPIKeyException.new("Must specify valid api_key prior to using library") if api_key.nil?
      @api_key = api_key
      @base_url = base_url || BusAPI::DEFAULT_BASE_URL
    end

    def get_time()
      url_params = {:key => @api_key}
      uri = URI("#{@base_url}/gettime")
      uri.query = URI.encode_www_form(url_params)
      Time.parse(_get(uri)["bustime_response"]["tm"])
    end

    def get_vehicles(url_params={})
      url_params[:route_id] = url_params[:route_id].join(".") if url_params[:route_id].kind_of?(Array)
      url_params[:vehicle_id] = url_params[:vehicle_id].join(".") if url_params[:vehicle_id].kind_of?(Array)

      result = _get("#{@base_url}/getvehicles", url_params)
      result["bustime_response"]["vehicle"].map do |vehicle_array|
        vehicle_array["tmstmp"] = Time.parse(vehicle_array["tmstmp"])
        vehicle_array
      end
    end

    def get_routes
      result = _get("#{@base_url}/getroutes")
      result["bustime_response"]["route"]
    end

    def directions(route_id)
      route_id = route_id.join(",") if route_id.is_a?(Array)
      result = _get("#{@base_url}/getdirections", {:rt => route_id})
      result["bustime_response"]["dir"]
    end

    def _extract_response(result)
      return nil unless result.is_a?(Net::HTTPSuccess)
      response_json = Hash.from_xml(result.body)
      response_json
    end

    def _get(base_url,url_params={})
      uri = URI(base_url)
      uri.query = URI.encode_www_form(url_params.merge({:key => @api_key}))

      result = Net::HTTP.get_response(uri)
      _extract_response(result)
    end

    def _put(uri,options=nil)
      request = Net::HTTP::Post.new(uri)
      if options
        request.set_form_data(options)
      end
      _extract_response(result)
    end
  end
end
