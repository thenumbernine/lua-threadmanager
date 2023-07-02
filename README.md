## Simple thread manager for Lua.

[![Donate via Stripe](https://img.shields.io/badge/Donate-Stripe-green.svg)](https://buy.stripe.com/00gbJZ0OdcNs9zi288)<br>
[![Donate via Bitcoin](https://img.shields.io/badge/Donate-Bitcoin-green.svg)](bitcoin:37fsp7qQKU8XoHZGRQvVzQVP8FrEJ73cSJ)<br>

# Example usage:

Initialization:
```
t = ThreadManager()
```

Update loop:
```
t:update()
```

Adding a coroutine:
```
t:add(print, 'hi')
```

Adding a function to execute on the main thread:
```
t:addMainLoopCall(print, 'hi')
```

### Dependencies:

- [lua-ext](https://github.com/thenumbernine/lua-ext)
