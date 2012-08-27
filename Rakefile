#!/usr/bin/env rake

# omitting, we won't release this gem to public
# require "bundler/gem_tasks"

task :default => :test

desc "Run tests by default"
task :test => 'test:all'

require 'rake/testtask'
include Rake::DSL

namespace :test do
  Rake::TestTask.new(:unit) do |test|
    test.libs << %w{ lib test }
    test.pattern = 'test/*_test.rb'
    test.verbose = true
  end

  Rake::TestTask.new(:unit_api) do |test|
    test.libs << %w{ lib test }
    test.pattern = 'test/api/*_test.rb'
    test.verbose = true
  end
  
  desc "Run all tests, including integration tests"
  task :all => [ :unit, :unit_api ]
end
