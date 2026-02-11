class_name GrindState
extends BasePlayerState

var rail_ended := false

func _init():
	PlayerSignals.rail_complete.connect(detatch_from_rail)

func enter(player: Player) -> void:
	player.animation_player.play("PlayerAnimations/Grind")
	rail_ended = false
	

func validate_state(player: Player) -> void:
	if !player.grinding:
		player.change_state_to(PlayerStates.FALL)
	
	if (player.input_component.jump_pressed and
	 player.gravity_component.validate_jump(self)):
		player.change_state_to(PlayerStates.GRINDJUMP)
	
	if rail_ended:
		player.change_state_to(PlayerStates.GRINDJUMP)
	

func tic(player: Player,delta: float) -> void:
	player.rail_grinding_component.rail_grinding(delta)

func detatch_from_rail() -> void:
	rail_ended = true


func exit(p: Player) -> void:
	p.grinding = false
