require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "loop_dance"
  gem.homepage = "http://github.com/dapi/loop_dance"
  gem.license = "MIT"
  gem.summary = %Q{Daemon builder and controller. Easy setup and managed from the rails application or rake tasks. Autostart at rails server startup}   # ' anti ruby-mode
  # Simple scheduler daemon. It's managed from ruby application or by rake tasks
  gem.description = %Q{Really simple daemon builder and manager. Based on the looper and daemon_controller}
  gem.email = "danil@orionet.ru"
  gem.authors = ["Danil Pismenny"]
  # Include your dependencies below. Runtime dependencies are required when using your gem,
  # and development dependencies are only needed for development (ie running rake tasks, tests, etc)
  # gem.add_runtime_dependency 'daemon_controller', '>= 0.2.5'
  # gem.add_runtime_dependency 'active_support', '>= 3.0'
  # gem.add_runtime_dependency 'i18n'
  # gem.add_development_dependency 'rspec'
  # gem.add_development_dependency 'jeweler'
  # gem.add_development_dependency 'shoulda'
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

task :default => :spec
