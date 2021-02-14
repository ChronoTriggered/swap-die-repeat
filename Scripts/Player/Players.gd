extends Node2D
var motion = Vector2()
var FLOOR = Vector2(0,-1)
var direction

onready var cam = get_parent().get_node("CamSwitch/Level_Camera")
onready var tween = get_parent().get_node("CamSwitch/Tween_Camera")
onready var cam_timer = get_parent().get_node("CamSwitch/SwitchCamTimer")
onready var player_quantity = get_child_count()
onready var player_amount = get_children()
var players = []
onready var current
onready var new_player
var character_num = 0
var can_move = false
var timer_started = false
var distance = Vector2()

func _ready():
	for children in player_amount:
		players.append(children)
		children.selected_player = character_num
		character_num+=1
	print(players)
	current = players[0]
	current.cam.current = true
	current.cam_will_be_enabled = true
	cam.position = current.cam.position
	new_player = players[1]
	set_physics_process(true)

func _physics_process(delta):
	restart_scene()
	back_to_menu()
	if Input.is_action_just_pressed("switch_player") and timer_started == false:
		switch_player()
	if can_move ==false:
		if current == null:
			print("null player, moving to next")
			switch_player()
		else:
			cam.position = current.cam.position
		
func restart_scene():
	var restart=Input.is_action_just_pressed("restart")
	if restart:
		get_tree().reload_current_scene()

func back_to_menu():
	var quit=Input.is_action_just_pressed("ui_cancel")
	if quit:
		get_tree().change_scene("res://Scenes/Menu/Control.tscn")

# This function gets called whenever the button is pressed
func switch_player():

	if players.size()!=1:
		cam.current = true
		can_move = true
		for player in players:
			if player == new_player:
				player.cam_will_be_enabled =true
			elif player != new_player and player!= null:
				player.cam_will_be_enabled = false
			elif player == null:
				print("No more players?")
		if current!=null and new_player!=null:
			tween.interpolate_property(cam,"position",current.cam.global_position,new_player.cam.global_position,.3,Tween.TRANS_CIRC,Tween.EASE_OUT,0)
			tween.start()
		cam_timer.start()
		timer_started = true
		print(players)

	else: current.dead()
	
#This timer starts whenever the tween to move the 
#main camera is enabled, as soon as its done, the new player camera is enabled
func _on_SwitchCamTimer_timeout():
	timer_started = false
	if new_player != null:
		new_player.cam.current = true
	current = new_player
	var b = 0
	var a = 0
	for player in players:
		if player == current:
			new_player = players[a+1 if a < players.size()-1 else b]
		a+=1
	can_move = false

func _on_QuickPlayer_killed(who):
	remove_player(who)

func _on_StrongPlayer_killed(who):
	remove_player(who)
#	print("Player in position #",who," has been deleted")
#	players.remove(who)
#	cam_timer.start()

func _on_TechPlayer_killed(who):
	remove_player(who)
#	print("Player in position #",who," has been deleted")
#	players.remove(who)
#	cam_timer.start()

func remove_player(who):
	var i = 0
	for player in players:
		if player.selected_player == who:
			players.remove(i)
			print("Player in position #",i," has been deleted")
		i+=1
	print(players)
	cam_timer.start()

func _on_TechPlayer2_killed(num):
	pass # Replace with function body.
