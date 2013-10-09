module KMyCLI
  module CLI
    class Transaction < Thor
      attr_accessor :o
      
      def initialize(*args)
        super(*args)
        self.o = OpenStruct.new(options)
      end
      
      desc 'add ACCOUNT PAYEE CATEGORY AMOUNT [CATEGORY AMOUNT...]', 'Add a transaction'
      method_option :date,
                    :aliases => '-d'
      method_option :memo,
                    :aliases => '-m'
      def add(account, payee, *splits)
        t = build_transaction(o.date || Date.today, account, payee, splits, o.memo)
        say t.to_s
        if ask("Save the above transaction? [Yn]") =~ /^y/i
          if t.save
            say "Transaction saved.", Thor::Shell::Color::GREEN
          else
            say "Transaction could not be saved.", Thor::Shell::Color::RED
          end
        else
          say "Cancelled.", Thor::Shell::Color::RED
        end
      end
      
      desc 'import [FILE] [FILE...]', 'Import transactions from files'
      method_option 'force',
                    :type => :boolean
      def import(*files)
        transactions = []
        skipped      = []
        
        read_stream = Proc.new do |stream|
          date = Date.today
          stream.each do |line|
            line.chomp!
            # TODO be more lenient with date formats
            if line =~ /^\d{4}-\d{2}-\d{2}/
              date = DateTime.iso8601(line)
            elsif line =~ /^\d{2}-\d{2}/
              date = DateTime.iso8601("#{Date.today.year}-#{line}")
            elsif line =~ /^\d{2}/
              date = DateTime.iso8601("#{Date.today.year}-#{Date.today.month.to_s.rjust(2, '0')}-#{line}")
            else
              args = Shellwords.shellwords(line)
              if args.size >= 4
                begin
                  t = build_transaction(date, args[0], args[1], args[2..-1])
                  transactions << t
                  raise "Invalid transaction" unless t.valid?
                rescue => e
                  skipped << [line, e.message]
                end
              else
                skipped << [line, "Not enough arguments"] if args.size > 0
              end
            end
          end
        end
        
        if files.nil? || files.empty?
          read_stream.call(STDIN)
        else
          files.each do |file|
            File.open(file, 'r', &read_stream)
          end
        end
        
        if skipped.any?
          say "Skipped (#{skipped.size}):", Thor::Shell::Color::RED
          say "#{skipped.map { |l, m| "\"#{l}\" (#{m})" }.join("\n")}\n\n"
        end
        
        if transactions.any?
          say transactions.map(&:to_s).join("\n\n") + "\n"*2
          if o.force || ask("Save the above transactions? [Yn]") =~ /^y/i
            saved = 0
            transactions.each do |t|
              if t.save
                saved += 1
              else
                puts "Invalid:\n#{t.to_s}\n"
              end
            end
            say "Saved #{saved} transactions", Thor::Shell::Color::GREEN
          else
            say "Cancelled.", Thor::Shell::Color::RED
          end
        else
          say "No transactions found"
        end
      end
      
      
      no_commands do
        def build_transaction(date, account, payee, splits, memo = nil)
          raise "No splits given" if splits.none?
          raise "AMOUNT for the last split missing" if splits.size.odd?
          
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
          t
        end
      end
    end
  end
end
