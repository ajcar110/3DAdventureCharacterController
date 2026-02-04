class_name GravityComponent
extends Node

@export var body: Player
@export var model: MeshInstance3D

@export_subgroup("Jump")
@export var jump_height: float = 6 ## how high the player will jump on one jump
@export var time_to_jump_peak: float = 1 ## how long the player takes to reach max jump
@export var time_to_fall: float = 1 ## how long it takes the player to return to starting height
@export var time_to_wall_fall: float = 2 ## how long it takes the player to slide down a wall
@export var time_to_wall_drop: float = 1 ## how long it takes the player to drop to the bottom of a wall if no Horizontal velocity is present
@export var max_jumps: int = 1 ## maximum times the player can jump before landing
@export var max_fall_speed: float = -40.0

@onready var jump_gravity: float = (-2.0 * jump_height) / ( time_to_jump_peak * time_to_jump_peak)
@onready var fall_gravity: float = (-2.0 * jump_height) / ( time_to_fall * time_to_fall)
@onready var wall_gravity: float = (-2.0 * jump_height) / (time_to_wall_fall * time_to_wall_fall)
@onready var wall_drop_gravity: float = (-2.0 * jump_height) / (time_to_wall_drop * time_to_wall_drop)
@onready var jump_velocity: float = (2.0 * jump_height) / time_to_jump_peak
@onready var wall_jump_velocity: float = jump_height / time_to_jump_peak

var wants_jump := false
var grab_released:= false
var jump_count :int = 0
var mov_dir := Vector3.ZERO
var near_wall := false
var near_wall_normal

func _ready():
	PlayerSignals.rail_complete.connect(jump)

func tik(delta: float):
	
	if body.is_on_floor():
		jump_count = 0
	if body.wall_running:
		if jump_count > 1:
			jump_count -= 1
	# jump
	if wants_jump and jump_count < max_jumps and not body.wall_running and not body.grinding:
		jump_count += 1
		print("Jumps Made")
		print(jump_count)
		print("########")
		jump()
	if grab_released and not body.is_on_floor() and near_wall:
		jump()
		body.velocity.x = near_wall_normal.x * wall_jump_velocity
		body.velocity.z = near_wall_normal.z * wall_jump_velocity
		body.velocity += -body.global_transform.basis.z * jump_velocity
	if wants_jump and body.grinding:
		jump()
		
	wants_jump = false
		#Gravity
	if body.velocity.y > max_fall_speed:
		body.velocity.y += current_gravity() * delta

func jump():
	body.velocity.y += jump_velocity

## Returns a float based on players current conditions
func current_gravity() -> float:
	if body.wall_running:
		if mov_dir != Vector3.ZERO:
			return wall_gravity
		else: return wall_drop_gravity
	elif body.grinding:
		return 0.0
	elif body.velocity.y > 0.0:
		return jump_gravity
	else:
		return fall_gravity
