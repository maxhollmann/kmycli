require 'pry'

module KMyCLI
  module CLI
    class Price < Thor
      attr_accessor :o
      
      def initialize(*args)
        super(*args)
        self.o = OpenStruct.new(options)
      end
      
      desc 'list', 'List prices'
      method_option 'from',
                    :aliases => "-f"
      method_option 'to',
                    :aliases => "-t"
      method_option 'date',
                    :aliases => "-d"
      def list
        prices = Models::Price.all
        prices = prices.from_currency(o.from) if o.from.present?
        prices = prices.to_currency(Models::Currency.find(o.to)) unless o.to.nil?
        prices = prices.where(:priceDate => o.date) if o.date.present?
        list_prices prices.order(:priceDate => :asc)
      end
      
      desc 'add', 'Add conversion rate for a currency to another currency'
      method_option 'from',
                    :aliases => "-f"
      method_option 'to',
                    :aliases => "-t"
      method_option 'price',
                    :aliases => "-p"
      method_option 'date',
                    :aliases => "-d"
      method_option 'no-inverse',
                    :aliases => "-n",
                    :type => :boolean
      method_option 'force',
                    :type => :boolean
      def add
        o.from ||= ask("From currency:")
        o.to ||= ask("To currency:")
        o.price ||= ask("Price:")
        o.date ||= ask("Date (default: #{Date.today.iso8601})")
        o.date = Date.today.iso8601 unless o.date.present?
        
        date = Date.iso8601(o.date)
        prices = [
          new_price(o.from, o.to, o.price, date),
          new_price(o.to, o.from, 1.0 / o.price.to_f, date)
        ]
        list_prices prices
        if o.force || ask("Create the above prices? [Yn]").downcase == 'y'
          prices.each do |p|
            say ""
            if p.save
              say "Price was added successfully:", Thor::Shell::Color::GREEN
              list_prices [p]
            else
              say "Couldn't save price:", Thor::Shell::Color::RED
              list_prices [p]
              say p.errors.full_messages.join("\n")
            end
          end
        else
          say "Cancelled.", Thor::Shell::Color::RED
        end
      end
      
      desc 'delete', 'Delete conversion rates matching the options'
      method_option 'from',
                    :aliases => "-f"
      method_option 'to',
                    :aliases => "-t"
      method_option 'price',
                    :aliases => "-p"
      method_option 'date',
                    :aliases => "-d"
      method_option 'force',
                    :type => :boolean
      def delete
        prices = Models::Price.all
        prices = prices.where(:fromId => o.from) if o.from.present?
        prices = prices.where(:toId => o.to) if o.to.present?
        prices = prices.where(:priceDate => o.date) if o.date.present?
        
        list_prices prices
        if o.force || ask("Delete the above prices? Type 'yes' to confirm (or run with the --force option)").downcase == 'yes'
          n = prices.delete_all
          puts "Deleted #{n} prices.", Thor::Shell::Color::GREEN
        else
          say "Cancelled.", Thor::Shell::Color::RED
        end
      end
      
      no_commands do
        def list_prices(prices)
          prices.each do |p|
            say "#{p.priceDate}\t#{p.fromId} -> #{p.toId}\t#{p.price.eval_fraction}"
          end
        end
        
        def new_price(from, to, price, date)
          Models::Price.new({
            :from      => Models::Currency.find(from),
            :to        => Models::Currency.find(to),
            :price     => price.to_f.to_fraction_s,
            :priceDate => date
          })
        end
      end
    end
  end
end
