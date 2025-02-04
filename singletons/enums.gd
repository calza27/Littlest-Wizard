extends Node
enum Group { PLAYER, CAMERA }
enum DamageType { FORCE, ACID, FIRE, SLASHING, PIERCING, BLUDGEONING, COLD, LIGHTNING, THUNDER, POISON, RADIANT, NECROTIC }
enum StatusEffect { STUN, SLOW, HASTE, BUFF, ENFEEBLE, BLINDED, FRIGHTENED, RESTRAINED, LETHARGY, VIGOR, NIMBLE, CUMBERSOME }
enum AiMode { STATIONARY, WANDER, PATROL, ENGAGED }
enum TwistType { DAMAGE, DAMAGE_OVER_TIME, STATUS_EFFECT }
enum Target { PLAYER, ENEMY, GROUND }
enum Facing { UP, DOWN, LEFT, RIGHT }
enum MeleeMode { SWING, THRUST }

func group_name_for_group(group: Group) -> String:
	match group:
		Group.PLAYER:
			return "player"
		Group.CAMERA:
			return "camera"
	return ""
