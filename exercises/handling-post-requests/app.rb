require 'sinatra'
require_relative 'db'

get '/' do
  @recipes = Recipe.all
  erb :recipes
end

post '/recipes/:recipe_id' do
  recipe = Recipe.get(params[:recipe_id])

  recipe.update(:created_by => params[:created_by],
                :title => params[:title],
                :description => params[:description],
                :instructions => params[:instructions],
                :created_at => Time.now)
  if recipe.saved?
    redirect '/'
  else
    return "ERROR RECIPE NOT SAVED"
  end
end

post '/recipes' do
  new_recipe = Recipe.create(:created_by => params[:created_by],
                             :title => params[:title],
                             :description => params[:description],
                             :instructions => params[:instructions],
                             :created_at => Time.now)
  if new_recipe.saved?
    redirect '/'
  else
    return "ERROR RECIPE NOT SAVED"
  end
end

get '/recipes/:recipe_id' do
  if @recipe = Recipe.get(params[:recipe_id])
    erb :show_recipe
  else
    404
  end
end

get '/recipes/:recipe_id/edit' do
  if @recipe = Recipe.get(params[:recipe_id])
    erb :edit_recipe
  else
    404
  end
end