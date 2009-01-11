class User < ActiveRecord::Base

	has_many :logs, :dependent => :destroy
	has_many :people, :dependent => :destroy
	has_many :unit_prefs, :dependent => :destroy

	def pref(stat)
		UnitPref.find_by_user_id_and_stat_id self.id, stat.id
	end

end
