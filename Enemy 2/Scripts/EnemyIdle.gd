extends FiniteStateMachine

@export var enemy: CharacterBody2D
@export var SPEED_ENEMY: float
var Player : CharacterBody2D

var direction: Vector2
var wander_time: float

var move_direction: Vector2

func randomize_and_wander():
	move_direction = Vector2(randf_range(-1,1), randf_range(-1, 1)).normalized()
	wander_time = randf_range(1,3)
	
func Enter():
	Player = get_tree().get_first_node_in_group("Player")
	randomize_and_wander()
	
func Update(delta: float):
	if wander_time > 0:
		wander_time -= delta
		
	else:
		randomize_and_wander()
		
func Physic_Update(_delta: float):
	if enemy:
		enemy.velocity = move_direction * SPEED_ENEMY

	direction = Player.global_position - enemy.global_position

	if (direction.length() < 300):
		Transisioned.emit(self,"Chase")
