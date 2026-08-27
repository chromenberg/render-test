package renderer
import rl "vendor:raylib"
import "../hook"

@private
FrameHooks :: struct {
  frame_start : ^hook.HookStore,
  pre_draw: ^hook.HookStore,
  draw: ^hook.HookStore,
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
  hook.run_hooks(FRAME_HOOKS.draw)
  hook.run_hooks(FRAME_HOOKS.shader)

  rl.EndDrawing()

  hook.run_hooks(FRAME_HOOKS.frame_end)
  rl.SwapScreenBuffer()
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

add_draw_hook :: proc(callback: hook.HookCallback, once: bool, name: Maybe(string)) {
  new_hook := hook.create_hook(callback, once, name)
  hook.add_hook(FRAME_HOOKS.draw, new_hook)
}

add_shader_hook :: proc(callback: hook.HookCallback, once: bool, name: Maybe(string)) {
  new_hook := hook.create_hook(callback, once, name)
  hook.add_hook(FRAME_HOOKS.shader, new_hook)
}

add_frame_end_hook :: proc(callback: hook.HookCallback, once: bool, name: Maybe(string)) {
  new_hook := hook.create_hook(callback, once, name)
  hook.add_hook(FRAME_HOOKS.frame_end, new_hook)
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
    draw = hook.create_hook_store(),
    shader = hook.create_hook_store(),
    frame_end = hook.create_hook_store(),
  }
}

init_renderer :: proc(width, height: i32, name: cstring) {

  rl.InitWindow(width, height, name)
  defer rl.CloseWindow()

  start_render_loop()
}
