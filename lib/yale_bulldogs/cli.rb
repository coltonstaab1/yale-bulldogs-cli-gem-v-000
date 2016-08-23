class YaleBulldogs::CLI

	# this is the method first called when ruby/bin yalebulldogs.rb is run
	def call
		puts "Welcome to the Yale Swimming and Diving CLI app"
		puts "Please enter 'exit' at any time to quit the app"
		meet_information
		puts "Bulldogs, bulldogs, bow bow bow, Eli Yale!"
	end

	#this method requests the gender of the team for which you're looking for information
	def request_gender
		gender_input = nil
		while gender_input != 'exit'
			puts "Are you looking for information on the men's team or women's team?:"
			gender_input = gets.strip.downcase
			if ['m','men','mens',"men's"].include? gender_input
				gender = 'm'
			elsif ["w","women","womens","women's"].include? gender_input
				gender = 'w'
			elsif gender_input == 'exit'
				abort("Bulldogs, bulldogs, bow bow bow, Eli Yale!")
			else
				puts "Input invalid. Please try again."
				request_gender
			end
			return gender
		end
	end

	#this method requests the year of the season for which you're looking
	def request_year
		year = nil
		while year != 'exit'
			puts "What year are you interested in? (input must be in YYYY format):"
			year = gets.strip
			if year.to_s.length != 4
				puts "Input invalid. Please try again."
				request_year
			end	
			return year
		end
	end

	#this method displays the meets that happened within a particular season
	def display_meets(season)
		puts season.title
		season.meets.each_with_index do |meet, index|
			puts (index + 1).to_s + ". : " + meet.opponent
		end
	end

	#this method displays the data associated with a particular meet
	def display_meet(meet)
		puts "Opponent: " + meet.opponent
		puts "Date: " + meet.date
		puts "Time: " + meet.time
		puts "Result: " + meet.result
	end

	#this function calls the scraper class to get the data for a particular year and gender, shows
	#data about the meets that happened during that season, and displays data for particular meets
	def meet_information
		gender = request_gender
		year = request_year

		begin
			season = YaleBulldogs::Scraper.new(gender,year).scrape_season
		rescue
			puts "Data for that season couldn't be found. Please try again."
			meet_information
		end

		input = nil
		while input != 'exit' && input != 'back'
			display_meets(season)
			puts "Which meet are you interested in? (enter meet number):"
			input = gets.strip
			if input.to_i > 0 && input.to_i <= season.meets.length
				meet = season.meets[input.to_i - 1]
				display_meet(meet)
			elsif input == 'back'
				meet_information
			elsif input == 'exit'
				break
			else
				puts "Number invalid. Please try again:"
			end
		end
	end

end