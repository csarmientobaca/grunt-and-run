extends Control

const DASHBOARD_SCENE := "res://scenes/dashboard/Dashboard.tscn"

@onready var _identity_label: Label = $MarginContainer/Content/IdentityLabel
@onready var _progress_label: Label = $MarginContainer/Content/ProgressLabel
@onready var _stats_label: Label = $MarginContainer/Content/StatsLabel
@onready var _progression_label: Label = $MarginContainer/Content/ProgressionLabel
@onready var _back_button: Button = $MarginContainer/Content/BackButton


func _ready() -> void:
	print("")
	print("=== Character Tree started ===")

	_back_button.pressed.connect(_on_back_button_pressed)
	_render_character_tree()


func _render_character_tree() -> void:
	var data: Dictionary = GameState.dashboard_data
	var character: Dictionary = data.get("character", {})
	var stats: Dictionary = data.get("stats", {})

	_identity_label.text = "%s | %s %s" % [
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

	_stats_label.text = "Stats\nSTR %s\nAGI %s\nSTA %s\nINT %s\nVIT %s" % [
		stats.get("strength", 0),
		stats.get("agility", 0),
		stats.get("stamina", 0),
		stats.get("intelligence", 0),
		stats.get("vitality", 0),
	]

	_progression_label.text = "\n".join([
		"Progression",
		"Level 1 Core Traits",
		"Locked: Level 2",
		"Locked: Level 5",
		"Locked: Level 10",
	])


func _on_back_button_pressed() -> void:
	var error: Error = get_tree().change_scene_to_file(DASHBOARD_SCENE)
	if error != OK:
		push_warning("Could not return to dashboard. Error: %s" % error)
