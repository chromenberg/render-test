package renderer
import rl "vendor:raylib"

start_render_loop :: proc() {
  for !rl.WindowShouldClose() {
    
  }
}

init_renderer :: proc(width, height: i32, name: cstring) {
  rl.InitWindow(width, height, name)
  start_render_loop()
  
  defer rl.CloseWindow()
}