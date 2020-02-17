class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    session[:ratings] = params[:ratings] if params[:ratings].present? #part 3
    session[:sort_by] = params[:sort_by] if params[:sort_by].present? #part 3
    
    if params[:ratings] != session[:ratings] || params[:sort_by] != session[:sort_by] #part 3
      flash.keep #part 3
      redirect_to movies_path(ratings: session[:ratings], sort_by: session[:sort_by]) #redirecting to new URI containing appropriate parameters #part 3
    end #part 3
    
    @all_ratings = session[:ratings] ? session[:ratings].keys : Movie.get_ratings #part 2 & 3
    @movies = Movie.where(rating: @all_ratings).order(session[:sort_by]) #part 2 & 3
    @title_header = 'hilite' if session[:sort_by] == 'title' #part 1 & 3
    @release_date_header = 'hilite' if session[:sort_by] == 'release_date' #part 1 & 3
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
