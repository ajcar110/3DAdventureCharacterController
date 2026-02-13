class_name FallState
extends BasePlayerState


func enter(player: Player) -> void:
	player.animation_player.play("PlayerAnimations/Fall")
	player.rail_grinding_component.grind_shape_cast.enabled = true
	player.trapeze_component.trapeze_shape.enabled = true


func validate_state(player: Player) -> void:
	##Idle
	if player.is_on_floor():
		player.change_state_to(PlayerStates.IDLE)
		
		
	## Trapeze
	if player.trapeze_component.trapeze_shape.is_colliding():
		player.change_state_to(PlayerStates.TRAPIDLE)
		
	## CyoteTimerJump
	if player.input_component.jump_pressed:
		if !player.cyote_timer.is_stopped():
			player.change_state_to(PlayerStates.JUMP)
		## AirJump
		elif player.gravity_component.validate_jump(self):
			player.change_state_to(PlayerStates.AIRJUMP)
	
	## RailGrind
	if player.rail_grinding_component.validate_grind():
		player.change_state_to(PlayerStates.GRIND)
	
func tic(player: Player,delta: float) -> void:
	player.movement_component.tik(delta)
