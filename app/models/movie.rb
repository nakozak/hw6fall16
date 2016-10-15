class Movie < ActiveRecord::Base
  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end
  
class Movie::InvalidKeyError < StandardError ; end
  Tmdb::Api.key("f4702b08c0ac6ea5b51425788bb26562")
  def self.find_in_tmdb(string)
    begin
      movies = []
      #Add movies to array
      Tmdb::Movie.find(string).each do |movie|
      movies << {:tmdb_id => movie.id, :title => movie.title, :rating => self.get_rating(movie.id), :release_date => movie.release_date}
      end
      return movies
    rescue Tmdb::InvalidApiKeyError
        raise Movie::InvalidKeyError, 'Invalid API key'
    end
  end
  #Create Movie found in TMDb
  def self.create_from_tmdb(tmdb_id)
    detail = Tmdb::Movie.detail(tmdb_id)
    Movie.create(title: detail["original_title"], rating: self.get_rating(tmdb_id), release_date: detail["release_date"])
  end
  #Get the ratings from TMDb 
  def self.get_rating(tmdb_id)
    tmdb_rating = ""
    Tmdb::Movie.releases(tmdb_id)["countries"].each do |rating|
      if rating["iso_3166_1"] == "US"
        tmdb_rating = rating["certification"]
        break
      end
    end
    return tmdb_rating
  end
end
