package game
import "renderer"

init_game :: proc(width, height: i32, name: cstring) {
  renderer.init_renderer(width, height, name)
}