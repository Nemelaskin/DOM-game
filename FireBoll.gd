extends Area2D

var dammage = 3
var velocity = Vector2()

func start(dir, speed):
	velocity = dir * speed

func _physics_process(delta):
	translate(velocity * delta)

func _on_FireBoll_body_entered(body):
	if body.has_method("damage"):
		body.damage(dammage, global_position.direction_to(body.global_position) * 100)
	queue_free()


func _on_Timer_timeout():
	queue_free()
