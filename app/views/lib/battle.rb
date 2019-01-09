def battle(user)
  prompt = TTY::Prompt.new
  opponent = Wizard.where('level = ?', user.level).sample
  puts "Your opponent for this battle will be #{opponent.name}"
  puts opponent.to_string
  puts ''
  puts ''
  players_turn = [true, false].sample
  while opponent.health > 0 && user.health > 0
    if players_turn
      puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
      puts "#{user.name}'s turn"
      puts ''
      choices = {}
      user.spells.each do |spell|
        choices[spell.to_string] = spell.incantation
      end
      user_selection = prompt.select("Select your spell\n", choices)
      spell = Spell.find_by(incantation: user_selection)
      puts "#{user.name} casts #{spell.incantation}"
      puts ''
      check_spell(user, opponent, spell)
      players_turn = false
    else
      puts '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
      puts "#{opponent.name}'s turn"
      puts ''
      wizard_selection = opponent.spells.sample
      puts "#{opponent.name} casts #{wizard_selection.incantation}"
      puts ''
      check_spell(opponent, user, wizard_selection)
      players_turn = true
    end
  end
end

def check_spell(player, opponent, spell)
  skill_map = {
    'Gryffindor' => 'Jinx',
    'Slytherin' => 'Curse',
    'Ravenclaw' => 'Charm',
    'Hufflepuff' => 'Defensive'
  }
  odds_bonus = 0.0
  odds_bonus = 0.05 if skill_map[player.house] == spell.magic_type
  stun_bonus = 0.0
  stun_bonus = 0.20 if opponent.stunned
  obscured_penalty = 0.0
  obscured_penalty = 0.20 if opponent.obscured
  rand_float = rand(0.0..1.0)
  odds = rand_float - odds_bonus - stun_bonus + obscured_penalty
  if odds <= spell.chance
    puts 'The spell was successful!'
    enact_spell(player, opponent, spell)
  else
    puts 'The spell failed!'
    puts '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
    puts ''
  end
end

def enact_spell(player, opponent, spell)
  puts ''
  if spell.damage > 0
    opponent.health -= spell.damage + opponent.bound - opponent.protected
    if opponent.health <= 0
      puts "#{opponent.name}'s health has been depeleted!"
      puts "#{player.name} wins the battle!!!"
      puts '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
      puts ''
      return
    else
      puts "#{spell.incantation} caused #{spell.damage} damage!"
      puts "#{opponent.name} now has #{opponent.health} health points."
      puts ''
    end
  end
  if spell.recovery > 0
    player.health += spell.recovery
    puts "#{player.name} recovered #{spell.recovery} points for a total of #{player.health}"
    puts ''
  end
  if player.obscured == false && spell.obscures == true
    player.obscured = true
    puts "#{player.name} is gone!"
    puts "#{opponent.name}'s accuracy is lowered"
    puts ''
  end
  if opponent.obscured == true && spell.reveals == true
    opponent.obscured = false
    puts "#{opponent.name} revealed #{player.name}!"
    puts "#{player.name}'s accuracy will no longer be lowered"
    puts ''
  end
  if player.protected == false && spell.protects > 0
    player.protected = spell.protects
    puts "#{player.name} has conjured protections!"
    puts "#{opponent.name}'s attacks are now less powerful"
    puts ''
  end
  if opponent.protected == true && spell.exposes == true
    opponent.protected = 0
    puts "#{player.name} has destroyed #{opponent.name}'s protections!"
    puts "#{player.name}'s attacks are restored to their original strength"
    puts ''
  end
  if opponent.bound == false && spell.binds > 0
    opponent.bound = spell.binds
    puts "#{player.name} has bound #{opponent.name}!"
    puts "#{player.name}'s attacks are now stronger"
    puts ''
  end
  if player.bound == true && spell.unbinds == true
    player.bound = 0
    puts "#{player.name} has released themselves from their binds!"
    puts "#{opponent.name}'s attacks have been returned to their original strength"
    puts ''
  end
  if opponent.stunned == false && spell.stuns == true
    opponent.stunned = true
    puts "#{opponent.name} has been stunned!"
    puts "#{player.name}'s accuracy has been increased"
    puts ''
  end
  if player.stunned == true && spell.revives == true
    player.stunned = false
    puts "#{player.name} has revived themselves!"
    puts "#{opponent.name}'s accuracy will no longer be increased"
    puts ''
  end
  puts '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
  puts ''
end
