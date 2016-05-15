require "sinatra/activerecord/rake"
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/*.rb']
  t.verbose = true
end

namespace :db do
  task :load_config do
    require "./server"
  end


  task :bootstrap_answers do 
    require "./server"
    
    # The test set file is assumed to have a header row (which we remove)
    # and we assume the last column in the file is the target atttribute (answer)
    answers = []
    CSV.foreach(ENV["TESTSET_FILE"]) do |row|
      answers << row[-1]
    end
    answers.shift 

    Answer.delete_all
    answers.each do |a|
      Answer.create(answer: a.to_s)
    end
  end

end
