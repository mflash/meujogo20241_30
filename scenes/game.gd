extends Node2D

var gameScore := 0
@onready var scoreLabel := $HUD/ScoreLabel

# Script principal do jogo

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
