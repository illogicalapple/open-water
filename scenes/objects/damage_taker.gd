extends Node
class_name HealthNode

signal damage_taken (damage_taken : float, current_health : float)
signal died

var health : float = 100
var attached_object : Node
var dead : bool = false

func _init(health_val: float, area : Area3D, object : Node) -> void:
	health = health_val
	attached_object = object
	area.area_entered.connect(area_entered)
	area.body_entered.connect(body_entered)

func area_entered(area : Area3D) -> void:
	object_entered(area)

func body_entered(body : Node3D) -> void:
	object_entered(body)

func object_entered(object : Node) -> void:
	if object.get_owner() == null: # This check may need to be changed in the future.
		return
	if object.get_owner() is DamageGiver:
		var damage_giver = object.get_owner() as DamageGiver
		
		# Condition for taking damage:
		# If damage giver is the ancestor of the attached_object, then no damage
		# So, if a sword is the ancestor to the player, then that sword does not
		# do damage to the player (since it is their sword).
		if attached_object.is_ancestor_of(damage_giver):
			#print (damage_giver.name, " is player's weapon")
			return
		
		take_damage(damage_giver.damage_value, object)

func take_damage(damage : float, damage_giver : Node) -> void:
	health = max(0, health - damage) # Health can't go lower than 0.
	
	#print("damage taken: ", damage, "\n\t from ", damage_giver, " to ", attached_object)
	
	damage_taken.emit(damage, health)
	
	if health <= 0:
		died.emit()
		dead = true
		
		#print("object is dead: ", attached_object)
		#attached_object.queue_free()

