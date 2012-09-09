require 'rake'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = ["--format", "documentation", "--color"]
end

task :spec_libs_alexandria do
  system 'rake spec SPEC=lib/basic_domain_api/spec'
end

task :default => [:spec, :spec_libs_alexandria]