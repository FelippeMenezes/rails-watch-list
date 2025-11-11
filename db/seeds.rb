require 'net/http'
require 'json'
require 'uri'

puts "Cleaning database..."
Bookmark.destroy_all
List.destroy_all
Movie.destroy_all
puts "Database cleaned."

puts "Fetching top rated movies from TMDB..."

url = URI("https://tmdb.lewagon.com/movie/top_rated")

response_string = Net::HTTP.get(url)
response_hash = JSON.parse(response_string)

movies = response_hash['results']

puts "Creating 10 movies from API..."

movies.first(10).each do |movie|
  Movie.create!(
    title: movie['title'],
    overview: movie['overview'],
    poster_url: "https://image.tmdb.org/t/p/w500#{movie['poster_path']}",
    rating: movie['vote_average']
  )
  puts "Created #{movie['title']}"
end

puts "Finished! Created #{Movie.count} movies."

puts "Creating lists..."
list_names = ["Drama", "Comedy", "Classic", "To rewatch"]
list_names.each do |name|
  List.create!(name: name)
  puts "Created list: #{name}"
end


