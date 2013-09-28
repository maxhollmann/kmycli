module KMyCLI
  class Payee < ActiveRecord::Base
    self.table_name = "kmmPayees"
    
    has_many :splits, :foreign_key => "payeeId"
  end
end
