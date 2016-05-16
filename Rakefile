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


  task :bootstrap_answers, [:answer_file] do |t, args| 
    require "./server"
    require 'open-uri'
    data  = open(args[:answer_file]) {|f| f.read }
    
    answers = []
    CSV.new(data, { :col_sep => "\t" }).to_a.each { |row| answers << row[-1] }
    Answer.delete_all
    answers.each { |a| Answer.create(answer: a.to_s) }
  end

end
