module Thirtysix
  module Rack
    class Railtie < ::Rails::Railtie
      initializer 'thirtysix.middleware' do |app|
        puts "Thirtysix: Running Railtie"
        app.middleware.use Thirtysix::Rack::Middleware
      end
    end
  end
end