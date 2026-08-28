package main
import "renderer"
import rl "vendor:raylib"
import "core:fmt"
import "game/objects"

temp :: proc(args: ..any) {
  fmt.println(args[0])
}

temponce :: proc(args: ..any) {
  fmt.println("TempOnceHook")
}

// temporarily store the camera here so anonymous procedures can use it
camera : ^rl.Camera2D

init_game :: proc(width, height: i32, name: cstring) {
  // Create the game tree.
  // This stores every object that is created within the game
  objects.init_game_tree()
  defer objects.destroy_game_tree()

  player := objects.create_object(objects.RectObject)
  defer objects.destroy_object(player)

  player.name = "Player"
  player.position = {60, 0, 70}
  player.size = {40, 40}
  player.color = {255, 70, 255, 255}

  player2 := objects.create_object(objects.RectObject)
  defer objects.destroy_object(player2)

  player2.name = "Player"
  player2.position = {20, 0, 10}
  player2.size = {40, 40}
  player2.color = {70, 255, 255, 255}
  // Create the camera
  camera = renderer.init_camera2d(player.position.xy)
  defer renderer.destroy_camera2d(camera)

  renderer.init_hooks()
  renderer.add_pre_draw_hook(temponce, true, "TempOnceHook")

  renderer.add_scene_hook(proc(args: ..any) {           // Adds a hook to run every time the screen is updated
    renderer.render_2d(camera, proc() {                 // enter 2d render mode with the camera
      renderer.render_scene_contents(objects.game_tree) // render everything in the scene
    })
  }, false, "Scene")

  renderer.add_ui_hook(proc(args: ..any) {
    rl.DrawFPS(0, 0)
  }, false, "Text")

  renderer.add_frame_start_hook(proc(args: ..any) {
    
  })
  
  renderer.init_renderer(640, 480, "shite")
}
