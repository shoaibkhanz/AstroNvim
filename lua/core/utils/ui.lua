--- ### AstroNvim UI Options
--
-- This module is automatically loaded by AstroNvim on during it's initialization into global variable `astronvim.ui`
--
-- This module can also be manually loaded with `local updater = require("core.utils").ui`
--
-- @module core.utils.ui
-- @see core.utils
-- @copyright 2022
-- @license GNU General Public License v3.0

astronvim.ui = {}

local bool2str = function(bool) return bool and "on" or "off" end

--- Toggle autopairs
function astronvim.ui.toggle_autopairs()
  local ok, autopairs = pcall(require, "nvim-autopairs")
  if ok then
    if autopairs.state.disabled then
      autopairs.enable()
    else
      autopairs.disable()
    end
    vim.g.autopairs_enabled = autopairs.state.disabled
    astronvim.notify(string.format("autopairs %s", bool2str(not autopairs.state.disabled)))
  else
    astronvim.notify "autopairs not available"
  end
end

--- Toggle diagnostics
function astronvim.ui.toggle_diagnostics()
  local status = "on"
  if vim.g.status_diagnostics_enabled then
    if vim.g.diagnostics_enabled then
      vim.g.diagnostics_enabled = false
      status = "virtual text off"
    else
      vim.g.status_diagnostics_enabled = false
      status = "fully off"
    end
  else
    vim.g.diagnostics_enabled = true
    vim.g.status_diagnostics_enabled = true
  end

  vim.diagnostic.config(astronvim.lsp.diagnostics[bool2str(vim.g.diagnostics_enabled)])
  astronvim.notify(string.format("diagnostics %s", status))
end

--- Toggle background="dark"|"light"
function astronvim.ui.toggle_background()
  vim.go.background = vim.go.background == "light" and "dark" or "light"
  astronvim.notify(string.format("background=%s", vim.go.background))
end

--- Toggle cmp entrirely
function astronvim.ui.toggle_cmp()
  vim.g.cmp_enabled = not vim.g.cmp_enabled
  local ok, _ = pcall(require, "cmp")
  astronvim.notify(ok and string.format("completion %s", bool2str(vim.g.cmp_enabled)) or "completion not available")
end

--- Toggle signcolumn="auto"|"no"
function astronvim.ui.toggle_signcolumn()
  if vim.wo.signcolumn == "no" then
    vim.wo.signcolumn = "yes"
  elseif vim.wo.signcolumn == "yes" then
    vim.wo.signcolumn = "auto"
  else
    vim.wo.signcolumn = "no"
  end
  astronvim.notify(string.format("signcolumn=%s", vim.wo.signcolumn))
end

--- Set the indent and tab related numbers
function astronvim.ui.set_indent()
  local indent = tonumber(vim.fn.input "Set indent value (>0 expandtab, <=0 noexpandtab): ")
  if not indent or indent == 0 then return end
  vim.bo.expandtab = (indent > 0) -- local to buffer
  indent = math.abs(indent)
  vim.bo.tabstop = indent -- local to buffer
  vim.bo.softtabstop = indent -- local to buffer
  vim.bo.shiftwidth = indent -- local to buffer
  astronvim.notify(string.format("indent=%d %s", indent, vim.bo.expandtab and "expandtab" or "noexpandtab"))
end

--- Change the number display modes
function astronvim.ui.change_number()
  local number = vim.wo.number -- local to window
  local relativenumber = vim.wo.relativenumber -- local to window
  if not number and not relativenumber then
    vim.wo.number = true
  elseif number and not relativenumber then
    vim.wo.relativenumber = true
  elseif number and relativenumber then
    vim.wo.number = false
  else -- not number and relativenumber
    vim.wo.relativenumber = false
  end
  astronvim.notify(
    string.format("number=%s, relativenumber=%s", bool2str(vim.wo.number), bool2str(vim.wo.relativenumber))
  )
end

--- Toggle spell
function astronvim.ui.toggle_spell()
  vim.wo.spell = not vim.wo.spell -- local to window
  astronvim.notify(string.format("spell=%s", bool2str(vim.wo.spell)))
end

--- Toggle wrap
function astronvim.ui.toggle_wrap()
  vim.wo.wrap = not vim.wo.wrap -- local to window
  astronvim.notify(string.format("wrap=%s", bool2str(vim.wo.wrap)))
end

--- Toggle syntax highlighting and treesitter
function astronvim.ui.toggle_syntax()
  local ts_avail, parsers = pcall(require, "nvim-treesitter.parsers")
  if vim.g.syntax_on then -- global var for on//off
    if ts_avail and parsers.has_parser() then vim.cmd.TSBufDisable "highlight" end
    vim.cmd.syntax "off" -- set vim.g.syntax_on = false
  else
    if ts_avail and parsers.has_parser() then vim.cmd.TSBufEnable "highlight" end
    vim.cmd.syntax "on" -- set vim.g.syntax_on = true
  end
  astronvim.notify(string.format("syntax %s", bool2str(vim.g.syntax_on)))
end

--- Toggle URL/URI syntax highlighting rules
function astronvim.ui.toggle_url_match()
  vim.g.highlighturl_enabled = not vim.g.highlighturl_enabled
  astronvim.set_url_match()
end
