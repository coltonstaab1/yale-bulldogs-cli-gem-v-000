class YaleBulldogs::Meet
	attr_accessor :date, :opponent, :time, :result

		def initialize(date=nil, opponent=nil, time=nil, result=nil)
			@date = date
			@opponent = opponent
			@time = time
			@result = result
		end

end