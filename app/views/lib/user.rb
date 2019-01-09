class User < ActiveRecord::Base
  has_many :learned_spells
  has_many :spells, through: :learned_spells

  def self.create_new_from_login(username, name, house)
    user = User.create(
      username: username,
      name: name,
      house: house,
      level: 1,
      health: 50,
      obscured: false,
      protected: 0,
      bound: 0,
      stunned: false
    )
    spells = Spell.all.select { |spell| spell.level <= user.level }
    spells.each do |spell|
      LearnedSpell.create_and_associate(user, spell)
    end
    user.save
    user
  end

  def self.create_dummy(username, name, house)
    user = User.create(
      username: username,
      name: name,
      house: house,
      level: 32,
      health: 360,
      obscured: false,
      protected: 0,
      bound: 0,
      stunned: false
    )
    spells = Spell.all.select { |spell| spell.level <= user.level }
    spells.each do |spell|
      LearnedSpell.create_and_associate(user, spell)
    end
    user.save
    user
  end

  def print_spells
    spells.each { |spell| puts spell.to_string }
  end
end
