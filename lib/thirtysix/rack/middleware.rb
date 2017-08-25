require 'objspace'
require 'thirtysix/app_request'
require 'thirtysix/rack/railtie' if defined?(Rails)

module Thirtysix
  module Rack
    class Middleware
      def initialize(app)
        puts "Thirtysix: Initializing Middleware"
        @app = app
      end

      def call(env)
        start_time    = Time.now
        start_memory  = get_memory
        start_objects = ObjectSpace.count_objects_size
        
        status, headers, body = @app.call(env)

        if env["ORIGINAL_FULLPATH"].include? "assets"
          puts "Thirtysix: Skipping instrumentation for assets requests"
        else
          end_time    = Time.now
          end_memory  = get_memory
          end_objects = ObjectSpace.count_objects_size

          app_request = Thirtysix::AppRequest.new
          app_request.request_time_in_milliseconds = ((end_time - start_time) * 1000).to_i
          app_request.memory_in_mb = end_memory - start_memory
          app_request.build(start_objects, end_objects, env)

          push app_request
        end
        
        [status, headers, body]
      end

      #
      # Returns current process' memory usage in MB
      # Returns nil if any error occurred
      # Only works on Darwin10
      # Shamelessly stolen from: 
      #   https://github.com/newrelic/rpm/blob/master/lib/new_relic/agent/samplers/memory_sampler.rb
      #
      def get_memory
        (`ps -o rss #{$$}`.split("\n")[1].to_f / 1024.0) rescue nil
      end

      def thirtysix_api_key
        ENV['THIRTYSIX_API_KEY']
      end

      def thirtysix_url
        ENV['THIRTYSIX_URL']
      end

      def thirtysix_path
        "/api/app_requests"
      end

      def endpoint_uri
        @endpoint_uri ||= URI(thirtysix_url + thirtysix_path)
      end

      def push(app_request)
        begin
          http = Net::HTTP.new(endpoint_uri.host, endpoint_uri.port)
          http.open_timeout = 0.2
          http.read_timeout = 0.2
          headers = {'Content-Type' => 'text/json', 'X-THIRTYSIX-API-KEY' => thirtysix_api_key}
          request = Net::HTTP::Post.new(endpoint_uri.request_uri, headers)
          request.body = app_request.to_json
          response = http.request(request)
        rescue Exception => e
          puts "Thirtysix: We could not contact the Thirtysix client on #{thirtysix_url} [#{e.message}]"
        end        
      end
    end
  end
end