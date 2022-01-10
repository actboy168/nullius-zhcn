local version = (function()
    for line in io.lines('info.json') do
        local ver = line:match('"version": "(%d+%.%d+%.%d+)"')
        if ver then
            return ver
        end
    end
    error 'Cannot found version in info.json.'
end)()

local archive_name = ("nullius_%s.zip"):format(version)

os.remove(archive_name)

local args = {
    "7z", "-y", "a",
    archive_name,
    "locale",
    "changelog.txt",
    "info.json",
    "LICENSE",
    "README.md"
}
local command = table.concat(args, " ")
print(command)
os.execute(command)
