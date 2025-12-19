-- set what gets logged serverside
-- 0 - quiet mode
-- 1 - errors
-- 2 - warnings
-- 3 - info

VERBOSE_LVL = 3

function dprint (txt, lvl)
    if lvl >= VERBOSE_LVL then
        print (txt)
    end
end
