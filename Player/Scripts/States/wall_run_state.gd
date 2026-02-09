class_name WallRunState
extends BasePlayerState



func  enter(player: Player) -> void:
	player.animation_player.play("PlayerAnimations/WallRun")
