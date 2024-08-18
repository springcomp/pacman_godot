extends CanvasLayer

@onready var panel: Panel = $MarginContainer/CenterContainer/Panel
@onready var game_over_label: Label = $MarginContainer/CenterContainer/Panel/GameOverLabel

func _on_pellets_on_game_won() -> void:
	game_over_label.text = "You won!"
	game_over_label.add_theme_color_override("font_color", Color.CHARTREUSE)

	panel.visible = true
