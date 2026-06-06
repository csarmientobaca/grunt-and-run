extends Control

@onready var _character_label: Label = $MarginContainer/Content/CharacterLabel
@onready var _progress_label: Label = $MarginContainer/Content/ProgressLabel
@onready var _stats_label: Label = $MarginContainer/Content/StatsLabel
@onready var _sections_label: Label = $MarginContainer/Content/SectionsLabel


func _ready() -> void:
	print("")
	print("=== Dashboard started ===")

	var dashboard_result: Dictionary = await NakamaService.get_dashboard()
	print("DASHBOARD DATA")
	print(NakamaService.pretty(dashboard_result))

	_render_dashboard(dashboard_result)


func _render_dashboard(dashboard_result: Dictionary) -> void:
	var character: Dictionary = dashboard_result.get("character", {})
	var stats: Dictionary = dashboard_result.get("stats", {})
	var dashboard: Dictionary = dashboard_result.get("dashboard", {})
	var sections: Array = dashboard.get("sections", [])
	var section_names: PackedStringArray = []
	for section: Variant in sections:
		section_names.append(str(section))

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

	_sections_label.text = "Available: %s" % ", ".join(section_names)
