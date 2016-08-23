class YaleBulldogs::Season

	attr_accessor :title, :meets

	# def self.check_availability(gender, year)
	# 	url = "http://yalebulldogs.com/sports/#{gender}-swim/#{self.get_year_range(year)}/schedule"
	# 	begin 
	# 		doc = Nokogiri::HTML(open(url))
	# 	end
	# 	rescue 

	# end

	def initialize
		@meets = []
	end

	# def self.scrape_season(doc)
	# 	season_title = doc.css("#mainbody h1")
		
	# 	meets = []
	# 	meet_data = doc.css(".schedule-home, .schedule-away")
	# 	meet_data.each do |row|
	# 		cell_data = row.css('td')
	# 		date = cell_data[0].text.gsub(/\s+/, ' ')
	# 		if date != ""
	# 			opponent = cell_data[1].text.strip.gsub(/\s+/, ' ')
	# 			time = cell_data[2].text.strip.gsub(/\s+/, ' ')
	# 			result = cell_data[3].text.strip.gsub(/\s+/, ' ')
	# 			if time != ''
	# 				meet = YaleBulldogs::Meet.new(date, opponent, time, result)
	# 				meets << meet
	# 			end
	# 		end
	# 	end
	# 	[season_title, meets]
	# end

	def display_meets
		# results = self.scrape_season(doc)
		puts self.title
		self.meets.each_with_index do |meet, index|
			puts (index + 1).to_s + ". : " + meet.opponent
		end
		results[1]
	end

	def self.meet_information(doc)
		meets = self.display_meets(doc)
		input = nil
		while input != 'exit'
			puts "Which meet are you interested in? (enter meet number):"
			input = gets.to_i
			if input > 0
				meet = meets[input - 1]
				puts "Opponent: " + meet.opponent
				puts "Date: " + meet.date
				puts "Time: " + meet.time
				puts "Result: " + meet.result
			else
				puts "Number invalid. Please try again:"
				self.meet_information(doc)
			end	
		end
	end
end