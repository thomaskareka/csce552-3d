extends Node

@onready var parent: CharacterBody3D = get_parent()
@onready var aim_indicator: MeshInstance3D = $"../AimIndicator"

@export var input_deadzone := 0.15
@export var max_velocity := 5
@export var acceleration := 8
@export var deceleration := 10

var mouse_aim_sensitivity := 0.5
var joystick_aim_sensitivity := 5

const DASH_COOLDOWN = 0.6
const DASH_LENGTH = 0.3
const DASH_SPEED_CAP = 2 #multiplier
const SMALL_PROJECTILE_COOLDOWN = 0.33
const CHARGE_COOLDOWN = 2
const CHARGE_TIME = 0.8

const AIM_RADIUS = 2

const MIN_ACCEL = 0.25
var target_velocity := Vector3.ZERO
var current_velocity := Vector3.ZERO

var dash_time = 0
var dash_cooldown_time = 0
var dash_boost := 0.0
var is_dashing := false
var dash_dir := Vector3.ZERO

var small_projectile_cooldown_time = SMALL_PROJECTILE_COOLDOWN
var charge_held_time = CHARGE_TIME
var charge_projectile_cooldown_time = CHARGE_COOLDOWN

var use_relative_joystick := false
var mouse_delta := Vector2.ZERO
var aim_position := Vector2.ZERO
var mouse_last_used := true

func _ready() -> void:
	use_relative_joystick = GlobalData.data.get("use_relative", false)
	mouse_aim_sensitivity = GlobalData.data.get("mouse_sensitivity", 0.5)
	joystick_aim_sensitivity = GlobalData.data.get("joystick_sensitivity", 5)

	print("using relative: ", use_relative_joystick)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_delta += event.relative

func _physics_process(delta: float):
	_update_dash_cooldown(delta)
	_handle_move(delta)
	_handle_aim(delta)
	_handle_attack(delta)
	mouse_delta = Vector2.ZERO

func _update_dash_cooldown(delta: float) -> void:
	if dash_time > 0.0: 
		dash_time -= delta
		if dash_time <= 0.0:
			is_dashing = false
	elif dash_cooldown_time > 0.0:
		dash_cooldown_time -= delta


func _handle_move(delta: float) -> void:
	var raw_input = Input.get_vector("move_right", "move_left", "move_down", "move_up", input_deadzone)
	var input_magnitude := raw_input.length()
	var move_dir = Vector3(raw_input.x, raw_input.y, 0).normalized()
	
	if Input.is_action_just_pressed("dash_input") and dash_cooldown_time <= 0.0 and move_dir != Vector3.ZERO:
		is_dashing = true
		dash_time = DASH_LENGTH
		dash_cooldown_time = DASH_COOLDOWN
		dash_dir = move_dir
	
	if is_dashing:
		current_velocity = lerp(dash_dir * max_velocity * DASH_SPEED_CAP, dash_dir * max_velocity, (1.0  - (dash_time / DASH_LENGTH)))
	else:
		target_velocity = move_dir * max_velocity * input_magnitude
		
		if input_magnitude > 0.0: 
			var acceleration_scale = max(input_magnitude, MIN_ACCEL)
			var weight := clampf(acceleration * acceleration_scale * delta, 0.0, 1.0)
			current_velocity = current_velocity.lerp(target_velocity, weight)
		else:
			var weight := clampf(deceleration * delta, 0.0, 1.0)
			current_velocity = current_velocity.lerp(Vector3.ZERO, weight)
	
	parent.velocity = current_velocity
	parent.move_and_slide()
	
func _handle_aim(delta: float) -> void:
	var joystick_raw = Input.get_vector("aim_right", "aim_left", "aim_down", "aim_up", 0.1)
	var joystick_magnitude = joystick_raw.length()
	if mouse_delta != Vector2.ZERO:
		aim_position += Vector2(-mouse_delta.x, -mouse_delta.y) * delta * mouse_aim_sensitivity
		mouse_last_used = true

	if use_relative_joystick and joystick_magnitude > 0 and not mouse_last_used:
		aim_position += joystick_raw * AIM_RADIUS * delta * joystick_aim_sensitivity
	elif not use_relative_joystick and mouse_delta == Vector2.ZERO and not mouse_last_used:
		aim_position = joystick_raw * AIM_RADIUS
		
	if aim_position.length() > AIM_RADIUS:
		aim_position = aim_position.normalized() * AIM_RADIUS

	aim_indicator.position.x = aim_position.x
	aim_indicator.position.y = aim_position.y
	mouse_last_used = joystick_magnitude == 0

func _handle_attack(delta: float):
	if Input.is_action_just_released("charge_input"):
		if charge_held_time <= 0 and charge_projectile_cooldown_time <= 0:
			#TODO: attack
			print("charge attack")
			charge_projectile_cooldown_time = CHARGE_COOLDOWN
		charge_held_time = CHARGE_TIME
	elif not Input.is_action_pressed("charge_input"):
		charge_held_time = CHARGE_TIME
		if charge_projectile_cooldown_time > 0:
			charge_projectile_cooldown_time -= delta
			
		if small_projectile_cooldown_time > 0:
			small_projectile_cooldown_time -= delta
		else:
			small_projectile_cooldown_time = SMALL_PROJECTILE_COOLDOWN
			#TODO: attack
			print("small attack")
	else:
		small_projectile_cooldown_time = SMALL_PROJECTILE_COOLDOWN
		if charge_projectile_cooldown_time <= 0:
			charge_held_time -= delta
