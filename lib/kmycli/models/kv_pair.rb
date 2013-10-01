module KMyCLI
  module Models
    class KVPair < ActiveRecord::Base
      self.table_name = "kmmKeyValuePairs"
      self.primary_key = "kvpKey"
      
      def self.get(key)
        find(key).kvpData
      end
      
      def readonly?
        true
      end
    end
  end
end
