module KMyCLI
  module Models
    class Transaction < ActiveRecord::Base
      self.table_name = "kmmTransactions"
    
      has_many :splits, :foreign_key => "transactionId", :dependent => :destroy
      belongs_to :institution, :foreign_key => "bankId"
      belongs_to :currency, :foreign_key => "currencyId"
      
      validates :currencyId, :presence => true
      validates :entryDate, :presence => true
      validates :postDate, :presence => true
      
      # Needs to be called before add_split
      def build_main_split(account, payee, date = Date.today, memo = nil)
        raise "Transaction has splits already. Call this before adding other splits" if splits.any?
        splits.build(
          :splitId   => 0,
          :payeeId   => payee.id,
          :memo      => memo,
          :postDate  => date,
          :accountId => account.id
        )
      end
      
      def add_split(category, amount, memo = nil)
        raise "build_main_split needs to be called before adding other splits" if splits.empty?
        ms = splits.first
        splits.build(
          :splitId   => splits.size,
          :payeeId   => ms.payeeId,
          :value     => amount,
          :memo      => memo,
          :postDate  => ms.postDate,
          :accountId => category.id
        )
      end
      
      def prepare_for_save
        ms = splits.first
        ms.value = - splits[1..-1].map { |s| s.value.is_a?(String) && s.value.fraction? ? s.value.eval_fraction : s.value.to_f }.sum

        self.entryDate ||= Date.today
        self.postDate ||= ms.postDate || Date.today
        self.txType ||= 'N'
      end
      
      before_save do
        prepare_for_save
        if id.blank?
          self.id = Transaction.next_free_id
        end
      end
      
      def self.next_free_id
        highest = Transaction.order(:id => :desc).first.id[1..-1]
        'T' + (highest.to_i + 1).to_s.rjust(highest.length, '0')
      end
      
      def to_s
        ms = splits.first
        o = [
          "Date:      #{postDate}",
          "Payee:     #{ms.payee.name}",
          "Account:   #{ms.account.path}",
          "Total:     #{ms.value} #{currencyId}"
        ]
        splits[1..-1].each do |s|
          o << "           #{"#{-s.value} #{currencyId}".ljust 20} #{s.account.path}"
        end
        o << "Memo:      #{ms.memo}" if ms.memo.present?
        o.join("\n")
      end
      
    end
  end
end
