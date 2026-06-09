extends Control

const DASHBOARD_SCENE := "res://scenes/dashboard/Dashboard.tscn"

@onready var _mission_list: VBoxContainer = $MarginContainer/Content/ScrollContainer/MissionList
@onready var _status_label: Label = $MarginContainer/Content/StatusLabel
@onready var _back_button: Button = $MarginContainer/Content/BackButton


func _ready() -> void:
	print("")
	print("=== Mission Board started ===")

	_back_button.pressed.connect(_on_back_button_pressed)
	_render_missions()


func _render_missions() -> void:
	for child: Node in _mission_list.get_children():
		child.queue_free()

	var current_giver_id: String = ""
	var contracts: Array = MissionCatalog.get_available_contracts()
	for contract_value: Variant in contracts:
		var contract: Dictionary = contract_value
		var giver_id: String = str(contract.get("giver_id", "unknown"))
		if giver_id != current_giver_id:
			current_giver_id = giver_id
			_add_giver_header(str(contract.get("giver_name", "Unknown Giver")))

		_add_contract_button(contract)


func _add_giver_header(giver_name: String) -> void:
	var label: Label = Label.new()
	label.text = giver_name
	label.add_theme_font_size_override("font_size", 20)
	_mission_list.add_child(label)


func _add_contract_button(contract: Dictionary) -> void:
	var button: Button = Button.new()
	var requirements: Array = _get_requirements(contract)
	var can_turn_in: bool = GameState.has_required_items(requirements)
	var turn_in_status: String = "Missing required items"
	if can_turn_in:
		turn_in_status = "Ready to turn in"

	button.text = "%s\nNeed: %s\nHave: %s\nFind: %s | Reward: %s\n%s" % [
		contract.get("title", "Unknown Contract"),
		_format_requirements(requirements),
		_format_owned_requirements(requirements),
		contract.get("location_name", "Unknown Location"),
		_format_reward(contract.get("reward", {})),
		turn_in_status,
	]
	button.pressed.connect(func() -> void:
		_on_contract_pressed(contract)
	)
	_mission_list.add_child(button)


func _on_contract_pressed(contract: Dictionary) -> void:
	var contract_id: String = str(contract.get("contract_id", "unknown"))
	print("Selected contract: %s" % contract_id)
	var requirements: Array = _get_requirements(contract)
	if not GameState.has_required_items(requirements):
		_status_label.text = "Missing items for: %s" % contract.get("title", "Unknown Contract")
		return

	var reward: Dictionary = _get_reward(contract)
	GameState.consume_required_items(requirements)
	GameState.add_local_reward(reward)
	_status_label.text = "Turned in: %s | Reward: %s" % [
		contract.get("title", "Unknown Contract"),
		_format_reward(reward),
	]
	_render_missions()


func _format_requirements(requirements_value: Variant) -> String:
	if not requirements_value is Array:
		return "Unknown items"

	var parts: PackedStringArray = []
	var requirements: Array = requirements_value
	for requirement_value: Variant in requirements:
		if not requirement_value is Dictionary:
			continue

		var requirement: Dictionary = requirement_value
		parts.append("%s %s" % [
			requirement.get("quantity", 1),
			requirement.get("item_name", "Unknown Item"),
		])

	if parts.is_empty():
		return "No items"
	return ", ".join(parts)


func _format_owned_requirements(requirements: Array) -> String:
	var parts: PackedStringArray = []
	for requirement_value: Variant in requirements:
		if not requirement_value is Dictionary:
			continue

		var requirement: Dictionary = requirement_value
		var item_id: String = str(requirement.get("item_id", ""))
		var needed: int = int(requirement.get("quantity", 0))
		var owned: int = GameState.get_item_count(item_id)
		parts.append("%s/%s %s" % [
			owned,
			needed,
			requirement.get("item_name", "Unknown Item"),
		])

	if parts.is_empty():
		return "No items"
	return ", ".join(parts)


func _format_reward(reward_value: Variant) -> String:
	if not reward_value is Dictionary:
		return "None"

	var reward: Dictionary = reward_value
	var parts: PackedStringArray = []
	var gold: int = int(reward.get("gold", 0))
	if gold > 0:
		parts.append("%s gold" % gold)

	var items: Array = reward.get("items", [])
	for item: Variant in items:
		parts.append(str(item).replace("_", " "))

	if parts.is_empty():
		return "None"
	return ", ".join(parts)


func _get_requirements(contract: Dictionary) -> Array:
	var requirements: Variant = contract.get("requirements", [])
	if requirements is Array:
		return requirements
	return []


func _get_reward(contract: Dictionary) -> Dictionary:
	var reward: Variant = contract.get("reward", {})
	if reward is Dictionary:
		return reward
	return {}


func _on_back_button_pressed() -> void:
	var error: Error = get_tree().change_scene_to_file(DASHBOARD_SCENE)
	if error != OK:
		push_warning("Could not return to dashboard. Error: %s" % error)
