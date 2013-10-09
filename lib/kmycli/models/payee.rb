module KMyCLI
  module Models
    class Payee < ActiveRecord::Base
      self.table_name = "kmmPayees"
    
      has_many :splits, :foreign_key => "payeeId"
      
      def self.search(query)
        where("name LIKE ?", "%#{query.gsub('*', '%')}%")
      end
      def self.search!(query)
        r = search(query)
        raise "Could not find any payee matching '#{query}'" if r.none?
        r
      end
      def self.search_one(query)
        search(query).first
      end
      def self.search_one!(query)
        search!(query).first
      end
    end
  end
end
