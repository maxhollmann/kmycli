require 'pry'

module KMyCLI
  module CLI
    class Config < Thor
      attr_accessor :settings, :o
      
      def initialize(*args)
        super(*args)
        self.o = OpenStruct.new(options)
        self.settings = Settings.new(File.expand_path(o['config-file']))
      end
      
      desc 'list', 'List configuration variables'
      def list
        key_l = settings.all.keys.map(&:length).max
        settings.all.each do |k, v|
          say "#{k.ljust(key_l)} = #{v}"
        end
      end
      
      desc 'set [key] [value]', 'Set a configuration variable'
      def set(k, v)
        settings.set k, v
      end
    end
  end
end
