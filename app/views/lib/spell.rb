class Spell < ActiveRecord::Base
  has_many :learned_spells
  has_many :wizard_spells
  has_many :users, through: :learned_spells
  has_many :wizards, through: :wizard_spells

  def self.create_from_hash_array(hash_array)
    hash_array.each { |hash| Spell.create(hash) }
  end

  def to_string
    str_arr_out = ['_________________________________________________']
    raw_str_arr = [
      "|Spell: #{incantation}",
      "|Magic Type: #{magic_type}",
      "|Effect: #{effect}",
      "|Damage: #{damage}",
      "|Recovery: #{recovery}"
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

# {
#   incantation: 'Protego Maxima',
#   magic_type: 'Defensive',
#   effect: 'creates strong protective barrier',
#   damage: nil,
#   recovery: 0,
#   stuns: false,
#   revives: false,
#   dark_magic: false
# },
# {
#   incantation: 'Ventus',
#   magic_type: 'Charm',
#   effect: 'Knocks back opponent with a gust of wind',
#   damage: nil,
#   recovery: 0,
#   stuns: true,
#   revives: false,
#   dark_magic: false
# }
# incantation: 'Locomotor Mortis', magic_type: 'Curse',
# damage: nil, dark_magic: nil>,
# {
#   incantation: 'Levicorpus',
#   magic_type: 'Jinx',
#   effect: '
#   damage: nil,
#   dark_magic: nil>,
# {
# Reparifors healing
# {
#   incantation: 'Relashio',
#   magic_type: 'Spell', damage: nil, dark_magic: nil>,
#   Transmogrifian Torture curse
