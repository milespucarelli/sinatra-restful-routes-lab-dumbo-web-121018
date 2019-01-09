class WizardSpell < ActiveRecord::Base
  belongs_to :wizard
  belongs_to :spell

  def self.create_and_associate(character, spell)
    ws = WizardSpell.create
    character.wizard_spells << ws
    spell.wizard_spells << ws
  end
end
