require 'pry'

module KMyCLI
  module CLI
    class CLI < Thor
      attr_accessor :settings
    
      method_option "config-file", :default => File.expand_path(File.join("~", ".kmycli"))
      method_option "database"
      def initialize(*args)
        super(*args)
      
        self.settings = Settings.new(File.expand_path(options['config-file']))
        settings.merge!(options.select { |k, v| %w(
          database
        ).include?(k) })
      
        unless DB.connect File.expand_path(settings.database)
          raise Thor::Error.new("Could not open database '#{settings.database}'")
        end
      end
    
      desc 'test', 'Test task'
      def test
        p = Currency.find('BTC').prices_from.to_currency('EUR')
        puts p.map { |p| p.price.eval_fraction }
      end
    
      desc 'console', 'Open a console'
      map 'c' => 'console'
      def console
        binding.pry
      end
    
      desc 'version', 'Display installed KMyCLI version'
      map '-v' => :version
      def version
        puts "KMyCLI #{VERSION}"
      end
      
      register Price, :price, "price", "Price functions"
    end
  end
end
