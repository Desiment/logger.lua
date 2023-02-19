log = dofile('../logger.lua')

log.trace("Trace message")
log.debug("Debug message")
log.info("Info message")
log.success("OK message")
log.warning("Warn message")
log.error("Error message")
log.fatal("Fatal message")

demo_tbl = {x = 3, y = "fff", [13] = function(x) return x end}
print(log.dump(demo_tbl))
