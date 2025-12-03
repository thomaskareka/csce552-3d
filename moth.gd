extends Node3D
class_name MothModel
@onready var skeleton: Skeleton3D = $Armature/Skeleton3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
const HEAD_BONE = "head"

var head_bone_index: int

func _ready():
	print(skeleton.get_bone_name(1))
	head_bone_index = skeleton.find_bone(HEAD_BONE)

func look_at_indicator(target_pos: Vector3):
	var head_pos = skeleton.get_bone_global_pose(head_bone_index).origin
	
	var look_dir = MovementHelper.get_direction_to_target(head_pos, target_pos)
	look_dir.y = - look_dir.y
	var new_basis = Basis.looking_at(look_dir, Vector3.UP)
	new_basis = new_basis.rotated(Vector3.UP, deg_to_rad(180))
	
	
	var bone_pose = skeleton.get_bone_global_pose(head_bone_index)
	bone_pose.basis = new_basis
	
	skeleton.set_bone_global_pose_override(head_bone_index, bone_pose, 1.0, true)

func set_speed(rate: float):
	animation_player.speed_scale = rate
