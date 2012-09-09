require 'logger'
require 'fileutils'

root = ::File.dirname(__FILE__)
environment = ENV['RACK_ENV'] || 'development'
logfile = ::File.join(root, 'log', "#{environment}.log")

FileUtils.mkdir_p(::File.dirname(logfile))

class IOLikeLogger < Logger
	alias_method :write, :<<
end
logger = IOLikeLogger.new(logfile, 'daily') #'daily' || 'weekly'

use Rack::CommonLogger, logger
STDERR.reopen(logfile)

require 'produtos_api'
run ProdutosApi