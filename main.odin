package main

import ss "sprite_system"

import "core:fmt"
import rl "vendor:raylib"


main :: proc() {
    // This is a simple program that prints "Hello, World!" to the console.

    fmt.println("Hello, World!");
    using rl;
    rl.InitWindow(800, 450, "Hello World");
    rl.SetTargetFPS(60); // Set our game to run at 60 frames-per-second   

    player_texture := rl.LoadTexture("assets/vampire.png");


    sprite_sys : ss.SpriteSystem = ss.SpriteSystem{};
    ss.create_sprite(&sprite_sys,player_texture,Vector2(0),Vector2{16,16},0,RAYWHITE);

    fmt.println(sprite_sys)
    for !rl.WindowShouldClose() { // Detect window close button or ESC key
        rl.BeginDrawing();
        rl.ClearBackground(rl.RAYWHITE);
        rl.DrawText("Hello World!", 190, 200, 20, rl.DARKGRAY);
        ss.render_all(&sprite_sys)
        rl.EndDrawing();
    }

}