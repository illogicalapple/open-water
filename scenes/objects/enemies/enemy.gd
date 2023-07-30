extends CharacterBody3D

@export var health : float = 100
@export var hitbox : Area3D
@export var hurt_audio : AudioStreamPlayer3D

func _ready() -> void:
	var damage_logic = HealthNode.new(health, hitbox, self)
	damage_logic.damage_taken.connect(damage_taken)
	damage_logic.died.connect(died)

## Called from damage_logic node's damage_taken signal.
func damage_taken(damage_taken : float, current_health : float) -> void:
	health = current_health
	print (name, " took damage: [", damage_taken, "] health = ", health)
	
	# Randomize pitch before playing for more variance.
	hurt_audio.stop()
	hurt_audio.pitch_scale = randf_range(1 + 0.3, 1 + 0.7) 
	hurt_audio.play()

## Called from damage_logic node's died signal.
func died() -> void:
	print (name , " died")
	queue_free() # removes player from game.
