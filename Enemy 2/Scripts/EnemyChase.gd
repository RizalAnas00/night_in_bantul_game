extends FiniteStateMachine

@export var EnemyBody : CharacterBody2D
@export var MoveSpeed : float
var Player : CharacterBody2D
var direction : Vector2
@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"

# Called when the node enters the scene tree for the first time.
func Enter():
	Player = get_tree().get_first_node_in_group("Player")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func Physic_Update(delta: float):
	var enemyGlobalPos = EnemyBody.global_position
	var playerGlobalPos = Player.global_position
	
	direction = playerGlobalPos - enemyGlobalPos
	
	print("Enemy : ", enemyGlobalPos)
	print("Player : ", playerGlobalPos)
	print("direction : ", direction)
	
	print("Direction Length:", direction.length())

	if (direction.length() > 130):
		#if (direction.length() < 160):  #masih belum fix
			#print("Attack Transmitted")
			#Transisioned.emit(self, "Attack") #masih belum fix
		EnemyBody.velocity = direction.normalized() * MoveSpeed
		EnemyBody.is_attacking = false
		EnemyBody.current_animation = "run"

	else : 
		animated_sprite_2d.play("attack_side")
		EnemyBody.is_attacking = true
		EnemyBody.current_animation = "attack_side"
		EnemyBody.velocity = direction.normalized() * MoveSpeed
				
	if (direction.length() > 400):
		Transisioned.emit(self,"Idle")
