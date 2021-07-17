extends Node2D

var velocity = Vector2()
var speed = 300

func _ready():
	position = Global.FlyMonster.position
	velocity = position.direction_to(Global.Player.position) * speed

