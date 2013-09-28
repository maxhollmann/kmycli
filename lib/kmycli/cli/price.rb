require 'pry'

module KMyCLI
  module CLI
    class Price < Thor
      desc 'list [currency] [to currency]', 'List all prices of the currency, optionally only to one other currency'
      def list(currency = nil, to_currency = nil)
        if currency.nil?
          c = Currency.find(currency)
          prices = c.prices_from
        else
          prices = Model::Price.all
        end
        prices = prices.to_currency(Currency.find(to_currency)) unless to_currency.nil?
        prices.each do |p|
          say "#{p.priceDate}\t#{p.price.eval_fraction} #{p.to.ISOcode}"
        end
      end
    end
  end
end
