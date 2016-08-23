class YaleBulldogs::Scraper

  attr_accessor :gender, :year

  def initialize(gender, year)
    @gender = gender
    @year = year
    @url = "http://yalebulldogs.com/sports/#{gender}-swim/#{get_year_range(year)}/schedule"
  end

  def get_year_range(year)
    year.to_s + '-' + (year.to_i + 1).to_s[2..4]
  end

  def request_data(gender, year)
    begin 
      @doc = Nokogiri::HTML(open(url))
      return doc
    rescue 
      return nil
    end
  end

  def scrape_season
    season = Season.new
    season.title = @doc.css("#mainbody h1")
    
    meet_data = doc.css(".schedule-home, .schedule-away")
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
end