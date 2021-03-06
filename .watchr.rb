if File.exists?(".rspec")
  @spec = 'rspec'
else
  @spec = 'spec'
end

def all_specs
  "spec/models/ spec/lib/ spec/integration/"
end

trap 'INT' do
  start_fresh "Done running tests."
  exit! 0
end

def run_db_test_prepare
  start_fresh "Running db:test:prepare..."
  system("rake db:test:prepare")
  puts "Done!"
end

def run_spec(file)
  return unless file.include?(" ") || File.exist?(file)
  start_fresh "Running specs..."
  system("time #{@spec} -f nested -c #{file}")
end

def run_test(type, file)
  return unless file.include?(" ") || File.exist?(file)
  start_fresh "Running tests..."
  system("time rake test#{':' + type if type} TEST=#{file}")
end

def run_feature(file)
  return unless file.include?(" ") || File.exist?(file)
  start_fresh "Running feature..."
  system("time cucumber -f pretty #{file}")
end

def start_fresh(text=nil)
  print `clear`
  puts text if text
end

watch('^lib/(.*)\.rb') {|md| run_spec("spec/lib/#{md[1]}_spec.rb") }
watch('^db/schema.rb') {|md| run_db_test_prepare }
watch('^app/models/(.*)\.rb') {|md| run_spec("spec/models/#{md[1]}_spec.rb") }
watch('^app/mailers/(.*)\.rb') {|md| run_spec("spec/mailers/#{md[1]}_spec.rb") }
watch('^app/controllers/(.*)\.rb') {|md| run_spec("spec/controllers/#{md[1]}_spec.rb") }
watch('^app/helpers/(.*)\.rb') {|md| run_spec("spec/helpers/#{md[1]}_spec.rb") }
watch('^app/views/(.*)\.[erb|haml]') {|md| run_spec("spec/integration/**/*_spec.rb") }
watch('^config/initializers/(.*)\.rb') {|md| run_spec("spec/initializers/#{md[1]}_spec.rb") }

watch('^spec/.*_spec\.rb')  {|md| run_spec(md[0]) }

watch('^test/test\_.*\.rb')  {|md| run_test(nil, md[0]) }
watch('^test/unit/.*\_test.rb')  {|md| run_test('units', md[0]) }
watch('^test/functional/.*\_test.rb')  {|md| run_test('functionals', md[0]) }
watch('^test/integration/.*\_test.rb')  {|md| run_test('integration', md[0]) }

watch("^features/.*\.feature") {|md| run_feature(md[0]) }
