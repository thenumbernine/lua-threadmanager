## Simple thread manager for Lua.

[![Donate via Stripe](https://img.shields.io/badge/Donate-Stripe-green.svg)](https://buy.stripe.com/00gbJZ0OdcNs9zi288)<br>

# Example usage:

Initialization:
``` lua
t = ThreadManager()
```

Update loop:
``` lua
t:update()
```

Adding a coroutine:
``` lua
t:add(print, 'hi')
```

Adding a function to execute on the main thread:
``` lua
t:addMainLoopCall(print, 'hi')
```

### Dependencies:

- [lua-ext](https://github.com/thenumbernine/lua-ext)
