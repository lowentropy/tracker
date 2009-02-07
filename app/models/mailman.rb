class Mailman < ActionMailer::Base
  
	def receive(email)
		email = Email.create(
			:subject => email.subject,
			:from => email.from.first,
			:to => email.to.first,
			:body => email.body)
		email.activate
	end

end
