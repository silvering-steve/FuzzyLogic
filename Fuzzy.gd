extends Node

onready var text = $CanvasLayer/RichTextLabel

func _ready():
	var health = 100
	
	if health == 100 and health >= 80:
		print("Weapon")
	elif health < 80 and health >= 30:
		print("Mana Potion")
	elif health < 30:
		print("Health Potion")

# Define membership functions for health and items
func health_membership(x: float, low: float, high: float):
	# Triangular membership function
	if x <= low or x >= high:
		return 0.0
	elif x < (low + high) / 2:
		return 2 * (x - low) / (high - low)
	else:
		return 2 * (high - x) / (high - low)

func item_membership(x: float, low: float, high: float):
	# Triangular membership function
	if x <= low or x >= high:
		return 0.0
	elif x < (low + high) / 2:
		return 2 * (x - low) / (high - low)
	else:
		return 2 * (high - x) / (high - low)

# Define rules for item dropping
func determine_item(health: float):
	# Membership values for low, medium, and high health
	var low_health = health_membership(health, 0, 30)
	var med_health = health_membership(health, 20, 70)
	var high_health = health_membership(health, 60, 101)
	
	# Membership values for different item types
	var health_potion = item_membership(health, 0, 50)
	var mana_potion = item_membership(health, 20, 80)
	var weapon = item_membership(health, 50, 101)
	
	# Apply max-min inference to determine item type
	# Rules:
	#   IF low health THEN health potion
	#   IF medium health THEN mana potion
	#   IF high health THEN weapon
	var item_strength = {"Health Potion": low_health * health_potion,
					 "Mana Potion": med_health * mana_potion,
					 "Weapon": high_health * weapon}
					 
	# Defuzzify using max-min method
	var item_max = item_strength.values().max()
	
	var item_values = null
	
	for keys in item_strength.keys():
		if item_strength[keys] == item_max:
			item_values = keys
		else:
			continue
	
	return item_values
	
func _on_LineEdit_text_entered(new_text):
	text.text = determine_item(float(new_text))
