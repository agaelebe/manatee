module Manatee
  module Sprockets
    class JshProcessor
      def self.call(input)
        instance.call(input)
      end

      def initialize(options = {})
        @namespace = options[:namespace] || self.class.default_namespace
      end

      def call(input)
        data = input[:data].gsub(/$(.)/m, "\\1  ").strip
        key  = input[:name]
        "( function(helper, alias){ #{data}; } ).call(#{@namespace}, #{@namespace}.helper, #{@namespace}.alias);"
      end

      def self.instance
        @instance ||= new
      end

      def self.default_namespace
        'this.Renderer'
      end

      def self.subscribe(env)
        if env.respond_to?(:register_transformer)
          env.register_mime_type 'application/javascript', extensions: ['.jsh'], charset: :js
          env.register_preprocessor 'application/javascript', Manatee::Sprockets::JshProcessor
        end

        if env.respond_to?(:register_engine)
          args = ['.jsh', Manatee::Sprockets::JshProcessor]
          args << { mime_type: 'application/javascript', silence_deprecation: true } if ::Sprockets::VERSION.start_with?("3")
          env.register_engine(*args)
        end

      end
    end
  end
end
