module KMyCLI
  class Settings
    attr_accessor :inifile, :settings
    
    def initialize(file)
      self.inifile = IniFile.load(file)
      self.settings = {
      }.merge(inifile['global'])
    end
    
    def merge!(options)
      self.settings.merge!(options.reject { |k, v| v.nil? })
    end
    
    def method_missing(key, *args)
      key = key.to_s
      if key.end_with? "="
        settings[key.chomp("=")] = args[0]
      else
        settings[key]
      end
    end
  end
end
