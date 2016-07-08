class MoviesController < ApplicationController

	before_action :find_movie, only: [:show, :edit, :update, :destroy]

	def index
		if params[:category]
			@category_id = Category.find_by(name: params[:category]).id
			@movies = Movie.where(category_id: @category_id).order('created_at DESC')
		else
			@movies = Movie.all.order('created_at DESC')
		end
	end

	def new
		@movie = current_user.movies.build
		@categories = Category.all.map {|cat| [cat.name, cat.id]}
	end

	def create
		@movie = current_user.movies.build(movie_params)
		@movie.category_id = params[:category_id]

		if @movie.save
			redirect_to root_path
		else
			render 'new'
		end
	end

	def show
		
	end

	def edit
		@categories = Category.all.map {|cat| [cat.name, cat.id]}
	end


	def update
		@movie.category_id = params[:category_id]
		if @movie.update(movie_params)
			redirect_to movie_path(@movie)
		else
			render 'edit'
		end
	end

	def destroy
		@movie.destroy
		redirect_to root_path
	end

	private

	def movie_params
		params.require(:movie).permit(:title, :description, :author)
	end

	def find_movie
		@movie = Movie.find(params[:id])
	end


end
