require 'open-uri'
require 'json'

class LongestWord < ApplicationController
  def self.generate_grid(grid_size)
  # TODO: generate random grid of letters
    (0...grid_size).map { (65 + rand(26)).chr }
  end

  def self.translation(attempt)
    api_url = "http://api.wordreference.com/0.8/80143/json/enfr/#{attempt}"
    open(api_url) do |stream|
      quote = JSON.parse(stream.read)
      if quote['term0']
        quote['term0']['PrincipalTranslations']['0']['FirstTranslation']['term']
      end
    end
  end

  def self.process_translation(attempt, time)
    if translation(attempt)
      translation = translation(attempt)
      @score = attempt.length + 1 / time
      return { time: time, translation: translation, score: @score, message: "well done" }
    else
      return { time: 0, translation: nil, score: 0, message: "not an english word" }
    end
  end

  def run_game(attempt, grid, start_time, end_time)
    # TODO: runs the game and return detailed hash of result
    user_input = attempt.upcase.split("")
    if (grid - user_input).size <= grid.size - user_input.size # word in the grid
      time = end_time - start_time
      process_translation(attempt.downcase, time)
    else
      return { time: 0, translation: "", score: 0, message: "not in the grid" }
    end
  end
end
