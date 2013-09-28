module KMyCLI
  module Models
    class Account < ActiveRecord::Base
      self.table_name = "kmmAccounts"
    
      has_many :children, :class_name => "Account", :foreign_key => "parentId"
      has_many :splits, :foreign_key => "accountId"
      belongs_to :institution, :foreign_key => "institutionId"
      belongs_to :parent, :class_name => "Account", :foreign_key => "parentId"
      belongs_to :currency, :foreign_key => "currencyId"
    end
  end
end
