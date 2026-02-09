extends RefCounted
class_name BasePlayerState

#called when state is first entered
func enter(player: Player) -> void:
	pass

# called before tic function
func validate_state(player: Player) -> void:
	pass

#called every physics frame in this state
func tic(player: Player,delta: float) -> void:
	pass

#called when leaving the state
func exit(p: Player) -> void:
	pass
