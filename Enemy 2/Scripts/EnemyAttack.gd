extends FiniteStateMachine

@onready var goblin_1: GoblinOne = $"../.."
var Player : CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"

func Enter():
	Player = get_tree().get_first_node_in_group("Player")
	
func Physic_Update(delta: float):
	var enemyGlobalPos = goblin_1.global_position
	var playerGlobalPos = Player.global_position
	
	var direction = playerGlobalPos - enemyGlobalPos
	
	print("Enemy : ", enemyGlobalPos)
	print("Player : ", playerGlobalPos)
	print("direction : ", direction)
	
	if (direction.length() < 150):
		animated_sprite_2d.play("attack_side")
	else : 
		Transisioned.emit(self, "idle")
	
