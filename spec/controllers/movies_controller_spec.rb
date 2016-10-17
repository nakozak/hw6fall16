require 'spec_helper'
require 'rails_helper'

describe MoviesController do
  describe 'searching TMDb' do
   it 'should call the model method that performs TMDb search' do
      fake_results = [double('movie1'), double('movie2')]
      expect(Movie).to receive(:find_in_tmdb).with('Ted').
        and_return(fake_results)
      post :search_tmdb, {:search_terms => 'Ted'}
    end
  end
    it 'should select the Search Results template for rendering' do
      allow(Movie).to receive(:find_in_tmdb){[double('movie1'), double('movie2')]}
      post :search_tmdb, {:search_terms => 'Ted'}
      expect(response).to render_template('search_tmdb')
    end  
    it 'should make the TMDb search results available to that template' do
      fake_results = [double('Movie'), double('Movie')]
      allow(Movie).to receive(:find_in_tmdb).and_return (fake_results)
      post :search_tmdb, {:search_terms => 'Ted'}
      expect(assigns(:movies)).to eq(fake_results)
    end 
    
    #if the search is blank
    describe 'invalid search' do
      it 'should return to the homepage and flash Invalid search. Please try again' do
      allow(Movie).to receive(:find_in_tmdb)
      post :search_tmdb, {:search_terms =>''}
      expect(response).to redirect_to(movies_path)
    end
  end
     #If the search was non-blank
    describe 'valid search' do
      it 'should select the Search Results template for rendering' do
        allow(Movie).to receive(:find_in_tmdb){[double('movie1'), double('movie2')]}
        post :search_tmdb, {:search_terms => 'Ted'}
        expect(response).to render_template('search_tmdb')
    end 
  end
  #add movies to database if the boxes are checked
  describe 'adding TMDb' do
    it 'should call Movie.create_from_tmdb if any checkbox is checked' do
      expect(Movie).to receive(:create_from_tmdb).with("941")
      post :add_tmdb, {:tmdb_movies => {"941": "1"}}
    end
    it 'should not call Movie.create_from_tmdb if no checkbox is checked' do
      expect(Movie).not_to receive(:create_from_tmdb)
      post :add_tmdb, {:tmdb_movies => nil}
    end
    
  end
  #show movies from tmdb
  describe 'showing a movie' do
    it 'should call Movie.find' do
      expect(Movie).to receive(:find).with("1")
      get :show, {:id => "1"}
    end
    it 'should select the show template for rendering' do
      allow(Movie).to receive(:find)
      get :show, {:id => "1"}
      expect(response).to render_template('show')
    end
  end
  #edit movie in rotten potatoes
  describe 'editing a movie' do
    it 'should call Movie.find' do
      expect(Movie).to receive(:find).with("1")
      get :edit, {:id => "1"}
    end
    it 'should select the show template for rendering' do
      allow(Movie).to receive(:find)
      get :edit, {:id => "1"}
      expect(response).to render_template('edit')
    end
  end
  #Create Fake movie for testing purposes
  movie_attr = {:title => "test", :rating => "test", :description => "test", :release_date => "1969-06-09"}
  #modify a movie
   describe "modifying a movie" do
    before(:each) do
      @movie = Movie.create! movie_attr
    end
    #update the movie in rotten potatoes
    describe "updating a movie" do
      update_param = {:title => "new title"}
      
      it "should update the chosen movie" do
        allow(Movie).to receive(:update_attributes!).with(update_param)
        put :update, :id => @movie.id, :movie => update_param
      end
      it "should redirect to homepage after successful updating" do
        allow(Movie).to receive(:update).with(update_param)
        put :update, :id => @movie.id, :movie => update_param
        expect(response).to redirect_to(movie_path(@movie))
      end
    end
    #delete movie from rotten potatoes database
    describe "deleting a movie" do
      it "should delete the chosen movie" do
        expect { delete :destroy, :id => @movie.id}.to change(Movie, :count).by(-1)
      end
      it "should redirect to the homepage after successful deleting" do
        delete :destroy, :id => @movie.id
        expect(response).to redirect_to(movies_path)
      end
    end
  end
end
