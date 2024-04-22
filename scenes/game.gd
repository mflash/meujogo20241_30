extends Node2D

var gameScore := 0
@onready var scoreLabel := $HUD/ScoreLabel
var player : CharacterBody2D
var sceneLimit : Marker2D

var currentScene = null

# Script principal do jogo

func _ready() -> void:
	# Primeiro filho é sempre o level!
	sceneLimit = get_child(0).get_node("SceneLimit")
	player = get_child(0).get_node("AnimPlayer")
	#print(sceneLimit.position)
	
# Callback chamado quando o timer gerar um timeout
func _on_timer_timeout() -> void:
	print("Timer!")

# Callback chamado quando o jogador saltar (signal)
func _on_anim_player_jumped() -> void:
	#print("Jumped!")
	gameScore += 1
	print("Jumped: "+str(gameScore))
	scoreLabel.text = "Score: " + str(gameScore)

# Chamada através de call_group
func updateScore():
	gameScore += 1
	scoreLabel.text = "Score: " + str(gameScore)

func _input(event: InputEvent) -> void:
	if event is InputEventKey:		
		var keyEvent = event as InputEventKey
		if keyEvent.is_pressed() and event.keycode == KEY_2:
			print("DOIS!")
			call_deferred("goto_scene", "res://levels/level_2.tscn")		
	
func _physics_process(delta: float) -> void:
	if sceneLimit == null:
		var raiz = get_tree().get_root().get_child(0)
		#print(raiz)
		sceneLimit = raiz.find_child("SceneLimit", true, false)
		player = raiz.find_child("AnimPlayer", true, false)
		#print("sceneLimit: ", sceneLimit)
		#print("player: ", player)
	if player.position.y > sceneLimit.position.y:
		print("Jogador saiu!")
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")
#	if Input.is_key_pressed(KEY_X):
#		call_deferred("goto_scene", "res://scenes/game_over.tscn")
	#if Input.is_key_pressed(KEY_2):
	#	call_deferred("goto_scene", "res://levels/level_2.tscn")		

func goto_scene(path: String):
	print("Total children: "+str(get_child_count()))
	var world := get_child(0)
	world.free()
	var res := ResourceLoader.load(path)
	currentScene = res.instantiate()	
	#player = get_child(0).get_node("AnimPlayer")
	get_tree().get_root().get_child(0).add_child(currentScene)
	sceneLimit = null
