-- Running LSP work (rust-analyzer's indexing, cargo check, ...), by client
-- and progress token, for the status line. A task is dropped at its `end`,
-- and a stopped client's tasks are skipped.

local M = {}

-- client id -> progress token -> { title, message, percentage, updated }
local tasks_by_client = {}

vim.api.nvim_create_autocmd('LspProgress', {
    group = vim.api.nvim_create_augroup('my.lsp.progress', {}),
    callback = function(ev)
        local params = ev.data.params
        local value = params.value
        if type(value) ~= 'table' then return end
        local tasks = tasks_by_client[ev.data.client_id] or {}
        tasks_by_client[ev.data.client_id] = tasks
        if value.kind == 'end' then
            tasks[params.token] = nil
        else
            -- A report without a message or percentage keeps the last one.
            local task = tasks[params.token] or {}
            tasks[params.token] = {
                title = value.title,
                message = value.message or task.message,
                percentage = value.percentage or task.percentage,
                updated = vim.uv.hrtime(),
            }
        end
        vim.cmd.redrawstatus()
    end,
})

-- The most recently updated task of a running client, or nil.
function M.latest()
    local latest
    for client_id, tasks in pairs(tasks_by_client) do
        if vim.lsp.get_client_by_id(client_id) then
            for _, task in pairs(tasks) do
                if not latest or task.updated > latest.updated then
                    latest = task
                end
            end
        end
    end
    return latest
end

return M
