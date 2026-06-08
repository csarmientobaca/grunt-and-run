extends Control

const DASHBOARD_SCENE := "res://scenes/dashboard/Dashboard.tscn"

const MISSIONS := [
	{
		"location_id": "dark_forest",
		"location_name": "Dark Forest",
		"mission_id": "dark_forest_scout_old_trail",
		"title": "Scout the Old Trail",
		"danger": 1,
		"reward_gold": 10,
		"recommended_level": 1,
	},
	{
		"location_id": "dark_forest",
		"location_name": "Dark Forest",
		"mission_id": "dark_forest_recover_supplies",
		"title": "Recover Lost Supplies",
		"danger": 1,
		"reward_gold": 12,
		"recommended_level": 1,
	},
	{
		"location_id": "outside_castle",
		"location_name": "Outside Castle",
		"mission_id": "outside_castle_defend_gate",
		"title": "Defend the Gate",
		"danger": 2,
		"reward_gold": 18,
		"recommended_level": 2,
	},
	{
		"location_id": "lost_caverns",
		"location_name": "Lost Caverns",
		"mission_id": "lost_caverns_missing_scout",
		"title": "Find the Missing Scout",
		"danger": 3,
		"reward_gold": 25,
		"recommended_level": 3,
	},
]

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

	var current_location_id: String = ""
	for mission: Dictionary in MISSIONS:
		var location_id: String = str(mission.get("location_id", "unknown"))
		if location_id != current_location_id:
			current_location_id = location_id
			_add_location_header(str(mission.get("location_name", "Unknown Location")))

		_add_mission_button(mission)


func _add_location_header(location_name: String) -> void:
	var label: Label = Label.new()
	label.text = location_name
	label.add_theme_font_size_override("font_size", 20)
	_mission_list.add_child(label)


func _add_mission_button(mission: Dictionary) -> void:
	var button: Button = Button.new()
	button.text = "%s | Danger %s | Reward %s gold | Level %s" % [
		mission.get("title", "Unknown Mission"),
		mission.get("danger", 0),
		mission.get("reward_gold", 0),
		mission.get("recommended_level", 1),
	]
	button.pressed.connect(func() -> void:
		_on_mission_pressed(mission)
	)
	_mission_list.add_child(button)


func _on_mission_pressed(mission: Dictionary) -> void:
	var mission_id: String = str(mission.get("mission_id", "unknown"))
	_status_label.text = "Selected mission: %s" % mission.get("title", "Unknown Mission")
	print("Selected mission: %s" % mission_id)


func _on_back_button_pressed() -> void:
	var error: Error = get_tree().change_scene_to_file(DASHBOARD_SCENE)
	if error != OK:
		push_warning("Could not return to dashboard. Error: %s" % error)
