module ApplicationHelper

	def mb_time(time)
		return nil if time.blank?
		time.strftime("%m-%d %H:%M:%S") 
	end
end
