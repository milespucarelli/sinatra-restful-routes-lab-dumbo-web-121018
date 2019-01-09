class LearnedSpell < ActiveRecord::Base
  belongs_to :user
  belongs_to :spell

  def self.create_and_associate(user, spell)
    ls = LearnedSpell.create
    user.learned_spells << ls
    spell.learned_spells << ls
  end
end
