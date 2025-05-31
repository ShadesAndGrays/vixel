package sprite_system

import "core:fmt"
import rl "vendor:raylib"

Sprite :: struct {
	// A sprite in the sprite system.
	// It contains a texture and its position, size, and other properties.
	texture:  rl.Texture2D, // The texture of the sprite.
	position: rl.Vector2, // The position of the sprite in the world.
	size:     rl.Vector2, // The size of the sprite.
	scale:    rl.Vector2,
	rotation: f32, // The rotation of the sprite in degrees.
	color:    rl.Color, // The color of the sprite.
	visible:  bool, // Whether the sprite is visible or not.   
}
Layer :: struct {
	// A layer in the sprite system.
	// Each layer contains a list of sprites.
	sprites: [dynamic]Sprite,
}

SpriteSystem :: struct {
  working_layer_id:i32, // The current wokring layer
	next_layer_id: i32, // The newest created layer id
	exisiting_layers: [dynamic]i32, // list of all layer id
	layer_order:      [dynamic]i32, // Order of all layers
	layers:           map[i32]Layer, // Content of layers mapped by id
}

create_layer :: proc(system: ^SpriteSystem) {
  system.working_layer_id = system.next_layer_id

  append(&system.exisiting_layers, system.next_layer_id)
  append(&system.layer_order, system.next_layer_id)

	system.layers[system.working_layer_id ] = Layer {
		sprites = [dynamic]Sprite{},
	}
  system.next_layer_id += 1
}

create_sprite :: proc(
	system: ^SpriteSystem,
	texture: rl.Texture2D,
	position: rl.Vector2,
	size: rl.Vector2,
	rotation: f32,
	color: rl.Color,
) -> Sprite {
	// Create a new sprite with the given properties and add it to the first layer.
	if system.layers[system.working_layer_id].sprites == nil {
    create_layer(system);
	}
	new_sprite := Sprite {
		texture  = texture,
		position = position,
		size     = size,
		scale = size,
		rotation = rotation,
		color    = color,
		visible  = true,
	}

	layer := system.layers[system.next_layer_id]
	sprites := layer.sprites
	append(&sprites, new_sprite)
	layer.sprites = sprites
	system.layers[system.working_layer_id] = layer
	return new_sprite

}

render_sprite :: proc(sprite: Sprite) {
	rl.DrawTexturePro(
	sprite.texture,
	 rl.Rectangle{x=0,y=0,width=sprite.size.x,height=sprite.size.y},
	 rl.Rectangle{x=0,y=0,width=(sprite.size.x * sprite.scale.x ),height=(sprite.size.y * sprite.scale.y)},
	 rl.Vector2{0.5,0.5},sprite.rotation,sprite.color
	)
}

render_all :: proc(system: ^SpriteSystem){
	for i in system.layer_order{
		for &sprite in system.layers[i].sprites{
			render_sprite(sprite)
		}
	}
}