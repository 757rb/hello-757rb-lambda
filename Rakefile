require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.libs = %w[app test]
  t.test_files = FileList['test/**/*_test.rb']
  t.warning = ENV['DEBUG']
end

task default: ['test']
