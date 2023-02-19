# logger.lua
A tiny logging module for Lua. 

## Installation
The [logger.lua](log.lua?raw=1) file should be dropped into an existing project
and required by it.
```lua
log = require "logger"
``` 


## Basic usage
Basically, log.lua provides 7 modes: ``trace``, ``debug``, ``info``, ``success``, ``warning``, ``error``, ``fatal``. Each mode represnted 
by function which takes all its arguments, concatenates them into a string and then writes them with some additional info into the log. 

Small example of this:
```
> log.trace("Trace message")
[TRACE   03:39:53] demo_1.lua:3:  Trace message
```

Also, there is method for converting tables (possibly nested) into string: ``log.dump(table)``. 

Finally, there  for automatic registration of function calls. See tests for example.

