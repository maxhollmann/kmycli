module KMyCLI
  class Currency < ActiveRecord::Base
    self.table_name = "kmmCurrencies"
    self.primary_key = "ISOcode"
    self.inheritance_column = nil
    
    has_many :prices_to,   :class_name => "Price", :foreign_key => "toId"
    has_many :prices_from, :class_name => "Price", :foreign_key => "fromId"
    has_many :transactions, :foreign_key => "currencyId"
    has_many :accounts, :foreign_key => "currencyId"
  end
end
