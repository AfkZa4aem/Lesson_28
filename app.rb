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
	@db.execute 'CREATE TABLE IF NOT EXISTS Comments
		(
			id INTEGER PRIMARY KEY AUTOINCREMENT,
			created_date DATE,
			content TEXT,
			post_id INTEGER
		)'
end

get '/' do
	# get posts from db
	@results = @db.execute 'select * from Posts order by id desc'
	erb :index			
end

get '/new' do
	erb :new
end

post '/new' do
	# get var from POST-request
  content = params[:content]

  if content.length <= 0
  	@error = "Type post text"
  	return erb :new
  end

  @db.execute 'insert into Posts (content, created_date) values (?, datetime())', [content]

  redirect to('/')
  # erb "You typed #{content}"
end

# output post info
get '/details/:post_id' do
	# get var from url
	post_id = params[:post_id]

	# get posts list (only one btw xD)
	results = @db.execute 'select * from Posts where id = ?', [post_id]
	# get this one post to @row
	@row = results[0]

	@comments = @db.execute 'select * from Comments where post_id = ? order by id', [post_id]

	# get details erb
	erb :details
end

post '/details/:post_id' do
	post_id = params[:post_id]
	content = params[:content]

	@db.execute 'insert into Comments (content, created_date, post_id) values (?, datetime(), ?)', [content, post_id]

	redirect to('/details/' + post_id)
end
