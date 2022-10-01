class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    @ratings_list = params[:ratings] || session[:ratings]
    if @ratings_list.nil?
      @ratings_list = {}
    end
    @ratings_to_show = @ratings_list
    @movies = Movie.with_ratings(@ratings_list)

    @sort = params[:sort] || session[:sort]
    case @sort
    when 'title'
     @title_header = 'hilite bg-warning'
    when 'release_date'
     @release_date_header = 'hilite bg-warning'
    end

    if @sort
      @movies = Movie.with_ratings(@ratings_list).order(@sort)
    else
      @movies = Movie.with_ratings(@ratings_list)
    end

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

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
