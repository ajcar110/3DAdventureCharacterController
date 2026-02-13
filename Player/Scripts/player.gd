class_name Player

extends CharacterBody3D

@export var visuals: Node3D
@export var player_stats: PlayerStats
@export var input_component: InputComponent
@export var movement_component: MovementComponent
@export var camera_component: CameraComponent
@export var gravity_component: GravityComponent
@export var rail_grinding_component: RailGrindComponent
@export var trapeze_component: TrapezeComponent
@export var swim_component: SwimComponent
@export var animation_player: AnimationPlayer
@export var debug_component: Node

@onready var cyote_timer = $CyoteTimer

var wall_running:= false
var grinding := false

var state: BasePlayerState = PlayerStates.IDLE

func _ready():
	state.enter(self)
	
func _physics_process(delta):
	input_component.update()
	debug_component.update()
	
	## ALL MOVEMENT COMPONENTS MUST UPDATE IN FUNCTION TO ADJUST BY CAMERA
	modify_directions_by_camera_angle()
	
	
	## State Logic##
	state.validate_state(self)
	state.tic(self,delta)
	
	gravity_component.tik(delta)
	var was_on_floor = is_on_floor()
	move_and_slide()
	if was_on_floor and !is_on_floor():
		cyote_timer.start()


## Reads Directional Input for Player, Modifies it based on Camera
## and returns the Result
func get_move_input()-> Vector3:
	var input_dir = Vector2(input_component.move_dir.x,input_component.move_dir.z)
	var direction: Vector3
	direction = (camera_component.global_basis * input_component.move_dir)
	direction = Vector3(direction.x,0,direction.z).normalized() * input_dir.length()
	return direction

func get_horizontal_velocity() -> float:
	return Vector2(velocity.x, velocity.z).length()

func change_state_to(next_state: BasePlayerState):
	state.exit(self)
	state = next_state
	state.enter(self)
	

func modify_directions_by_camera_angle():
	var modified_direction = get_move_input()
	movement_component.move_dir = modified_direction
	gravity_component.mov_dir = modified_direction


func stop_moving() -> void:
	velocity = Vector3.ZERO
