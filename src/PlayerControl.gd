extends KinematicBody2D


#var motion = Vector2()
#var FLOOR = Vector2(0,-1)
#export var GRAVITY = 19
#export var SPEED = 220
#export (int, 0, 200) var push_speed = 20
#export var JUMP_FORCE = -500
#var direction
#var coyoteJump=true
#
#var jump_was_pressed=false
#var is_grounded=true
#export (int) var selected_player
func _ready():
	pass
func _physics_process(delta):
#	motion.y+=GRAVITY
#	motion=move_and_slide(motion,FLOOR,false,4,PI/4,false)
#	check_if_grounded()
	pass



#func coyoteTime():
#	yield(get_tree().create_timer(.05),"timeout")
#	coyoteJump=false
#func remember_jump_time():
#	yield(get_tree().create_timer(.1),"timeout")
#	jump_was_pressed=false
#func check_if_grounded():
#	if is_on_floor():
#		is_grounded=true
#	else:
#		is_grounded=false
#	return is_grounded
