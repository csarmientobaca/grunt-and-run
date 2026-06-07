extends Control

const DASHBOARD_SCENE := "res://scenes/dashboard/Dashboard.tscn"

@onready var _name_input: LineEdit = $MarginContainer/VBoxContainer/LineEdit
@onready var _race_option: OptionButton = $MarginContainer/VBoxContainer/RaceOption
@onready var _class_option: OptionButton = $MarginContainer/VBoxContainer/ClassOption
@onready var _status_label: Label = $MarginContainer/VBoxContainer/StatusLabel
@onready var _create_button: Button = $MarginContainer/VBoxContainer/CreateButton


func _ready() -> void:
	_setup_form()
	_race_option.item_selected.connect(_on_race_selected)
	_create_button.pressed.connect(_on_create_button_pressed)


func _setup_form() -> void:
	_name_input.placeholder_text = "Character name"

	_race_option.clear()
	for race_id: String in CharacterOptions.RACE_ORDER:
		_race_option.add_item(CharacterOptions.get_race_label(race_id))
		_race_option.set_item_metadata(_race_option.item_count - 1, race_id)

	_status_label.text = ""
	_create_button.text = "Create Character"

	if _race_option.item_count > 0:
		_race_option.select(0)
		_populate_classes_for_selected_race()


func _on_race_selected(_index: int) -> void:
	_populate_classes_for_selected_race()


func _populate_classes_for_selected_race() -> void:
	_class_option.clear()

	var race_id: String = _get_selected_race_id()
	var class_ids: Array = CharacterOptions.get_class_ids_for_race(race_id)
	for class_id_variant: Variant in class_ids:
		var class_id: String = str(class_id_variant)
		_class_option.add_item(CharacterOptions.get_class_label(class_id))
		_class_option.set_item_metadata(_class_option.item_count - 1, class_id)

	if _class_option.item_count > 0:
		_class_option.select(0)


func _on_create_button_pressed() -> void:
	var character_name: String = _name_input.text.strip_edges()
	if character_name.is_empty():
		_status_label.text = "Enter a character name."
		return

	_create_button.disabled = true
	_status_label.text = "Creating character..."

	var race: String = _get_selected_race_id()
	var character_class: String = _get_selected_class_id()
	var result: Dictionary = await NakamaService.create_character(character_name, race, character_class)

	if result.has("error"):
		_status_label.text = "Create failed: %s" % result.get("error", "unknown error")
		_create_button.disabled = false
		return

	_status_label.text = "Character created."
	var error: Error = get_tree().change_scene_to_file(DASHBOARD_SCENE)
	if error != OK:
		_status_label.text = "Could not open dashboard. Error: %s" % error
		_create_button.disabled = false


func _get_selected_race_id() -> String:
	if _race_option.selected < 0:
		return ""
	return str(_race_option.get_item_metadata(_race_option.selected))


func _get_selected_class_id() -> String:
	if _class_option.selected < 0:
		return ""
	return str(_class_option.get_item_metadata(_class_option.selected))
