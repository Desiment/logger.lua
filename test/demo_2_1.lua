log = dofile('../logger.lua')

log.info("This test shows how to detect function calls with logger")

--- First method: manual ---
local foo = function(x, y)
	log.debug("Method foo was called; Args:", x, y)
	return
end

foo(2, 3)

--- Second method: register function call automatically ---
-- This creates other function which calls "base" function and dumps arguments
-- But this method points to place where function called, not defined

bar1 = function(x, y)
	return x + y
end

bar2 = log.call.debug(bar1)

bar1(2, 3)
bar2(4, 5)


meow1 = dofile('demo_2_2.lua')
meow2 = log.call.debug(meow1)

meow1()
meow2()
