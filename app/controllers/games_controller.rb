require "open-uri"

class GamesController < ApplicationController
  def new
    alphabet = ("a".."z").to_a
    grid_array = []
    (0...9).to_a.each { |i| grid_array << alphabet.sample }
    @letters = grid_array
  end

  def score
    @word = params[:word]
    @letters = params[:letters]

    def calculate(attempt, grid)
      # TODO: runs the game and return detailed hash of result
      @result = Hash.new(0)

      if in_grid?(attempt, grid) == false
        return @result = {
          score: 0,
          message: "That letter is not in the grid, or does not appear the number of times you have attempted to use it."
        }
      elsif english_word?(attempt) == false
        return @result = {
          score: 0,
          message: "Not an English word"
        }
      else
        return @result = {
          score: (attempt.length ** 2),
          message: "Well Done!"
        }
      end
    end

    def in_grid?(attempt, grid)
      attempt_hash = Hash.new(0)
      grid_hash = Hash.new(0)
      # Be careful of case (downcase to be safe)
      attempt.downcase.split("").each { |letter| attempt_hash[letter.downcase.to_sym] += 1 }
      grid.split(" ").each { |letter| grid_hash[letter.downcase.to_sym] += 1 }

      x = true

      attempt_hash.each_key do |key|
        if attempt_hash[key] > grid_hash[key] #NOT >=
          x = false
        end
      end
      return x
    end

    def english_word?(attempt)
      url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
      word_serialized = open(url).read
      word = JSON.parse(word_serialized)
      word['found'] == true ? true : false
    end

    calculate(@word, @letters)
  end

end

