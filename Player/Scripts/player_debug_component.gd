extends Node

@onready var player = $".."
@onready var state_label = $"../Debug/StateLabel"

func update():
	state_label.text = player.state.get_script().get_global_name()
	if player.state == PlayerStates.TRAPJUMPSTATE:
		print(player.velocity)
