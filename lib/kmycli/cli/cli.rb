require 'pry'

module KMyCLI
  module CLI
    class CLI < Thor
      attr_accessor :settings, :o
    
      method_option "config-file",
                    :default => File.expand_path(File.join("~", ".kmycli"))
      method_option "database"
      def initialize(*args)
        super(*args)
      
        self.o = OpenStruct.new(options)
        
        self.settings = Settings.new(File.expand_path(options['config-file']))
        settings.merge!(options.select { |k, v| %w(
          database
        ).include?(k) })
      
        unless DB.connect File.expand_path(settings.database)
          raise Thor::Error.new("Could not open database '#{settings.database}'")
        end
        
        settings.default_currency = Models::KVPair.get('kmm-baseCurrency')
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
      
      register Price, :price, "price", "Price commands"
      register Transaction, :transaction, "transaction", "Transaction commands"
      register Config, :config, "config", "Configuration commands"
    end
  end
end
