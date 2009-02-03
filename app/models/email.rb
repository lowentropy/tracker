class Email < ActiveRecord::Base

	def activate
		number = from[0,from.index('@')]
		person = Person.find_by_phone_number number
		if person
			begin
				person.quick body
				update_attributes :stats => 'success'
			rescue
				update_attributes(
					:status => 'error',
					:errors => $!.message)
			end
		else
			update_attributes(
				:status => 'error',
				:errors => "no phone number: #{number}")
		end
	end

end
