extends Area2D

var items_in_range = {}

func _on_PickupZone_body_entered(body):
	items_in_range[body] = body
	
	if items_in_range.size() > 0:
		var pickup_item = items_in_range.values()[0]
		pickup_item.pick_up_item(get_parent())
		items_in_range.erase(pickup_item)

func _on_PickupZone_body_exited(body):
	if items_in_range.has(body):
		items_in_range.erase(body)
		
	
