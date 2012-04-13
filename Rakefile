require "rspec/core/rake_task" # RSpec 2.0
require './qotd'

RSpec::Core::RakeTask.new(:default) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rspec_opts = ['--backtrace']
  puts "You should run this as root and not root user, since to really run on port 17 you need to be root."
end