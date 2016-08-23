class YaleBulldogs::Scraper

  attr_accessor :gender, :year, :url, :data

  def initialize(gender, year)
    self.gender = gender
    self.year = year
    self.url = "http://yalebulldogs.com/sports/#{gender}-swim/#{get_year_range(year)}/schedule"
    self.data = request_data(self.url)
  end

  # this function scrapes the data at yalebulldogs.com and returns a meet object
  # if the date and time associated with the entry in the schedule table isn't blank
  def scrape_season
    season = YaleBulldogs::Season.new
    season.title = self.data.css("#mainbody h1").text
    
    meet_data = self.data.css(".schedule-home, .schedule-away")
    meet_data.each do |row|
      cell_data = row.css('td')
      date = cell_data[0].text.gsub(/\s+/, ' ')
      if date != ""
        opponent = cell_data[1].text.strip.gsub(/\s+/, ' ')
        time = cell_data[2].text.strip.gsub(/\s+/, ' ')
        result = cell_data[3].text.strip.gsub(/\s+/, ' ')
        if time != ''
          meet = YaleBulldogs::Meet.new(date, opponent, time, result)
          season.meets << meet
        end
      end
    end
    season
  end

  private
    # this function gives us the year range associated with a particular season
    # e.g. the season that started in 2008 went from October 2008-March 2009
    def get_year_range(year)
      year.to_s + '-' + (year.to_i + 1).to_s[2..4]
    end

    def request_data(url)
      begin 
        doc = Nokogiri::HTML(open(url))
        return doc
      rescue 
        return nil
      end
    end

end