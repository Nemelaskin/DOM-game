tool

extends KinematicBody2D


var Spell_FireBoll = preload("res://Scene/Spells/Spell_FireBoll.tscn")
var speed = 300
var speedSlow = 100
var RadiusSeen = 800
var debugDraw = false
var RadiusAttack = 700
var endAttack = false
var hitPoint = 10
var attack = false
var stan = false
var velocity = Vector2()
var inp1 = Vector2()
var point
var stopMove = false
var attackTimer = 0
var followPlayer = false
var stopToAttack = false
var attackSpeed = 2

func Fire():
	var spellFireBoll = Spell_FireBoll.instance()
	var pos = global_position.direction_to(Global.Player.global_position)
	spellFireBoll.start(pos, 300)
	spellFireBoll.global_position = global_position + pos*50
	get_tree().root.add_child(spellFireBoll)
	

func _ready():
	$HitPoint.text = str(hitPoint)
	Global.Player = Global.Player
	Global.Player.connect("playerDead",self, "deadPlayer")
	
func deadPlayer():
	Global.Player = null

func _physics_process(delta):
	if not Engine.editor_hint:
		print(endAttack)
		attackTimer += delta
		if Global.Player:
			if  (Global.Player.position - position).length() < RadiusAttack and player_is_visible():
				if endAttack == false:
					endAttack = true
					$AnimatedVampire.play("Attack")
					attackTimer = 0
					stopMove = false
			elif not stopMove:
				endAttack = false
				EnemyWay()
		else:
			endAttack == false
			EnemyWay()

func damage(damag, inp):
	if hitPoint > 0:
		hitPoint -= damag
		$HitPoint.text = str(hitPoint)
	if hitPoint <= 0:
		queue_free()
		$HitPoint.text = str(0)

func RdadomWay():
	var possible = false
	var random = Vector2()
	var max_attemps = 100 
	var attemps = 0
	var space = get_world_2d().direct_space_state
	
	while(not possible and attemps < max_attemps):
		random.x = randi() % 600 - 300
		random.y = randi() % 600 - 300
		random += global_position
		var result = space.intersect_ray(global_position, random, [self])
		if not result:
			possible = true
		attemps +=1
	return random
	
func player_is_visible():
	var space = get_world_2d().direct_space_state
	var result = space.intersect_ray(global_position, Global.Player.global_position, [self])
	if result and result.collider == Global.Player:
		return true
	else:
		return false

func WayOnPlayer():
	velocity = position.direction_to(Global.Player.position) * speed
	return velocity

func EnemyWay():
	if Global.Player and position.distance_to(Global.Player.position) <= RadiusSeen and player_is_visible() == true:
		followPlayer = true
		inp1 = WayOnPlayer()
	elif followPlayer == true:
		point = RdadomWay()
		inp1 = global_position.direction_to(point)*speedSlow
		followPlayer = false
	else:
		if not point or global_position.distance_to(point) < 40 :
			point = RdadomWay()
		inp1 = global_position.direction_to(point)*speedSlow
	move_and_slide(inp1)
	$AnimatedVampire.play("walk")


func _draw():
	if debugDraw:
		draw_circle(Vector2(), RadiusSeen, Color(0.5, 0, 1, 0.2))
		draw_circle(Vector2(), RadiusAttack, Color(1, 0, 0, 0.2))

func _on_AnimatedVampire_animation_finished():
	endAttack = false
	if $AnimatedVampire.animation == "Attack":
		if player_is_visible():
			Fire()
