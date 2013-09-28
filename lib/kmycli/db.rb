module KMyCLI
  class DB
    def self.connect(file)
      return false unless File.exist?(file)
      ActiveRecord::Base.establish_connection(
        :adapter => 'sqlite3',
        :database => file
      )
      ActiveRecord::Base.connection
      ActiveRecord::Base.connected?
    end
  end
end
