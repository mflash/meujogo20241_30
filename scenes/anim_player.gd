extends CharacterBody2D

@export var speed = 300.0
@export var jump_speed := -1000.0
@export var gravity := 2500.0
@onready var sprite = $PlayerSprite
@onready var jumpsound := $JumpSound
#@onready var box := preload("res://objects/box.tscn"
@export var box : PackedScene

signal jumped

#func _ready() -> void:
#	sprite = $PlayerSprite
	
func get_8way_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	#print(input_direction)
	velocity = input_direction * speed
	
func get_side_input():
	velocity.x = 0
	var vel := Input.get_axis("left", "right")
	var jump := Input.is_action_just_pressed('jump')

	if is_on_floor() and jump:		
		velocity.y = jump_speed
		# Emitir o sinal "jumped"
		# jumped.emit()
		get_tree().call_group("hud", "updateScore")
		var b : = box.instantiate()
		b.position = global_position
		owner.add_child(b)		
		jumpsound.play()
		# Controle de volume (0 = padrão)
		#AudioServer.set_bus_volume_db(2, 0)
	velocity.x = vel * speed
	
func animate():
	if velocity.x > 0:		
		sprite.play("right")
	elif velocity.x < 0:
		sprite.play("left")
	elif velocity.y > 0:
		sprite.play("down")
	elif velocity.y < 0:
		sprite.play("up")
	else:
		sprite.stop()		

func animate_side():
	if velocity.x > 0:
		sprite.play("right")
	elif velocity.x < 0:
		sprite.play("left")
	else:
		sprite.stop()
	
func move_8way(delta):
	get_8way_input()
	animate()
	#move_and_slide()
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		velocity = velocity.bounce(collision_info.get_normal())
		move_and_collide(velocity * delta * 10)

func move_side(delta):
	velocity.y += gravity * delta
	get_side_input()
	animate_side()
	move_and_slide()
	
func _physics_process(delta):
	#move_8way(delta)
	move_side(delta)
