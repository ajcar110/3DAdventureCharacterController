class_name RailGrindComponent
extends Node3D

@export var body: Player
@export var dismount_velocity: float = 20.0
@export var grind_shape_cast: ShapeCast3D
@onready var rail_grind_shape_cast = $RailGrindShapeCast
@onready var rail_grind_node = null
@onready var countdown_for_next_grind = .1
@onready var countdown_for_next_grind_time_left = .1
@onready var grind_timer_complete = true
@onready var start_grind_timer = false

var detached_from_rail:bool = false
var wants_dismount:= false
 
func _ready():
	PlayerSignals.rail_complete.connect(detach_from_rail)
#GRINDING
func rail_grinding(delta):
	if not body.grinding and grind_timer_complete:
		print("Start Grinding")
		start_grinding(grind_shape_cast, delta)
	
	if body.grinding:
		grind_timer_complete = false
		rail_grind_node.chosen = true
		if not rail_grind_node.direction_selected:
			rail_grind_node.forward = is_facing_same_direction(body, rail_grind_node)
			rail_grind_node.direction_selected = true
		update_body_position(delta)



func start_grinding(grind_shape, delta):
	body.grinding = true
	var grind_rail = grind_shape.get_collider(0).get_parent()
	body.velocity.y = 0.0
	rail_grind_node = find_nearest_rail_follower(body.global_position, grind_rail)
	body.position = rail_grind_node.position
	

func update_body_position(delta):
	body.position = lerp(body.position, rail_grind_node.position, delta * 30)
	var look_at_target := Vector3(rail_grind_node.position.x,rail_grind_node.position.y,rail_grind_node.position.z)
	if body.position != look_at_target:
		body.look_at(look_at_target)

func detach_from_rail():
	detached_from_rail = true
	rail_grind_node.detach = false
	body.grinding = false
	detach_rail()



func detach_rail():
	rail_grind_node.chosen = false
	rail_grind_node.detach = false
	body.position = rail_grind_node.global_position
	start_grind_timer = true
	rail_grind_node.progress = rail_grind_node.origin_point
	detached_from_rail = false

func is_facing_same_direction(player, path_follow: PathFollow3D) -> bool:
	var player_forward = -player.global_transform.basis.z.normalized()
	var path_follow_forward = -path_follow.global_transform.basis.z.normalized()
	var dot_product = player_forward.dot(path_follow_forward)
	const THRESHOLD = 0.5
	return abs(dot_product - 1.0) < THRESHOLD

func grind_timer(delta):
	if start_grind_timer:
		if countdown_for_next_grind_time_left > 0:
			countdown_for_next_grind_time_left -= delta
			if countdown_for_next_grind_time_left <= 0:
				countdown_for_next_grind_time_left = countdown_for_next_grind
				grind_timer_complete = true
				start_grind_timer = false

func find_nearest_rail_follower(player_position, rail_node):
	var nearest_node = null
	var min_distance = INF
	for node in rail_node.get_children():
		if node.is_in_group("Rail Follower"):
			var distance = player_position.distance_to(node.global_transform.origin)
			if distance < min_distance:
				min_distance = distance
				nearest_node = node
	return nearest_node

#END GRINDING

func validate_grind() -> bool:
	return grind_shape_cast.is_colliding()
