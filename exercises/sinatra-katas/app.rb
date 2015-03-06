require 'sinatra'
require 'data_mapper'

DataMapper.setup(:default, "sqlite:tweets.db")

class Tweet
  include DataMapper::Resource
  property :id, Serial
  property :status, String
  property :user, String
end

DataMapper.finalize
DataMapper.auto_upgrade!

# http://rubydoc.info/gems/sinatra#Routes


# CRUD Verb | HTTP Method
# ----------+------------
# Create    | POST
# Read      | GET
# Update    | PUT
# Destroy   | DELETE

#CREATE

# This will render an empty form so the user can enter
# the information to create a new tweet
get("/tweets/new") do
  @tweet = Tweet.new # build a 'shell' Tweet object that can be sent to the browser
  erb :new # render the :new template
end

# CRUD Verb: Create
# HTTP Method: POST

# This is the endpoint our "create form" submits to using
# the HTTP POST method.
post("/tweets") do
  @tweet = Tweet.create(params[:tweet]) # create a new tweet object and populate it with data from params hash
  if @tweet.saved? # redirect the user to "/" or render :new if the record didn't save
    redirect "/"
  else
    erb :new
  end
end

# READ

get("/") do
  @tweets = Tweet.all # query the db for all tweets
  erb :index # render the index template
end

get("/tweets/:id") do
  @tweet = Tweet.get(params[:id]) # query the db for the id of the requested tweet
  erb :show # render the relevant template
end

# UPDATE

# This renders the form used to edit a specific tweet
get("/tweets/edit/:id") do
  @tweet = Tweet.get(params[:id]) # query the db for the requested tweet
  erb :edit # render the edit template
end

# This is the endpoint our "edit form" submits to using
# the HTTP PUT method.
put("/tweets/:id") do
  @tweet = Tweet.get(params[:id]) # query the db for the requested tweet
  @tweet.update(params[:tweet]) # update the tweet's attributes in the db
  if @tweet.saved?
    redirect "/"
    else
      erb :edit
    end # redirect the user to "/" or render edit if the record didn't save
end

# DESTROY

delete("/tweets/:id") do
  @tweet = Tweet.get(params[:id]) # query the db for the rquested tweet
  @tweet.destroy # destroy the tweet
  redirect "/" # redirect the user back to the root, "/"
end
