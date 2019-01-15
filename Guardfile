clearing :on

guard :minitest do
  watch(%r{^test/unit/(.*)_test\.rb$})
  watch(%r{^app/src/(.*)\.rb$})          { |m| "test/unit/#{m[1]}_test.rb" }
  watch(%r{^test/test_helper\.rb$})      { 'test' }
end
