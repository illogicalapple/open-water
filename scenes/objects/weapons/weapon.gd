extends DamageGiver
class_name Weapon

@export var animation : AnimationPlayer

# Called whenever weapon needs to attack.
func attack() -> void:
	if animation == null: # error handle
		printerr("no attack animation on weapon found")
		return
	
	animation.stop()
	
	# Currently for the sword: 
	# turns on collision for duration of animation
	# and just rotates the sword on z axis.
	animation.play("attack")
