class_name TrapezeIdleState
extends BasePlayerState



func enter(player: Player) -> void:
	player.animation_player.play("PlayerAnimations/TrapezeIdle")
	var old_h_velocity = Vector2(player.velocity.x,player.velocity.z)
	player.stop_moving()
	player.trapeze_component.attatch_player(player)
