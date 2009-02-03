class Mailman < ActionMailer::Base
  
	def receive(email)
		email = Email.create(
			:subject => email.subject,
			:from => email.from.first,
			:to => email.to.first,
			:body => email.body,
			:errors => "")
		email.activate
	end

end
