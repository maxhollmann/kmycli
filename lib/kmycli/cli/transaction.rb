require 'pry'

module KMyCLI
  module CLI
    class Transaction < Thor
      attr_accessor :o
      
      def initialize(*args)
        super(*args)
        self.o = OpenStruct.new(options)
      end
      
      desc 'add PAYEE CATEGORY AMOUNT [CATEGORY AMOUNT...]', 'Add a transaction'
      method_option :date,
                    :aliases => '-d'
      method_option :memo,
                    :aliases => '-m'
      def add(account, payee, *splits)
        throw "No splits given" if splits.none?
        throw "AMOUNT for the last split missing" if splits.size.odd?
        
        date = o.date || Date.today
        a = Models::Account.accounts.search_one!(account)
        p = Models::Payee.search_one!(payee)
        
        t = Models::Transaction.new(:currencyId => 'EUR') # TODO use settings.default_currency
        t.build_main_split a, p, date, o.memo
        splits.each_slice(2) do |category, amount|
          amount = amount.to_f
          c = amount > 0 ? Models::Account.expense_categories.search_one!(category)
                         : Models::Account.income_categories.search_one!(category)
          t.add_split c, amount
        end
        
        t.prepare_for_save
        say t.to_s
        if ask("Save the above transaction? [Yn]").downcase == 'y'
          if t.save
            say "Transaction saved.", Thor::Shell::Color::GREEN
          else
            say "Transaction could not be saved.", Thor::Shell::Color::RED
          end
        else
          say "Cancelled.", Thor::Shell::Color::RED
        end
      end
    end
  end
end
