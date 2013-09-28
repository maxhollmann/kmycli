module KMyCLI
  class Institution < ActiveRecord::Base
    self.table_name = "kmmInstitutions"
    
    has_many :transactions, :foreign_key => "bankId"
    has_many :accounts, :foreign_key => "institutionId"
  end
end
