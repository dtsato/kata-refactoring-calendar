require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

RSpec::Core::RakeTask.new(:acceptance) do |t|
  t.pattern = 'spec/acceptance_tests.rb'
end

RSpec::Core::RakeTask.new(:rcov) do |t|
  t.rcov = true
  t.rcov_opts = ['--exclude', 'gems,spec,helper']
end

task :default => :spec