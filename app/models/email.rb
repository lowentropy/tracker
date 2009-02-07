class Email < ActiveRecord::Base

	def activate
		number = from[0,from.index('@')]
		person = Person.find_by_phone_number number
		if person
			begin
				person.quick body
				update_attributes :status => 'success'
			rescue
				update_attributes(
					:status => 'error',
					:error => $!.message)
			end
		else
			update_attributes(
				:status => 'error',
				:error => "no phone number: #{number}")
		end
	end

end
