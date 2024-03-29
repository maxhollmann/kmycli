require 'rubygems'
require 'sqlite3'
require 'active_record'
require 'thor'
require 'inifile'
require 'ostruct'
require 'awesome_print' # TODO require only in development

require 'kmycli/ext/fraction.rb'
require 'kmycli/version'

module KMyCLI
  LIBRARY_PATH = File.join(File.dirname(__FILE__), 'kmycli')
  MODELS_PATH  = File.join(LIBRARY_PATH, 'models')
  CLI_PATH     = File.join(LIBRARY_PATH, 'cli')
  
  autoload :DB,             File.join(LIBRARY_PATH, 'db')
  autoload :Settings,       File.join(LIBRARY_PATH, 'settings')
  
  module Models
    autoload :Price,        File.join(MODELS_PATH, 'price')
    autoload :Transaction,  File.join(MODELS_PATH, 'transaction')
    autoload :Split,        File.join(MODELS_PATH, 'split')
    autoload :Currency,     File.join(MODELS_PATH, 'currency')
    autoload :Account,      File.join(MODELS_PATH, 'account')
    autoload :Payee,        File.join(MODELS_PATH, 'payee')
    autoload :Institution,  File.join(MODELS_PATH, 'institution')
    autoload :KVPair,       File.join(MODELS_PATH, 'kv_pair')
  end
  
  module CLI
    autoload :CLI,          File.join(CLI_PATH, 'cli')
    autoload :Price,        File.join(CLI_PATH, 'price')
    autoload :Transaction,  File.join(CLI_PATH, 'transaction')
    autoload :Config,       File.join(CLI_PATH, 'config')
  end
end

