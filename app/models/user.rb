class User < ApplicationRecord
	before_save :salted

	def salted
		if self.id.blank? #bug: update causes problem
			self.password = "aaaaa" + self.password
		end
	end
end
