# frozen_string_literal: true

require 'watir'
require 'webdrivers'
require 'proxy_chain_rb'
require './utils'

class Browser
  include Utils
  attr_accessor :proxy

  def initialize(proxy)
    @proxy = proxy
  end

  def instance
    proxy_server      =   ProxyChainRb::Server.new
    generated_proxy   =   proxy_server.start(@proxy)
    browser_opts      =   {
      proxy: { http: generated_proxy, ssl: generated_proxy },
      page_load_timeout: 9999,
      args: arguments,
      extensions: extensions
    }
    browser = Watir::Browser.new :chrome, options: browser_opts, headless: false
    [browser, proxy_server]
  end

  private

  def extensions
    %w[
      ./extensions/active_window.crx
      ./extensions/fingerprint_defender.crx
      ./extensions/spoof_timezone.crx
      ./extensions/webrtc.crx
    ]
  end

  def arguments
    [
      "--user-agent=#{random_user_agent}",
      '--disable-translate',
      '--mute-audio',
      '--no-sandbox',
      '--ignore-certificate-errors',
      '--disable-popup-blocking'
    ]
  end
end
