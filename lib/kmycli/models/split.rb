module KMyCLI
  class Split < ActiveRecord::Base
    self.table_name = "kmmSplits"
    
    belongs_to :transaction, :foreign_key => "transactionId"
    belongs_to :payee, :foreign_key => "payeeId"
    belongs_to :account, :foreign_key => "accountId"
  end
end
