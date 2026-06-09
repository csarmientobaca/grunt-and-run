extends Node

var profile_state: Dictionary = {}
var dashboard_data: Dictionary = {}
var inventory: Dictionary = {
	"wolf_fat": 2,
	"lost_supply_crate": 1,
	"guard_token": 2,
	"cave_crystal": 1,
}
var local_rewards: Dictionary = {
	"gold": 0,
	"items": [],
}


func set_profile_state(value: Dictionary) -> void:
	profile_state = value
	if _has_dashboard_payload(value):
		dashboard_data = {
			"character": value.get("character", {}),
			"stats": value.get("stats", {}),
			"dashboard": value.get("dashboard", {}),
		}


func set_dashboard_data(value: Dictionary) -> void:
	dashboard_data = value


func has_dashboard_data() -> bool:
	return not dashboard_data.is_empty()


func clear() -> void:
	profile_state = {}
	dashboard_data = {}
	reset_mock_inventory()


func reset_mock_inventory() -> void:
	inventory = {
		"wolf_fat": 2,
		"lost_supply_crate": 1,
		"guard_token": 2,
		"cave_crystal": 1,
	}
	local_rewards = {
		"gold": 0,
		"items": [],
	}


func get_item_count(item_id: String) -> int:
	return int(inventory.get(item_id, 0))


func has_required_items(requirements: Array) -> bool:
	for requirement_value: Variant in requirements:
		if not requirement_value is Dictionary:
			return false

		var requirement: Dictionary = requirement_value
		var item_id: String = str(requirement.get("item_id", ""))
		var quantity: int = int(requirement.get("quantity", 0))
		if get_item_count(item_id) < quantity:
			return false

	return true


func consume_required_items(requirements: Array) -> void:
	for requirement_value: Variant in requirements:
		if not requirement_value is Dictionary:
			continue

		var requirement: Dictionary = requirement_value
		var item_id: String = str(requirement.get("item_id", ""))
		var quantity: int = int(requirement.get("quantity", 0))
		inventory[item_id] = max(0, get_item_count(item_id) - quantity)


func add_local_reward(reward: Dictionary) -> void:
	local_rewards["gold"] = int(local_rewards.get("gold", 0)) + int(reward.get("gold", 0))

	var owned_items: Array = local_rewards.get("items", [])
	var reward_items: Array = reward.get("items", [])
	for item: Variant in reward_items:
		owned_items.append(str(item))
	local_rewards["items"] = owned_items


func _has_dashboard_payload(value: Dictionary) -> bool:
	return value.has("character") and value.has("stats") and value.has("dashboard")
