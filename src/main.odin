package main
import "renderer"
import "core:fmt"
import "hook"

temp :: proc(args: ..any) {
  fmt.println(args[0])
}

main :: proc() {
  store := hook.create_hook_store()

  hook1 := hook.create_hook(temp, false, hook.NO_NAME)
  hook2 := hook.create_hook(temp, false, hook.NO_NAME)
  hook3 := hook.create_hook(temp, false, hook.NO_NAME)
  hook4 := hook.create_hook(temp, false, hook.NO_NAME)

  hook.add_hook(store, hook1)
  hook.add_hook(store, hook2)
  hook.add_hook(store, hook3)
  hook.add_hook(store, hook4)
  
  hook.run_hooks(store, "hello, this is a message")
  
  renderer.init_renderer(640, 480, "shite")
}