# frozen_string_literal: true

module Utils
  def random_user_agent
    user_agents = []
    File.readlines('user-agents.txt').each do |line|
      user_agents.push(line)
    end
    user_agents.sample
  end

  def self.parse_proxies(proxy_file_path)
    proxies = []
    File.readlines(proxy_file_path).each do |line|
      proxy_splitted = line.split(':')
      proxies.push("http://#{proxy_splitted[0]}:#{proxy_splitted[1]}@#{proxy_splitted[2]}:#{proxy_splitted[3]}".strip)
    end
    proxies
  end
end
