#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def init_db
	@db = SQLite3::Database.new "blog.db"
	@db.results_as_hash = true
end

# call everytime when any page was refreshed
before do
	# db initialize
	init_db
end
# call everytime - configuration app (code change or page refresh)
configure do
	# db initialize
	init_db
	# create table if table is not exist
	@db.execute 'CREATE TABLE IF NOT EXISTS Posts
		(
			id INTEGER PRIMARY KEY AUTOINCREMENT,
			created_date DATE,
			content TEXT
		)'
end

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/new' do
	erb :new
end

post '/new' do
	# get var from POST-request
  content = params[:content]

  erb "You typed #{content}"
end
