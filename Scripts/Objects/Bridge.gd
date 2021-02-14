extends KinematicBody2D

onready var trigger_anim_player = get_parent().get_node("BridgeTrigger/Sprite/AnimationPlayer")
onready var anim_player = get_parent().get_node("AnimationPlayer")
onready var bridge_trigger = get_parent().get_node("BridgeTrigger/CollisionShape2D")
onready var timer = get_parent().get_node("StaticTimer")
var gravity = 9
var FLOOR = Vector2.UP
var velocity = Vector2()
export (bool) var trigger_activated = false
var can_be_triggered
func _ready():
	trigger_anim_player.play("hide")
func _physics_process(delta):
	if can_be_triggered:
		if Input.is_action_just_pressed("trigger_button"):
			bridge_trigger.queue_free()
			anim_player.play("FlipSwitch")
			yield(get_tree().create_timer(0.6),"timeout")
			trigger_activated=true
			timer.start()
	if trigger_activated:
		velocity.y +=gravity
	else:
		velocity = Vector2.ZERO
		
	velocity = move_and_slide(velocity,FLOOR)


func _on_BridgeTrigger_body_entered(body):
	trigger_anim_player.play("show_help")
	can_be_triggered=true
func _on_StaticTimer_timeout():
	trigger_activated=false
func _on_BridgeTrigger_body_exited(body):
	trigger_anim_player.play_backwards("show_help")
	trigger_anim_player.queue("hide")
	can_be_triggered=false
