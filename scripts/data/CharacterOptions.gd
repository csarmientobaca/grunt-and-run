extends RefCounted
class_name CharacterOptions

const RACE_ORDER: Array[String] = [
	"human",
	"goblin",
]

const RACES := {
	"human": {
		"label": "Human",
		"classes": ["warrior", "ranger"],
	},
	"goblin": {
		"label": "Goblin",
		"classes": ["melee", "range"],
	},
}

const CLASS_LABELS := {
	"warrior": "Warrior",
	"ranger": "Ranger",
	"melee": "Melee",
	"range": "Range",
}


static func get_race_label(race_id: String) -> String:
	if not RACES.has(race_id):
		return race_id
	return str(RACES[race_id].get("label", race_id))


static func get_class_ids_for_race(race_id: String) -> Array:
	if not RACES.has(race_id):
		return []
	return RACES[race_id].get("classes", [])


static func get_class_label(class_id: String) -> String:
	return str(CLASS_LABELS.get(class_id, class_id))
