require File.expand_path(File.join(File.dirname(__FILE__) + '/../', 'qotd'))
require 'timeout'

describe QOTDServer do
  
  def server_is_running_on_port? 
    !`sudo lsof -i :17`.empty?
  end
  
  before(:each) do
    @qotd_server = QOTDServer.new("spec/quotes.txt")
  end
  
  if QOTDServer.root_user?
    it "runs on port 17 if you are root" do
      server_is_running_on_port?.should be_false
      @qotd_server.run!
      server_is_running_on_port?.should be_true
    end
  else
    it "fails if you are not root" do
      lambda {
        @qotd_server.run!
      }.should raise_error
    end
  end
  
  it "reads quotes from a file split by newlines" do
    @qotd_server.quotes.first.should_not be_empty
  end
  
  it "bombs out if no file is found" do
    lambda { QOTDServer.new("no_such_file.txt") }.should raise_error MissingQuoteFile
  end
  
  it "outputs random quotes from the quote list" do
    @qotd_server.quotes.should include @qotd_server.random_quote
  end
  
  it "can be a blocking daemon or a in process thread" do
    Timeout::timeout(3) {
      daemon_server = QOTDServer.new("spec/quotes.txt", true)
      server_is_running_on_port?.should be_true
    }
  end
end
