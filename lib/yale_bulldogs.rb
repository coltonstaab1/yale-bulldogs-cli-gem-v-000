=begin
require 'bundler/setup'
require 'yale_bulldogs'
=end

require_relative "./yale_bulldogs/version"
require_relative './yale_bulldogs/cli.rb'
require_relative "./yale_bulldogs/season.rb"
require_relative "./yale_bulldogs/meet.rb"

require 'irb'
require 'nokogiri'
require 'open-uri'

IRB.start