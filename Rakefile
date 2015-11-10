require "bundler/gem_tasks"
require "rspec/core/rake_task"

require_relative "lib/codebreaker"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

task :play do
  Codebreaker::ConsoleInterface.new
end
