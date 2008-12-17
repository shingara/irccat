class Send < Mongrel::HttpHandler

  def initialize(bot, config); @bot = bot; @config = config; end

  def process(request, response)
    response.start(200) do |head,out|
      head["Content-Type"] = "text/plain"
  
      # changed PATH_INFO to REQUEST_URI.
      # : PATH_INFO cuts off /;.*/, REQUEST_URI doesnt. the gsub is needed anyway.
      # if the /send path gets configurable, this needs to be fixed.
      message = CGI::unescape("#{request.params['REQUEST_URI'].gsub('/send/','')}")

      # quick hack:
      # /send/c;channel/message
      # /send/n;nick/message
      mo = message.match(/^(c|n);(.*)\/(.*)/)
      if (mo == nil)
	if (@config['irc']['channel'].is_a?(Array))
          @bot.say(@config['irc']['channel'][0],"#{message}")
	else
          @bot.say(@config['irc']['channel'],"#{message}")
	end
      elsif (mo[1] == "c")
        @bot.say("#" + mo[2], mo[3])
      elsif (mo[1] == "n")
        @bot.say(mo[2], mo[3])
      end
      # EoQh

    end
  end
end
