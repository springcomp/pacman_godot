extends Sprite2D

const EYES_ATLAS: AtlasTexture = preload("res://resources/eyes_atlas.tres")

var eyes_offset_look_at = {
	LEFT = 0,
	RIGHT = 1,
	UP = 2,
	DOWN = 3,
}

var textures: Array[Texture]

func _ready() -> void:
	var atlas = EYES_ATLAS
	
	textures = [
		_extract_image_texture_from_region(atlas, Rect2(00, 0, 32, 32)),
		_extract_image_texture_from_region(atlas, Rect2(32, 0, 32, 32)),
		_extract_image_texture_from_region(atlas, Rect2(64, 0, 32, 32)),
		_extract_image_texture_from_region(atlas, Rect2(96, 0, 32, 32)),
	]

func _extract_image_texture_from_region(atlas: AtlasTexture, region: Rect2) -> ImageTexture:
	atlas.region = region
	var image = atlas.get_image()
	var image_texture = ImageTexture.create_from_image(image)
	return image_texture

func _on_ghost_on_direction_changed(direction: Vector2):
	var index = eyes_offset_look_at["LEFT"] 
	if direction == Vector2.RIGHT:
		index = eyes_offset_look_at["RIGHT"]
	elif direction == Vector2.UP:
		index = eyes_offset_look_at["UP"]
	elif direction == Vector2.DOWN:
		index = eyes_offset_look_at["DOWN"]

	self.texture = textures[index]
