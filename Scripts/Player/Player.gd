extends KinematicBody2D

signal killed(num)

export (int) var selected_player
export (float) var camera_limit = 0.0

var player_has_moved
var cam_will_be_enabled =false
var can_move = false
var motion = Vector2()
var FLOOR = Vector2(0,-1)
var is_dead = false
var cam_on = false
onready var sprite = $Sprite
onready var cam = $PlayerCam
export var GRAVITY = 19
export var SPEED = 220
export (int, 0, 200) var push_speed = 20
export var JUMP_FORCE = -500
var direction
var coyoteJump=true

var jump_was_pressed=false
var is_grounded=true

func _ready():
	connect("killed",get_parent(),"player_killed")
	can_move=false
	player_has_moved=false
	$NoMovementAllowed.start()

func _physics_process(delta):
	motion=move_and_slide(motion,FLOOR,false,4,PI/4,false)
	check_if_grounded()
	apply_gravity()
	if cam_will_be_enabled == true:#cam.current == true:
		check_movement()
		if can_move == true:
			handle_move_input()
			motion.x=SPEED*direction
			if is_grounded==true:
				coyoteJump=true
				if jump_was_pressed==true:
					motion.y= JUMP_FORCE
			if is_grounded==false:
				coyoteTime()
				motion.x=lerp(motion.x,direction*SPEED,0.2)
			face_dir(sprite)
		#$PlayerCam.current=true
	elif cam.current == false and player_has_moved: #or get_parent().player_quantity==0:
		dead()

	#Selection animation and stuff that happens when the player doesnt move
	if !player_has_moved and cam_will_be_enabled == true:
		$AnimationPlayer.play("selected")
	elif !player_has_moved and cam_will_be_enabled == false:
		$AnimationPlayer.play("idle")
	elif player_has_moved and cam_will_be_enabled == true and is_dead == false:
		$AnimationPlayer.play("idle")
		
func _input(event):
	if event.is_action_pressed("ui_up"):
		if can_move == true and cam.current == true:
			jump()
func apply_gravity():
	motion.y+=GRAVITY
func check_movement():
	if motion.x!=0:
		player_has_moved=true
func handle_move_input():
	var right=Input.get_action_strength("ui_right")
	var left=Input.get_action_strength("ui_left")	
	direction=-left+right

func _on_NoMovementAllowed_timeout():
	can_move=true
	pass # Replace with function body.

func dead():
	if is_dead == false:
		emit_signal("killed",selected_player)
		is_dead = true
	can_move=false
	motion.x=0
	$AnimationPlayer.play("dead")
	
func jump():
	jump_was_pressed=true
	remember_jump_time()
	if coyoteJump==true:
		motion.y= JUMP_FORCE
		is_grounded=false

func face_dir(target):
	if direction>0:
		target.flip_h=false
	elif direction<0:
		target.flip_h=true

func coyoteTime():
	yield(get_tree().create_timer(.05),"timeout")
	coyoteJump=false

func remember_jump_time():
	yield(get_tree().create_timer(.1),"timeout")
	jump_was_pressed=false
func check_if_grounded():
	if is_on_floor():
		is_grounded=true
	else:
		is_grounded=false
	return is_grounded

