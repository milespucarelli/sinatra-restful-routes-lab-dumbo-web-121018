class Wizard < ActiveRecord::Base
  has_many :wizard_spells
  has_many :spells, through: :wizard_spells

  def self.level_to_health
    level_to_health_hash = {}
    health_points = 50
    (1..32).each do |rank|
      level_to_health_hash[rank] = health_points
      health_points += 10
    end
    level_to_health_hash
  end

  def self.standard_start
    level_to_health_hash = Wizard.level_to_health
    Wizard.all.each do |character|
      character.obscured = false
      character.protected = 0
      character.bound = 0
      character.stunned = false
      character.level = rand(1..32)
      character.health = level_to_health_hash[character.level]
      spells = Spell.all.select { |spell| spell.level <= character.level }
      spells.each do |spell|
        WizardSpell.create_and_associate(character, spell)
      end
      character.save
    end
  end

  def self.create_from_potter_api(response)
    raw_characters = JSON.parse(response).map do |character_hash|
      character_hash.except(
        '_id', 'role', 'school', '__v', 'bloodStatus', 'species', 'boggart', 'alias', 'animagus', 'wand', 'patronus'
      )
    end

    characters = raw_characters.select do |character_hash|
      character_hash.values.any? { |value| value == true }
    end

    characters.each { |character_hash| Wizard.create(character_hash) }
    Wizard.standard_start
  end

  def to_string
    str_arr_out = ['_________________________________________________']
    wizard_house = house
    wizard_house = 'Not a student' if house.nil?
    organizations = []
    organizations << 'Death Eater' if deathEater
    organizations << 'Order Of The Phoenix' if orderOfThePhoenix
    organizations << "Dumbledore's Army" if dumbledoresArmy
    organizations << 'Ministry Of Magic' if ministryOfMagic
    str_organizations = ""
    index = 0
    while index < organizations.length - 1
      str_organizations << "#{organizations[index]}, "
      index += 1
    end
    str_organizations << "#{organizations.last}"
    str_organizations = 'None' if organizations == []
    raw_str_arr = [
      "|House: #{wizard_house}",
      "|Organizations: #{str_organizations}",
      "|Level: #{level}",
      "|Health: #{health}"
    ]
    raw_str_arr.map! do |str|
      str << ' ' while str.length < str_arr_out[0].length - 1
      str << '|'
    end
    raw_str_arr << '_________________________________________________'
    str_arr_out += raw_str_arr
    index = 0
    str_out = ""
    while index < str_arr_out.length - 1
      str_out << str_arr_out[index] << "\n"
      index += 1
    end
    str_out << str_arr_out.last
    str_out
  end
end
