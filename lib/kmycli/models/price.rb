module KMyCLI
  class Price < ActiveRecord::Base
    self.table_name = "kmmPrices"
    
    belongs_to :from, :class_name => "Currency", :foreign_key => "fromId"
    belongs_to :to,   :class_name => "Currency", :foreign_key => "toId"
    
    default_scope { order(:priceDate => :asc) }
    
    def self.to_currency(code)
      where(:toID => code) 
    end
  end
end
