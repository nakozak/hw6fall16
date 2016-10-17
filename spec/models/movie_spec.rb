require 'spec_helper'
require 'rails_helper'

describe Movie do
  describe 'searching Tmdb by keyword' do
    context 'with valid key' do
      it 'should call Tmdb with title keywords' do
        expect( Tmdb::Movie).to receive(:find).with('Inception')
        Movie.find_in_tmdb('Inception')
      end
  end
    context 'with invalid key' do
      it 'should raise InvalidKeyError if key is missing or invalid' do
        allow(Tmdb::Movie).to receive(:find).and_raise(Tmdb::InvalidApiKeyError)
        expect {Movie.find_in_tmdb('Inception') }.to raise_error(Movie::InvalidKeyError)
      end
    end
  end
    describe 'search for movies'do
    it 'should return all the movies whose titles include the search terms' do
        search_terms = "Lethal Weapon"
        Movie.find_in_tmdb(search_terms).each {|movie| expect(movie[:title]).to include(search_terms)}
      end
    end
    describe 'get all ratings' do
    it 'should return all rating options' do
      expect(Movie.all_ratings).to eq(["G", "PG", "PG-13", "NC-17", "R"])
    end
  end
end
