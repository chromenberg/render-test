package main
import "renderer"
import "core:thread"
import "core:fmt"
import "hook"

temp :: proc(args: ..any) {
  fmt.println(args[0])
}

main :: proc() {
 thread.Thread{}
  renderer.init_renderer(640, 480, "shite")
}