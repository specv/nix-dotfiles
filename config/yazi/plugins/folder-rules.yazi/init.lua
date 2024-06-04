-- Folder-local options
-- https://github.com/sxyazi/yazi/issues/623

function expanduser(path)
    if string.sub(path, 1, 1) == '~' then
        local home = os.getenv('HOME')
        return home .. string.sub(path, 2)
    else
        return path
    end
end


return {
    setup = function(_state, opts)
        ps.sub("cd", function()
            local current_dir = tostring(cx.active.current.cwd)
            for _, match_dir in ipairs(opts.folders) do
                if current_dir == expanduser(match_dir) then
                    ya.manager_emit("sort", { "modified", reverse = true, dir_first = false })
                    break
                end
            end
        end)
    end,
}
