require("mason").setup()
require("mason-nvim-dap").setup({
	-- automatic_setup = true,
	ensure_installed = { "python", "delve", "cppdbg" },
	handlers = {
		function(config)
			-- all sources with no handler get passed here

			-- Keep original functionality
			require("mason-nvim-dap").default_setup(config)
		end,
		python = function(config)
			config.adapters = {
				type = "executable",
				command = "/usr/bin/python3",
				args = {
					"-m",
					"debugpy.adapter",
				},
			}
			require("mason-nvim-dap").default_setup(config) -- don't forget this!
		end,
		cppdbg = function(config)
			config.adapters = {
				name = "Launch",
				type = "lldb",
				request = "launch",
				program = function()
					return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
				end,
				cwd = "${workspaceFolder}",
				stopOnEntry = false,
				args = {},
				runInTerminal = true,
			}
			require("mason-nvim-dap").default_setup(config) -- don't forget this!
		end,
	},
})

require("dapui").setup()

require("nvim-dap-virtual-text").setup()

vim.keymap.set("n", "<leader>deb", function()
	require("dap").continue()
end)
vim.keymap.set("n", "<C-n>", function()
	require("dap").step_over()
end)
vim.keymap.set("n", "<F11>", function()
	require("dap").step_into()
end)
vim.keymap.set("n", "<C-e>", function()
	require("dap").step_out()
end)
vim.keymap.set("n", "<Leader>b", function()
	require("dap").toggle_breakpoint()
end)
vim.keymap.set("n", "<Leader>B", function()
	require("dap").set_breakpoint((vim.fn.input("Breakpoint condition: ")))
end)
vim.keymap.set("n", "<Leader>lp", function()
	require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
end)
vim.keymap.set("n", "<Leader>dr", function()
	require("dap").repl.open()
end)
-- vim.keymap.set("n", "<Leader>dl", function()
-- 	require("dap").run_last()
-- end)
vim.keymap.set({ "n", "v" }, "<Leader>dh", function()
	require("dap.ui.widgets").hover()
end)
-- vim.keymap.set({ "n", "v" }, "<Leader>dp", function()
-- 	require("dap.ui.widgets").preview()
-- end)
vim.keymap.set("n", "<Leader>df", function()
	local widgets = require("dap.ui.widgets")
	widgets.centered_float(widgets.frames)
end)
vim.keymap.set("n", "<Leader>ds", function()
	local widgets = require("dap.ui.widgets")
	widgets.centered_float(widgets.scopes)
end)

vim.keymap.set("n", "<Leader>do", function()
	require("dapui").toggle()
end)

local dap, dapui = require("dap"), require("dapui")
dap.listeners.before["event_terminated"]["dapui_config"] = function()
	local comand = "W.open()"
	vim.api.nvim_command(":lua " .. comand)
end
dap.listeners.after["event_initialized"]["dapui_config"] = function()
	dapui.open()
end
dap.listeners.before["event_exited"]["dapui_config"] = function()
	local comand = "W.open()"
	vim.api.nvim_command(":lua " .. comand)
end
vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapLogPoint", { text = "", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointRejected", { text = "󰱬", texthl = "", linehl = "", numhl = "" })
