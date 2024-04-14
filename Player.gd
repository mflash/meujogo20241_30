extends CharacterBody2D

@export var speed = 400
@export var rotation_speed = 1.5 # radianos

var rotation_direction = 0

var target : Vector2

func _ready() -> void:
	# inicializa o target quando o nodo está pronto
	# (ou seja, já está na cena)
	target = position
	
# Funções de ENTRADA

func get_8way_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	#print(input_direction)
	velocity = input_direction * speed
	
func get_rotation_input():
	rotation_direction = Input.get_axis("left", "right")
	velocity = transform.x * Input.get_axis("down", "up") * speed
	#print(velocity)
	
func get_mouse_input():
	#look_at(get_global_mouse_position())
	rotation = get_global_mouse_position().angle_to_point(position)
	#print(rotation_degrees)
	velocity = transform.x * Input.get_axis("down", "up") * speed
	
func get_click_input():
	if Input.is_action_pressed("click"):
		target = get_global_mouse_position()
		#print(target)

# Funções de MOVIMENTO

# movimento nas 8 direções
func move_8way(delta):
	get_8way_input()
	move_and_slide()
	
# gira com setas esq-dir, avança/retorna com setas up-down
func move_rotation(delta):
	get_rotation_input()
	rotation += rotation_direction * rotation_speed * delta
	move_and_slide()

# gira com mouse, avança/retorna com setas up-down
func move_mouse_rot(delta):
	get_mouse_input()
	move_and_slide()

# click and move
func move_click(delta):
	get_click_input()
	velocity = position.direction_to(target) * speed
	#print(velocity)
	#look_at(target)
	if position.distance_to(target) > 10:
		move_and_slide()

func _physics_process(delta):
	move_8way(delta)
