require_relative '../lib/improve_your_code/rake/task'

ImproveYourCode::Rake::Task.new do |t|
  t.fail_on_error = true
  t.verbose = false
end
