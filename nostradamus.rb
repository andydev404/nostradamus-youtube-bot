# frozen_string_literal: true

require 'tty-prompt'
require 'tty-font'
require 'pastel'
require 'thwait'
require './core/browser'
require './utils'

module Nostradamus
  BOT_TYPE = {
    video_views: 'Video Views'
  }.freeze

  class CLI
    def initialize
      @prompt = TTY::Prompt.new
      @font = TTY::Font.new(:doom)
      @pastel = Pastel.new
    end

    def init
      puts "\n\n"
      puts @pastel.cyan.bold(@font.write('BOT'))
      puts @pastel.red.bold(@font.write('Nostradamus'.upcase))
      puts @pastel.red.bold('=' * 78)
      puts "\n"
    end

    def choose_bot_type
      choices = {}
      BOT_TYPE.each_with_index do |(key, value), index|
        choices["(#{index + 1}) #{value}"] = key
      end
      @prompt.select('Select a Bot:', choices)
    end

    def video_url
      @prompt.ask('Insert the URL of the video:', required: true)
    end

    def video_views
      @prompt.ask('Quantity of views:', required: true, default: 10, convert: :int)
    end
  end

  class Youtube
    def video_views(url)
      threads = []
      proxies = Utils.parse_proxies('proxies.txt')
      proxies.each do |proxy|
        threads << Thread.new do
          reproduce_video(url, proxy)
        end
      end
      ThreadsWait.all_waits(*threads)
      puts "#{proxies.length} views added"
    end

    private

    def reproduce_video(url, proxy)
      browser, proxy_server = Browser.new(proxy).instance
      browser.goto url
      sleep 120 # 120 seconds = 2 minutes
      proxy_server.stop
      browser.close
    end
  end
end

CLI = Nostradamus::CLI.new
CLI.init

case CLI.choose_bot_type
when :video_views
  Nostradamus::Youtube.new.video_views(CLI.video_url)
else
  puts 'Error: Try again'
end
