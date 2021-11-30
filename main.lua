local function read_ini(filename, t)
    t = t or {}
    local section
    for l in io.lines(filename) do
        if l:match "^%s*$" then
        elseif l:match "^%[.+%]$" then
            local name = l:sub(2,-2)
            section = {}
            t[#t+1] = {name, section}
        elseif l:match "=" then
            if not section then
                section = {}
                t[#t+1] = {"", section}
            end
            local k,v = l:match "^([^=]*)=(.*)$"
            section[#section+1] = {k,v}
        else
            error("invalid format"..l)
        end
    end
    return t
end

local function write_ini(filename, t)
    local s = {}
    local function write(kv)
        s[#s+1] = kv[1].."="..kv[2]
    end
    for _, ns in ipairs(t) do
        if ns[1] ~= "" then
            s[#s+1] = "["..ns[1].."]"
        end
        for _, kv in ipairs(ns[2]) do
            write(kv)
        end
        s[#s+1] = ""
    end
    local f <close> = assert(io.open(filename, "wb"))
    f:write(table.concat(s, "\n"))
end

local function normalize(t)
    local r = {}
    for _, ns in ipairs(t) do
        local section = {}
        r[ns[1]] = section
        for _, kv in ipairs(ns[2]) do
            section[kv[1]] = kv[2]
        end
    end
    return r
end

local function translation(t, loc)
    for _, ns in ipairs(t) do
        local n, s = ns[1], ns[2]
        local loc_s = loc[n]
        if loc_s then
            for _, kv in ipairs(s) do
                local k, v = kv[1], kv[2]
                local loc_v = loc_s[k]
                if loc_v then
                    kv[2] = loc_v
                else
                    print("Missing ".. k)
                end
            end
        end
    end
end


local cn = {}
for _, name in ipairs {"entity", "fluid", "informatron", "item", "misc", "recipe", "tech"} do
    read_ini("locale/zh-CN/"..name..".cfg", cn)
end
cn = normalize(cn)

for _, name in ipairs {"entity", "fluid", "informatron", "item", "misc", "recipe", "tech"} do
    local t = read_ini("nullius-en/"..name..".cfg")
    translation(t, cn)
    write_ini("locale/zh-CN/"..name..".cfg", t)
end

print "ok"
