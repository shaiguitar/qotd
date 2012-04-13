require 'socket'
require 'thread'

class MissingQuoteFile < StandardError; end
  
class QOTDServer
  
  def self.root_user?
    ENV["USER"] == "root"
  end

  attr_accessor :quotes
  
  def initialize(path="quotes.txt",is_daemon = false)
    is_root_or_abort
    @quotes = File.open(path,"r").readlines.map{|q| q.chomp }
    @is_daemon = is_daemon
    rescue Errno::ENOENT
      raise MissingQuoteFile, "You must initialize with a quotes file!"
  end
  
  def random_quote
    @quotes[rand(@quotes.length)]
  end
  
  def run!
    @server = TCPServer.new 17 # Server bind to port 2000
    if @is_daemon
      do_thing
    else
      Thread.new { do_thing }
    end
  end  
  
  private
  
  def do_thing
    loop do
      @client = @server.accept    # Wait for a client to connect
      @client.puts random_quote
      @client.close
    end
  end
  
  def is_root_or_abort
    if !QOTDServer.root_user?
      abort "You must run QOTD as root, since it needs to bind to port 17 as RFC865 defines!"
    end
  end
  
end

if __FILE__ == $0
  puts "Running for file #{ARGV[0]} as a daemon...try `nc localhost 17`"
  QOTDServer.new(ARGV[0], true).run!
end