package main
import "renderer"
import "core:fmt"
import "hook"

temp :: proc(args: ..any) {
  fmt.println(args[0])
}

main :: proc() {
  renderer.init_hooks()
  
  renderer.add_pre_draw_hook()
  renderer.init_renderer(640, 480, "shite")
}