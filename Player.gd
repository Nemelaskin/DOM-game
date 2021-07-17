extends KinematicBody2D

signal playerDead
export (PackedScene) var Spell_FireBoll = null
export (int) var speed = 200
var speedfly = 4
var flyMonster
var velocity = Vector2()
var inp = Vector2()
var TimerV = 0
var stop = false
var damageM 
var hitPoint = 1000
var dir = Vector2()
var tim = 0 
var booltime = false
var timerAttack = 0
func _ready():
	
	Global.Player = self
	$HitPoint.text = str(hitPoint)
	
func damage(damag, iinp):
	if hitPoint > 0:
		hitPoint -= damag
		$HitPoint.text = str(hitPoint)
	if hitPoint <= 0:
		Global.Player = null
		emit_signal("playerDead")
		queue_free()
		$HitPoint.text = str(0)

func Fire():
	var spellFireBoll = Spell_FireBoll.instance()
	var pos = global_position.direction_to(get_global_mouse_position())
	spellFireBoll.start(pos, 500)
	spellFireBoll.global_position = global_position + pos*80
	get_tree().root.add_child(spellFireBoll)

func get_input():
	dir = Vector2()
	if Input.is_action_pressed("ui_left"):
		dir.x +=-1
	if Input.is_action_pressed("ui_right"):
		dir.x += 1
	if Input.is_action_pressed("ui_up"):
		dir.y +=-1
	if Input.is_action_pressed("ui_down"):
		dir.y += 1
	if dir:
		dir = dir.normalized()
	var target_speed = speed
	var target = dir * target_speed
	velocity = velocity.linear_interpolate(target, 0.2)

# warning-ignore:unused_argument
func _physics_process(delta):
	timerAttack += delta
	if Input.is_action_pressed("Attack_On_Mouse") and timerAttack > 1:
		Fire()
		timerAttack = 0
	if not Engine.editor_hint:
		tim += delta
		if stop == true:
			if tim > 0.3:
				damage(damageM, inp * 2)
				tim = 0
			TimerV += delta
			if TimerV < 0.11:
				move_and_slide(inp * 10)
			else:
				TimerV = 0
			stop = false
		
		get_input()
		if dir:
			$AnimatedSprite.play("walk")
		else:
			$AnimatedSprite.play("idle")
		$AnimatedSprite.flip_h = velocity.x < 0
		velocity = move_and_slide(velocity)


func near(dmge, set, stp):
	inp = set
	stop = stp
	damageM = dmge
