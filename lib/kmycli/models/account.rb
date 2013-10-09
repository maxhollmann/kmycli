module KMyCLI
  module Models
    class Account < ActiveRecord::Base
      self.table_name = "kmmAccounts"
    
      has_many :children, :class_name => "Account", :foreign_key => "parentId"
      has_many :splits, :foreign_key => "accountId"
      belongs_to :institution, :foreign_key => "institutionId"
      belongs_to :parent, :class_name => "Account", :foreign_key => "parentId"
      belongs_to :currency, :foreign_key => "currencyId"
      
      def path
        parent.present? ? "#{parent.path}:#{accountName}" : accountName
      end
      
      def income_category?
        accountType == '12'
      end
      def expense_category?
        accountType == '13'
      end
      
      def self.categories
        where(:accountType => %w(12 13))
      end
      def self.income_categories
        where(:accountType => '12')
      end
      def self.expense_categories
        where(:accountType => '13')
      end
      def self.accounts
        where(:accountType => %w(1 2 3 4 9)) # TODO complete list of account types
      end
      
      def self.search(query)
        where("accountName LIKE ?", "%#{query.gsub('*', '%')}%")
      end
      def self.search!(query)
        r = search(query)
        raise "Could not find any account matching '#{query}'" if r.none?
        r
      end
      def self.search_one(query)
        search(query).first
      end
      def self.search_one!(query)
        search!(query).first
      end
    end
  end
end
