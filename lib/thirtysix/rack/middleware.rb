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
        start_time = Time.now
        start_objects = ObjectSpace.count_objects_size
        
        status, headers, body = @app.call(env)

        if env["ORIGINAL_FULLPATH"].include? "assets"
          puts "Thirtysix: Skipping instrumentation for assets requests"
        else
          end_objects = ObjectSpace.count_objects_size
          end_time = Time.now

          app_request = Thirtysix::AppRequest.new
          app_request.request_time_in_milliseconds = end_time - start_time
          app_request.build(start_objects, end_objects, env)

          puts app_request.inspect
          push app_request
        end
        
        [status, headers, body]
      end

      def endpoint_uri
        @endpoint_uri ||= URI(ENV['THIRTYSIX_URL'])
      end

      def push(app_request)
        begin
          http = Net::HTTP.new(endpoint_uri.host, endpoint_uri.port)
          http.open_timeout = 0.2
          http.read_timeout = 0.2
          headers = {'Content-Type' => 'text/json', 'X-THIRTYSIX-API-KEY' => ENV['THIRTYSIX_API_KEY']}
          request = Net::HTTP::Post.new(endpoint_uri.request_uri, headers)
          request.body = app_request.to_json
          response = http.request(request)
        rescue Exception => e
          puts "Thirtysix: We could not contact the Thirtysix client [#{e.message}]"
        end        
      end
    end
  end
end