extends Control

const BOOT_SCENE := "res://scenes/boot/Boot.tscn"
const SECTION_SCENES := {
	"character_tree": "res://scenes/character_tree/CharacterTree.tscn",
	"mission_board": "res://scenes/mission_board/MissionBoard.tscn",
}

@onready var _character_label: Label = $MarginContainer/Content/CharacterLabel
@onready var _progress_label: Label = $MarginContainer/Content/ProgressLabel
@onready var _stats_label: Label = $MarginContainer/Content/StatsLabel
@onready var _sections_grid: GridContainer = $MarginContainer/Content/SectionsGrid
@onready var _reset_dev_player_button: Button = $MarginContainer/Content/ResetDevPlayerButton


func _ready() -> void:
	print("")
	print("=== Dashboard started ===")

	var dashboard_result: Dictionary = await _get_dashboard_data()
	print("DASHBOARD DATA")
	print(NakamaService.pretty(dashboard_result))

	_reset_dev_player_button.pressed.connect(_on_reset_dev_player_button_pressed)
	_render_dashboard(dashboard_result)


func _get_dashboard_data() -> Dictionary:
	if GameState.has_dashboard_data():
		return GameState.dashboard_data

	var dashboard_result: Dictionary = await NakamaService.get_dashboard()
	GameState.set_dashboard_data(dashboard_result)
	return dashboard_result


func _render_dashboard(dashboard_result: Dictionary) -> void:
	var character: Dictionary = dashboard_result.get("character", {})
	var stats: Dictionary = dashboard_result.get("stats", {})
	var dashboard: Dictionary = dashboard_result.get("dashboard", {})
	var sections: Array = dashboard.get("sections", [])

	_character_label.text = "%s | %s %s" % [
		character.get("name", "Unknown Hero"),
		str(character.get("race", "unknown")),
		str(character.get("class", "unknown")),
	]

	_progress_label.text = "Level %s | XP %s | Gold %s | Prestige %s" % [
		character.get("level", 0),
		character.get("xp", 0),
		character.get("gold", 0),
		character.get("prestige", 0),
	]

	_stats_label.text = "STR %s  AGI %s  STA %s  INT %s  VIT %s" % [
		stats.get("strength", 0),
		stats.get("agility", 0),
		stats.get("stamina", 0),
		stats.get("intelligence", 0),
		stats.get("vitality", 0),
	]

	_render_section_buttons(sections)


func _render_section_buttons(sections: Array) -> void:
	for child: Node in _sections_grid.get_children():
		child.queue_free()

	for section: Variant in sections:
		var section_id: String = str(section)
		var button: Button = Button.new()
		button.text = _format_section_label(section_id)
		button.pressed.connect(func() -> void:
			_on_section_button_pressed(section_id)
		)
		_sections_grid.add_child(button)


func _format_section_label(section_id: String) -> String:
	var words: PackedStringArray = section_id.split("_")
	for index: int in words.size():
		words[index] = words[index].capitalize()
	return " ".join(words)


func _on_section_button_pressed(section_id: String) -> void:
	print("Opening section: %s" % section_id)
	if not SECTION_SCENES.has(section_id):
		print("Section not built yet: %s" % section_id)
		return

	var scene_path: String = str(SECTION_SCENES[section_id])
	var error: Error = get_tree().change_scene_to_file(scene_path)
	if error != OK:
		push_warning("Could not open section %s. Error: %s" % [section_id, error])


func _on_reset_dev_player_button_pressed() -> void:
	NakamaService.reset_dev_identity()
	GameState.clear()
	var error: Error = get_tree().change_scene_to_file(BOOT_SCENE)
	if error != OK:
		push_warning("Could not reload boot scene. Error: %s" % error)
