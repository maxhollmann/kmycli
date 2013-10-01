module KMyCLI
  module Models
    class Split < ActiveRecord::Base
      self.table_name = "kmmSplits"
    
      belongs_to :transaction, :foreign_key => "transactionId"
      belongs_to :payee, :foreign_key => "payeeId"
      belongs_to :account, :foreign_key => "accountId"
      
      before_save do
        self.txType ||= 'N'
        self.postDate ||= Date.today
        self.reconcileFlag ||= "0"
        
        self.value = shares if value.nil? && shares.present?
        self.shares = value if shares.nil? && value.present?
        self.value = value.to_f.to_fraction_s unless value.is_a?(String) && value.fraction?
        self.valueFormatted = value.eval_fraction.round(2).to_s
        self.shares = shares.to_f.to_fraction_s unless shares.is_a?(String) && shares.fraction?
        self.sharesFormatted = shares.eval_fraction.round(2).to_s
      end
    end
  end
end
