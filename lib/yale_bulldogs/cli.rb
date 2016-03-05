class YaleBulldogs::CLI

	def call
		puts "Welcome to the Yale Swimming and Diving CLI app"
		puts "Please enter 'exit' at any time to quit the app"
		meet_information(doc)
		goodbye
	end

	def request_gender
		puts "Are you looking for information on the men's team or women's team?:"
		gender_input = gets.strip.downcase
		if gender_input == 'm' || gender_input =='men' || gender_input == 'mens' || gender_input == "men's" 
			gender = 'm'
		elsif gender_input == 'w' || gender_input == 'women' || gender_input == 'womens' || gender_input == "women's" 
			gender = 'w'
		else
			puts "Input invalid. Please try again."
			request_gender
		end
		gender
	end

	def request_year
		puts "What year are you interested in?:"
		year = gets.strip
		if year.to_s.length != 4
			puts "Input invalid. Please try again."
			request_year
		end	
		year
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

	def display_meets(doc)
		doc = request_data
		results = YaleBulldogs::Season.scrape_season(doc)
		puts results[0].text
		results[1].each_with_index do |meet, index|
			puts (index + 1).to_s + ". : " + meet.opponent
		end
		results[1]
	end

	def meet_information(doc)
		meets = display_meets(doc)
		input = nil
		while input != 'exit' && input != 'back'
			puts "Which meet are you interested in? (enter meet number):"
			begin
				input = gets.strip
				meet = meets[input.to_i - 1]
				puts "Opponent: " + meet.opponent
				puts "Date: " + meet.date
				puts "Time: " + meet.time
				puts "Result: " + meet.result
			rescue
				puts "Number invalid. Please try again:"
				meet_information(doc)
			end	
		end
		if input == 'back'
			call
		end
	end


	def goodbye
		puts "Bulldogs, bulldogs, bow bow bow, Eli Yale!"
	end
end