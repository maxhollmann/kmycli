module KMyCLI
  module Models
    class Price < ActiveRecord::Base
      self.table_name = "kmmPrices"
    
      belongs_to :from, :class_name => "Currency", :foreign_key => "fromId"
      belongs_to :to,   :class_name => "Currency", :foreign_key => "toId"
      
      validates :priceDate, :uniqueness => { :scope => [:fromId, :toId] }
    
      default_scope { order(:priceDate => :asc).where("LENGTH(fromId) = 3") }
    
      def self.to_currency(code)
        where(:toId => code) 
      end
      def self.from_currency(code)
        where(:fromId => code) 
      end
      
      before_save do
        self.price = price.to_f.to_fraction_s unless price.is_a?(String) && price.fraction?
        self.priceFormatted = price.eval_fraction.round(2).to_s
      end
    end
  end
end
