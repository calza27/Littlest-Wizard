class_name Fireball
extends Spell

const MAX_RANGE = 1000

func _init():
	self.spell_name = get_spell_name()
	self.level = 3
	self.mana_cost = 40
	self.cooldown = 10
	self.target = Constants.Target.GROUND
	self.attack = Attack.build(150, Constants.DamageType.FIRE)
	var image = Image.load_from_file(Files.SPELL_ICONS["fireball"])
	self.sprite = ImageTexture.create_from_image(image)


func cast() -> bool:
	const RESOURCE = preload(Files.SPELLS["firey blast"])
	var blast: FireyBlast = RESOURCE.instantiate()
	blast.set_attack(self.attack)
	blast.animation_finished.connect(_end_cast)
	Utils.get_node_for_group(Constants.Group.SPELLS).add_child(blast)
	return true
	
func get_spell_name() -> String:
	return "Fiery Blast"

func _end_cast() -> void:
	cast_end.emit()
