local version = (function()
    for line in io.lines('info.json') do
        local ver = line:match('"version": "(%d+%.%d+%.%d+)"')
        if ver then
            return ver
        end
    end
    error 'Cannot found version in info.json.'
end)()

local function copyfile(from, to)
    os.execute(("powershell -NonInteractive -Command Copy-Item -Path %s -Destination %s -Recurse"):format(from, to))
end

local filelist = {
    "locale",
    "changelog.txt",
    "info.json",
    "LICENSE",
    "README.md",
}

local name = ("nullius-zhcn_%s"):format(version)

for _, file in ipairs(filelist) do
    copyfile(file, name.."/"..file)
end

local archive_name = name..".zip"

os.remove(archive_name)

local args = {
    "7z", "a",
    "-y", "-sdel",
    archive_name,
    name,
}
local command = table.concat(args, " ")
print(command)
os.execute(command)
