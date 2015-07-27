require 'jumpstart_auth'
require 'klout'

class MicroBlogger
	attr_reader :client

	def initialize
		puts "initz microblogger"
		@client = JumpstartAuth.twitter
		Klout.api_key = 'xu9ztgnacmjx3bu82warbr3h'
	end

	def tweet(message)
		if (message.length <= 140)
		@client.update(message)
		else
			puts "Message to long!"
		end
	end

	def run
		puts "Welcome to my Twitter client!"
		command = ""
		while command != "q"
			printf "enter command: "
			input = gets.chomp
			parts = input.split(" ")
			command = parts[0]
			case command
				when 'q' then puts "Goodbye!"
				when 't' then tweet(parts[1..-1].join(" "))
				when 'dm' then dm(parts[1], parts[2..-1].join(" "))
				else
				 puts "sorry i dont know that command!"
			end
		end
	end

	def dm(target, message)
		puts "Trying to sent #{target} this direct message"
		puts message
		message = "d @#{target} #{message}"
		tweet(message)
	end

	def klout_score
		
		friends = @client.friends.collect{|f| @client.user(f).screen_name}
		friends.each do |friend|
			print "#{friend} "
			identity = Klout::Identity.find_by_screen_name(friend)
			user = Klout::User.new(identity.id)
			print user.score.score
			puts "" 
		end
	end
end

micro = MicroBlogger.new
micro.klout_score
micro.run
