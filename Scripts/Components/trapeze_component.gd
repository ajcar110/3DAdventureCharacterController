class_name TrapezeComponent
extends Node3D

@onready var trapeze_shape:ShapeCast3D = $TrapezeShapeCast
@onready var trapeze_timer = $TrapezeTimer
@onready var player : Player = $".."
var bar: TrapezeBar


func attatch_player(player: Player) -> void:
	bar = trapeze_shape.get_collider(0).owner
	find_correct_direction(player,bar)
	trapeze_timer.start()


func find_correct_direction(player: Player, bar: TrapezeBar):
	var player_forward = -player.global_transform.basis.z.normalized()
	var bar_forward = -bar.global_transform.basis.z.normalized()
	var dot_product = player_forward.dot(bar_forward)
	if dot_product >= 0.0:
		player.look_at(bar.player_front_marker.global_position)
	if dot_product < 0.0:
		player.look_at(bar.player_back_marker.global_position)

func move_to_position(player: Player)-> void :
		player.global_position = lerp(
		player.global_position,
		bar.player_position_marker.global_position,
		0.3)
		find_correct_direction(player,bar)

func _on_trapeze_timer_timeout():
	if player.state == PlayerStates.TRAPIDLE:
		player.change_state_to(PlayerStates.TRAPJUMP)
