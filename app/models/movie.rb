class Movie < ActiveRecord::Base
    def self.get_ratings #part 2
        Movie.select(:rating).uniq.map { |movie| movie.rating }.sort #part 2
    end
end