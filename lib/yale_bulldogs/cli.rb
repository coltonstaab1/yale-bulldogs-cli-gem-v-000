class YaleBulldogs::CLI

	def call
		puts "Welcome to the Yale Swimming and Diving CLI app"
		puts "Please enter 'exit' at any time to quit the app"
		meet_information
		goodbye
	end

	def request_gender
		gender_input = nil
		while gender_input != 'exit'
			puts "Are you looking for information on the men's team or women's team?:"
			gender_input = gets.strip.downcase
			if gender_input == 'm' || gender_input =='men' || gender_input == 'mens' || gender_input == "men's" 
				gender = 'm'
			elsif gender_input == 'w' || gender_input == 'women' || gender_input == 'womens' || gender_input == "women's" 
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

	def get_year_range(year)
		year.to_s + '-' + (year.to_i + 1).to_s[2..4]
	end

	def request_data
		gender = request_gender
		year = request_year
		url = "http://yalebulldogs.com/sports/#{gender}-swim/#{self.get_year_range(year)}/schedule"
		begin 
			doc = Nokogiri::HTML(open(url))
			return doc
		rescue 
			puts "Data not available for that season. Please try again."
			request_data
		end
	end

	def display_meets
		doc = request_data
		results = YaleBulldogs::Season.scrape_season(doc)
		puts results[0].text
		results[1].each_with_index do |meet, index|
			puts (index + 1).to_s + ". : " + meet.opponent
		end
		results[1]
	end

	def meet_information
		meets = display_meets
		input = nil
		while input != 'exit' && input != 'back'
			puts "Which meet are you interested in? (enter meet number):"
			input = gets.strip
			if input.to_i > 0 && input.to_i <= meets.length
				meet = meets[input.to_i - 1]
				puts "Opponent: " + meet.opponent
				puts "Date: " + meet.date
				puts "Time: " + meet.time
				puts "Result: " + meet.result
			elsif input == 'back'
				call
			elsif input == 'exit'
				break
			else
				puts "Number invalid. Please try again:"
			end
		end
	end


	def goodbye
		puts "Bulldogs, bulldogs, bow bow bow, Eli Yale!"
	end
end