extends CharacterBody2D

const GRAVITY = 4200
const JUMP_SPEED = -1800

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	velocity.y += GRAVITY * delta
	if is_on_floor():
		if not get_parent().game_running:
			$AnimatedSprite2D.play("Inactivo")
		else:
			$"Correr Col".disabled = false
			if Input.is_action_pressed("ui_accept"):
				velocity.y = JUMP_SPEED
				#$JumpSound.play()
			elif Input.is_action_pressed("ui_down"):
				$AnimatedSprite2D.play("Agachado")
				$"Correr Col".disabled = true
			else:
				$AnimatedSprite2D.play("Correr")
	else:
		$AnimatedSprite2D.play("Saltar")
		
	move_and_slide()
		   
