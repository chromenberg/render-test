package renderer
import rl "vendor:raylib"
import "core:c"
import "core:fmt"
import "../hook"
import "../game/objects"

@private
FrameHooks :: struct {
  frame_start : ^hook.HookStore,
  pre_draw: ^hook.HookStore,
  scene: ^hook.HookStore,
  ui: ^hook.HookStore,
  shader: ^hook.HookStore,
  frame_end: ^hook.HookStore,
}

FRAME_HOOKS: FrameHooks

@private
frame_loop :: proc() {
  hook.run_hooks(FRAME_HOOKS.frame_start)

  rl.BeginDrawing()
  rl.ClearBackground(rl.WHITE)

  hook.run_hooks(FRAME_HOOKS.pre_draw)
  hook.run_hooks(FRAME_HOOKS.scene)
  hook.run_hooks(FRAME_HOOKS.shader)

  hook.run_hooks(FRAME_HOOKS.ui)
  rl.EndDrawing()

  hook.run_hooks(FRAME_HOOKS.frame_end)

  rl.PollInputEvents()
}

add_frame_start_hook :: proc(callback: hook.HookCallback, once: bool, name: Maybe(string)) {
  new_hook := hook.create_hook(callback, once, name)
  hook.add_hook(FRAME_HOOKS.frame_start, new_hook)
}

add_pre_draw_hook :: proc(callback: hook.HookCallback, once: bool, name: Maybe(string)) {
  new_hook := hook.create_hook(callback, once, name)
  hook.add_hook(FRAME_HOOKS.pre_draw, new_hook)
}

add_scene_hook :: proc(callback: hook.HookCallback, once: bool, name: Maybe(string)) {
  new_hook := hook.create_hook(callback, once, name)
  hook.add_hook(FRAME_HOOKS.scene, new_hook)
}

add_shader_hook :: proc(callback: hook.HookCallback, once: bool, name: Maybe(string)) {
  new_hook := hook.create_hook(callback, once, name)
  hook.add_hook(FRAME_HOOKS.shader, new_hook)
}

add_frame_end_hook :: proc(callback: hook.HookCallback, once: bool, name: Maybe(string)) {
  new_hook := hook.create_hook(callback, once, name)
  hook.add_hook(FRAME_HOOKS.frame_end, new_hook)
}

add_ui_hook :: proc(callback: hook.HookCallback, once: bool, name: Maybe(string)) {
  new_hook := hook.create_hook(callback, once, name)
  hook.add_hook(FRAME_HOOKS.ui, new_hook)
}

init_camera2d :: proc(position: objects.Vector2) -> ^rl.Camera2D{
  camera2d := new(rl.Camera2D)

  camera2d.target = position
  camera2d.offset = {640/2,480/2} // Create camera with no offset
  camera2d.zoom = 1.0
  camera2d.rotation = 0.0

  return camera2d
}

destroy_camera2d :: proc(camera: ^rl.Camera2D) {
  free(camera)
}

render_3d :: proc(camera: ^rl.Camera3D, callback: proc()) {
  rl.BeginMode3D(camera^)
    callback()
  rl.EndMode3D()
}
render_2d :: proc(camera: ^rl.Camera2D, callback: proc()) {
  rl.BeginMode2D(camera^)
    callback()
  rl.EndMode3D()
}

render_scene_contents :: proc(tree: ^objects.GameHierarchy) {
  fmt.println("rendering contents", tree)
  for object in tree.root {
    switch v in object {
      case ^objects.CubeObject: {
        fmt.println("CubeObject")
        rl.DrawCube(v.position, v.size.x, v.size.y, v.size.z, auto_cast v.color)
      }
      case ^objects.PlaneObject: {
        fmt.println("PlaneObject")

      }
      case ^objects.GameObject: {
        fmt.println("GameObject")

      }
      case ^objects.RectObject: {
        fmt.println("RectObject")
        rl.DrawRectangleV(v.position.xy, v.size, auto_cast v.color)
      }
      case ^objects.CircleObject: {
        fmt.println("CircleObject")
      }
      case ^objects.TextObject: {
        fmt.println("TextObject")
      }
    }
  }
}

start_render_loop :: proc() {
  for !rl.WindowShouldClose() {
    frame_loop()
  }
}

init_hooks :: proc() {
  FRAME_HOOKS = {
    frame_start = hook.create_hook_store(),
    pre_draw = hook.create_hook_store(),
    scene = hook.create_hook_store(),
    ui = hook.create_hook_store(),
    shader = hook.create_hook_store(),
    frame_end = hook.create_hook_store(),
  }
}

init_renderer :: proc(width, height: i32, name: cstring) {

  rl.InitWindow(width, height, name)
  defer rl.CloseWindow()

  start_render_loop()
}
