package = "threadmanager"
version = "dev-1"
source = {
	url = "git+https://github.com/thenumbernine/lua-threadmanager"
}
description = {
	summary = "thread manager",
	homepage = "https://github.com/thenumbernine/lua-threadmanager",
	license = "MIT"
}
dependencies = {
	"lua >= 5.1"
}
build = {
	type = "builtin",
	modules = {
		["threadmanager"] = "threadmanager.lua"
	}
}
