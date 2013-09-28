module KMyCLI
  module Models
    class Transaction < ActiveRecord::Base
      self.table_name = "kmmTransactions"
    
      has_many :splits, :foreign_key => "transactionId"
      has_many :transactions, :foreign_key => "currencyId"
      belongs_to :institution, :foreign_key => "bankId"
      belongs_to :currency, :foreign_key => "currencyId"
    end
  end
end
