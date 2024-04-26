extends Node2D

var gameScore := 0
@onready var scoreLabel := $HUD/ScoreLabel
var player : CharacterBody2D
var sceneLimit : Marker2D
@onready var music := $Music

var currentScene = null

# Script principal do jogo

func _ready() -> void:
	sceneLimit = $Level/SceneLimit
	player = $Level/AnimPlayer
	#print(sceneLimit.position)
	#music.play()
	
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
	#if !music.playing:
	#	music.play()
	scoreLabel.text = "Score: " + str(gameScore)
	
func _physics_process(delta: float) -> void:
	if sceneLimit == null:
		player = $Level/AnimPlayer
		sceneLimit = $Level/SceneLimit		
		#print("sceneLimit: ", sceneLimit)
		#print("player: ", player)
	if player.position.y > sceneLimit.position.y:
		print("Jogador saiu!")
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")
		
	# Pressione X para trocar para a segunda fase
	if Input.is_action_just_pressed("change"):
		call_deferred("goto_scene", "res://levels/level_2.tscn")
		
	# Pressione F para ligar/desligar o filtro passa-baixa
	if Input.is_action_just_pressed("filter"):
		var lowpass := AudioServer.get_bus_effect(1, 0) as AudioEffectLowPassFilter # 1-Music, 0-Low Pass (primeiro efeito)
		if lowpass.cutoff_hz == 500:
			lowpass.cutoff_hz = 20000
		else:
			lowpass.cutoff_hz = 500
	
func goto_scene(path: String):
	$Level.free()	
	var res := ResourceLoader.load(path)
	currentScene = res.instantiate()	
	#player = get_child(0).get_node("AnimPlayer")
	add_child(currentScene)
	sceneLimit = null
