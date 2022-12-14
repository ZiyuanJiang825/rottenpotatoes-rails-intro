class MoviesController < ApplicationController


  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings


    if params[:ratings].nil?
      @ratings_to_show = session[:ratings_to_show].nil? ? @all_ratings : session[:ratings_to_show]
    else
      @ratings_to_show = params[:ratings].keys
    end
    @sort = params[:sort].nil? ? session[:sort] : params[:sort]
    case @sort
    when 'title'
     @title_header = 'hilite bg-warning'
    when 'release_date'
     @release_date_header = 'hilite bg-warning'
    end

    if @sort
      @movies = Movie.with_ratings(@ratings_to_show).order(@sort)
    else
      @movies = Movie.with_ratings(@ratings_to_show)
    end
    session[:ratings_to_show] = @ratings_to_show
    session[:sort] = @sort
    if !(params[:sort].present? || params[:ratings_to_show].present?)
      redirect_to movies_path(sort: session[:sort], ratings_to_show: session[:ratings_to_show])
      return
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
