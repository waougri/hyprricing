-- =============================================================================
-- gentoo.nvim  –  v3 "Complete Edition"
-- A production-grade dark colorscheme rooted in the Gentoo Linux brand palette.
--
-- Design contract (every rule is intentional, not accidental):
--
--   PURPLE  → language structure: keywords, control-flow, function names
--   BLUE    → types, shapes, modules, namespaces, constructors
--   GREEN   → string data  (Gentoo brand green — instantly iconic)
--   ORANGE  → literal values: numbers, booleans, @variable.builtin
--   CYAN    → operators, constants, builtins, escapes, struct members
--   YELLOW  → labels, warnings, diff-change  (warning cadence)
--   RED     → errors, exceptions, deletion    (error cadence)
--   MAGENTA → decorators, special constructs, regex, symbols, lifetimes
--   PU5     → variables (faint Gentoo near-white, distinct from plain text)
--
--   italic  → passive / contextual  (comments, parameters, modifiers)
--   bold    → declaration / emphasis (headings, selected items)
--
-- Official Gentoo brand colors:
--   #54487A  #61538D  #6E56AF  #DDDAEC  #DDDFFF  #73D216  #D9534F
--
-- Coverage:
--   • Core editor UI (every group)
--   • Traditional :syntax groups
--   • Treesitter  – all standard + extended captures
--   • LSP semantic tokens + all diagnostic variants
--   • Language-specific: C, C++, Rust, Python, Java, C#, JS/TS/JSX/TSX,
--     Kotlin, Lua, CMake, TOML, JSON, INI/conf, YAML, Bash, SQL, Markdown
--   • Diff / Git / spelling
--   • Terminal (all 16 colors)
--   • Plugins: nvim-tree, neo-tree, telescope, fzf-lua, nvim-cmp, blink.cmp,
--     gitsigns, indent-blankline, lualine, trouble, which-key, mason,
--     dashboard, alpha, noice, nvim-notify, nvim-dap + dap-ui, lazy.nvim,
--     oil.nvim, flash.nvim, mini.nvim suite
-- =============================================================================

if vim.g.colors_name then
	vim.cmd("hi clear")
end
if vim.fn.exists("syntax_on") == 1 then
	vim.cmd("syntax reset")
end

vim.o.background = "dark"
vim.o.termguicolors = true
vim.g.colors_name = "gentoo"

-- =============================================================================
-- PALETTE
-- =============================================================================
local c = {
	-- ── Backgrounds (ascending luminosity, all carry a purple undertone) ───────
	bg_hard = "#09091A", -- hardest variant (transparent-bg fallback)
	bg0 = "#0E0E1E", -- main editor background
	bg1 = "#161626", -- statusline / inactive panes / sidebar
	bg2 = "#1E1E32", -- cursorline / visual selection base
	bg3 = "#27273F", -- popup / menu background
	bg4 = "#30304C", -- active popup item / hover
	bg_float = "#141424", -- floating windows (slightly deeper than bg1)

	-- ── Foregrounds ────────────────────────────────────────────────────────────
	fg = "#DDDAEC", -- Gentoo brand grey — main text
	fg_hi = "#EDEAF8", -- slightly brighter for emphasis
	fg_dim = "#9893B0", -- secondary / inactive text
	fg_mute = "#57546A", -- barely visible (line-numbers, punctuation)

	-- ── Gentoo Purples ─────────────────────────────────────────────────────────
	pu0 = "#54487A", -- official Gentoo purple (bg accents, borders)
	pu1 = "#61538D", -- light purple  (borders, separators)
	pu2 = "#6E56AF", -- medium purple (indent scope, selection hi)
	pu3 = "#8C6FC1", -- bright purple (macros, preprocessor, @attribute)
	pu4 = "#B48BFF", -- primary accent (keywords, function names)
	pu5 = "#DDDFFF", -- Gentoo brand near-white (variable identifiers)

	-- ── Gentoo Green (strings — the data layer) ────────────────────────────────
	green = "#73D216", -- official Gentoo green
	green_l = "#90E83A", -- brighter (matching text highlights)
	green_bg = "#162510", -- diff-add background / tip background

	-- ── Type / shape layer ─────────────────────────────────────────────────────
	blue = "#7DC8FF", -- types, modules, constructors
	blue_d = "#4A8EC2", -- dimmer blue (inactive, secondary types)
	blue_bg = "#0D1E30", -- diff-change background / note background

	-- ── Operator / constant layer ──────────────────────────────────────────────
	cyan = "#4ECDC4", -- operators, constants, string escapes, struct members
	cyan_l = "#72E8E1", -- brighter cyan (builtin functions)

	-- ── Literal value layer ────────────────────────────────────────────────────
	orange = "#FF9E64", -- numbers, booleans, self/this
	orange_d = "#CC7940", -- dimmer orange
	orange_bg = "#251F0A", -- warning virtual text background

	-- ── Warning / label layer ──────────────────────────────────────────────────
	yellow = "#E8C97D", -- labels, diff-change fg, warnings

	-- ── Error / exception layer ────────────────────────────────────────────────
	red = "#D9534F", -- official Gentoo red
	red_l = "#F07070", -- brighter red (virtual text)
	red_bg = "#250D0D", -- diff-delete / error background

	-- ── Decorator / special layer ──────────────────────────────────────────────
	magenta = "#C47ED4", -- decorators, regex, special chars, lifetimes

	-- ── Structural ─────────────────────────────────────────────────────────────
	gray = "#4A4860",
	border = "#35334E",
	none = "NONE",
}

local function hl(group, opts)
	vim.api.nvim_set_hl(0, group, opts or {})
end

-- =============================================================================
-- CORE EDITOR UI
-- =============================================================================

hl("Normal", { fg = c.fg, bg = c.bg0 })
hl("NormalFloat", { fg = c.fg, bg = c.bg_float })
hl("NormalNC", { fg = c.fg_dim, bg = c.bg0 })
hl("FloatBorder", { fg = c.pu1, bg = c.bg_float })
hl("FloatTitle", { fg = c.pu4, bg = c.bg_float, bold = true })
hl("FloatFooter", { fg = c.fg_mute, bg = c.bg_float })

-- Cursor family
hl("Cursor", { fg = c.bg0, bg = c.pu4 })
hl("CursorIM", { fg = c.bg0, bg = c.cyan })
hl("TermCursor", { fg = c.bg0, bg = c.green })
hl("lCursor", { link = "Cursor" })

-- Lines
hl("CursorLine", { bg = c.bg2 })
hl("CursorColumn", { bg = c.bg2 })
hl("ColorColumn", { bg = c.bg2 })
hl("CursorLineNr", { fg = c.pu4, bold = true })
hl("LineNr", { fg = c.fg_mute })
hl("LineNrAbove", { fg = c.fg_mute })
hl("LineNrBelow", { fg = c.fg_mute })
hl("SignColumn", { fg = c.fg_mute, bg = c.bg0 })
hl("FoldColumn", { fg = c.gray, bg = c.bg0 })

-- Windows / splits
hl("VertSplit", { fg = c.border })
hl("WinSeparator", { fg = c.border })
hl("WinBar", { fg = c.fg_dim, bg = c.bg1, bold = true })
hl("WinBarNC", { fg = c.fg_mute, bg = c.bg0 })

-- Statusline
hl("StatusLine", { fg = c.fg, bg = c.bg1 })
hl("StatusLineNC", { fg = c.fg_mute, bg = c.bg0 })
hl("StatusLineTerm", { link = "StatusLine" })
hl("StatusLineTermNC", { link = "StatusLineNC" })

-- Tabs
hl("TabLine", { fg = c.fg_dim, bg = c.bg1 })
hl("TabLineFill", { bg = c.bg0 })
hl("TabLineSel", { fg = c.bg0, bg = c.pu4, bold = true })

-- Popup menu
hl("Pmenu", { fg = c.fg, bg = c.bg3 })
hl("PmenuSel", { fg = c.bg0, bg = c.pu4, bold = true })
hl("PmenuSbar", { bg = c.bg3 })
hl("PmenuThumb", { bg = c.pu1 })
hl("PmenuMatch", { fg = c.green, bold = true })
hl("PmenuMatchSel", { fg = c.green_l, bg = c.pu4, bold = true })
hl("PmenuKind", { fg = c.blue, bg = c.bg3 })
hl("PmenuKindSel", { fg = c.blue, bg = c.pu4 })
hl("PmenuExtra", { fg = c.fg_mute, bg = c.bg3 })
hl("PmenuExtraSel", { fg = c.fg_dim, bg = c.pu4 })
hl("WildMenu", { fg = c.bg0, bg = c.pu4, bold = true })

-- Titles and messages
hl("Title", { fg = c.pu4, bold = true })
hl("ModeMsg", { fg = c.green, bold = true })
hl("MsgArea", { fg = c.fg })
hl("MsgSeparator", { fg = c.border })
hl("MoreMsg", { fg = c.cyan })
hl("ErrorMsg", { fg = c.red, bold = true })
hl("WarningMsg", { fg = c.yellow, bold = true })
hl("Question", { fg = c.cyan })
hl("Directory", { fg = c.blue })

-- Selection
hl("Visual", { bg = c.bg4, fg = c.fg_hi })
hl("VisualNOS", { bg = c.bg4 })

-- Search
hl("Search", { fg = c.bg0, bg = c.yellow })
hl("IncSearch", { fg = c.bg0, bg = c.orange, bold = true })
hl("CurSearch", { link = "IncSearch" })
hl("Substitute", { fg = c.bg0, bg = c.red, bold = true })

-- Misc structural
hl("MatchParen", { fg = c.pu4, bold = true, underline = true })
hl("Folded", { fg = c.fg_dim, bg = c.bg2, italic = true })
hl("Conceal", { fg = c.pu3 })
hl("SpecialKey", { fg = c.gray })
hl("NonText", { fg = c.gray })
hl("Whitespace", { fg = c.bg4 })
hl("EndOfBuffer", { fg = c.bg1 })

-- Spelling
hl("SpellBad", { undercurl = true, sp = c.red })
hl("SpellCap", { undercurl = true, sp = c.yellow })
hl("SpellLocal", { undercurl = true, sp = c.cyan })
hl("SpellRare", { undercurl = true, sp = c.magenta })

-- Quickfix / location list
hl("QuickFixLine", { bg = c.bg2, bold = true })
hl("qfFileName", { fg = c.blue })
hl("qfLineNr", { fg = c.fg_mute })
hl("qfSeparator", { fg = c.border })

-- Health check
hl("healthSuccess", { fg = c.green, bold = true })
hl("healthWarning", { fg = c.yellow })
hl("healthError", { fg = c.red })

-- =============================================================================
-- TRADITIONAL SYNTAX GROUPS
-- =============================================================================

hl("Comment", { fg = c.fg_mute, italic = true })

hl("Constant", { fg = c.cyan })
hl("String", { fg = c.green })
hl("Character", { fg = c.green })
hl("Number", { fg = c.orange })
hl("Boolean", { fg = c.orange })
hl("Float", { fg = c.orange })

hl("Identifier", { fg = c.pu5 }) -- variables get the near-white tint
hl("Function", { fg = c.pu4 })

hl("Statement", { fg = c.pu4 })
hl("Conditional", { fg = c.pu4 })
hl("Repeat", { fg = c.pu4 })
hl("Label", { fg = c.yellow })
hl("Operator", { fg = c.cyan })
hl("Keyword", { fg = c.pu4 })
hl("Exception", { fg = c.red })

hl("PreProc", { fg = c.pu3 })
hl("Include", { fg = c.pu3 })
hl("Define", { fg = c.pu3 })
hl("Macro", { fg = c.pu3 })
hl("PreCondit", { fg = c.pu3 })

hl("Type", { fg = c.blue })
hl("StorageClass", { fg = c.pu3, italic = true })
hl("Structure", { fg = c.blue })
hl("Typedef", { fg = c.blue })

hl("Special", { fg = c.magenta })
hl("SpecialChar", { fg = c.magenta })
hl("Tag", { fg = c.pu4 })
hl("Delimiter", { fg = c.fg_mute })
hl("SpecialComment", { fg = c.fg_dim, italic = true })
hl("Debug", { fg = c.red })

hl("Underlined", { fg = c.blue, underline = true })
hl("Ignore", { fg = c.gray })
hl("Error", { fg = c.red, bold = true })
hl("Todo", { fg = c.bg0, bg = c.orange, bold = true })
hl("Note", { fg = c.bg0, bg = c.blue, bold = true })

-- =============================================================================
-- TREESITTER
-- =============================================================================

-- ── Literals ──────────────────────────────────────────────────────────────────
hl("@boolean", { fg = c.orange })
hl("@number", { fg = c.orange })
hl("@number.float", { fg = c.orange })
hl("@character", { fg = c.green })
hl("@character.special", { fg = c.magenta })
hl("@string", { fg = c.green })
hl("@string.documentation", { fg = c.green, italic = true })
hl("@string.escape", { fg = c.cyan })
hl("@string.regexp", { fg = c.magenta })
hl("@string.special", { fg = c.magenta })
hl("@string.special.symbol", { fg = c.magenta })
hl("@string.special.url", { fg = c.blue, underline = true })

-- ── Comments ──────────────────────────────────────────────────────────────────
hl("@comment", { fg = c.fg_mute, italic = true })
hl("@comment.documentation", { fg = c.fg_dim, italic = true })
hl("@comment.error", { fg = c.red, italic = true })
hl("@comment.warning", { fg = c.yellow, italic = true })
hl("@comment.todo", { fg = c.orange, bold = true, italic = true })
hl("@comment.note", { fg = c.cyan, bold = true, italic = true })

-- ── Variables ─────────────────────────────────────────────────────────────────
hl("@variable", { fg = c.pu5 }) -- near-white tint, distinct from plain text
hl("@variable.builtin", { fg = c.orange, italic = true }) -- self, this, super
hl("@variable.member", { fg = c.cyan }) -- .field access — THE fix
hl("@variable.parameter", { fg = c.fg_dim, italic = true })
hl("@variable.parameter.builtin", { fg = c.orange, italic = true })

-- ── Functions ─────────────────────────────────────────────────────────────────
hl("@function", { fg = c.pu4 })
hl("@function.builtin", { fg = c.cyan_l, italic = true })
hl("@function.call", { fg = c.pu4 })
hl("@function.macro", { fg = c.pu3 })
hl("@function.method", { fg = c.pu4 })
hl("@function.method.call", { fg = c.pu4 })

-- ── Keywords ──────────────────────────────────────────────────────────────────
hl("@keyword", { fg = c.pu4 })
hl("@keyword.conditional", { fg = c.pu4 })
hl("@keyword.conditional.ternary", { fg = c.cyan })
hl("@keyword.coroutine", { fg = c.pu4, italic = true })
hl("@keyword.debug", { fg = c.red })
hl("@keyword.directive", { fg = c.pu3 })
hl("@keyword.directive.define", { fg = c.pu3 })
hl("@keyword.exception", { fg = c.red })
hl("@keyword.function", { fg = c.pu4 })
hl("@keyword.import", { fg = c.pu3 })
hl("@keyword.modifier", { fg = c.pu3, italic = true })
hl("@keyword.operator", { fg = c.cyan })
hl("@keyword.repeat", { fg = c.pu4 })
hl("@keyword.return", { fg = c.pu4, italic = true })
hl("@keyword.storage", { fg = c.pu3, italic = true })
hl("@keyword.type", { fg = c.pu4 })

-- ── Types ─────────────────────────────────────────────────────────────────────
hl("@type", { fg = c.blue })
hl("@type.builtin", { fg = c.blue, italic = true })
hl("@type.definition", { fg = c.blue })
hl("@type.qualifier", { fg = c.pu3, italic = true })
hl("@constructor", { fg = c.blue })

-- ── Modules / namespaces ──────────────────────────────────────────────────────
hl("@module", { fg = c.blue_d })
hl("@module.builtin", { fg = c.blue_d, italic = true })
hl("@namespace", { link = "@module" })

-- ── Constants ─────────────────────────────────────────────────────────────────
hl("@constant", { fg = c.cyan })
hl("@constant.builtin", { fg = c.cyan, italic = true })
hl("@constant.macro", { fg = c.pu3 })

-- ── Labels, operators, punctuation ────────────────────────────────────────────
hl("@label", { fg = c.yellow })
hl("@operator", { fg = c.cyan })
hl("@punctuation.bracket", { fg = c.fg_dim })
hl("@punctuation.delimiter", { fg = c.fg_mute })
hl("@punctuation.special", { fg = c.magenta })

-- ── Properties / attributes ───────────────────────────────────────────────────
hl("@property", { fg = c.cyan }) -- THE fix: was c.fg
hl("@attribute", { fg = c.pu3 })
hl("@attribute.builtin", { fg = c.pu3, italic = true })
hl("@conceal", { fg = c.pu3 })

-- ── Tags (HTML/JSX/XML) ───────────────────────────────────────────────────────
hl("@tag", { fg = c.pu4 })
hl("@tag.attribute", { fg = c.blue })
hl("@tag.builtin", { fg = c.pu4, italic = true })
hl("@tag.delimiter", { fg = c.fg_mute })

-- ── Markup ────────────────────────────────────────────────────────────────────
hl("@markup.heading", { fg = c.pu4, bold = true })
hl("@markup.heading.1", { fg = c.pu4, bold = true })
hl("@markup.heading.2", { fg = c.blue, bold = true })
hl("@markup.heading.3", { fg = c.green, bold = true })
hl("@markup.heading.4", { fg = c.orange, bold = true })
hl("@markup.heading.5", { fg = c.cyan, bold = true })
hl("@markup.heading.6", { fg = c.magenta, bold = true })
hl("@markup.link", { fg = c.blue, underline = true })
hl("@markup.link.label", { fg = c.cyan })
hl("@markup.link.url", { fg = c.blue_d, underline = true, italic = true })
hl("@markup.list", { fg = c.pu3 })
hl("@markup.list.checked", { fg = c.green })
hl("@markup.list.unchecked", { fg = c.fg_mute })
hl("@markup.quote", { fg = c.fg_dim, italic = true })
hl("@markup.raw", { fg = c.green })
hl("@markup.raw.block", { fg = c.green })
hl("@markup.strikethrough", { fg = c.fg_mute, strikethrough = true })
hl("@markup.strong", { fg = c.fg_hi, bold = true })
hl("@markup.italic", { fg = c.fg, italic = true })
hl("@markup.underline", { underline = true })
hl("@markup.math", { fg = c.cyan })

-- ── Diff ──────────────────────────────────────────────────────────────────────
hl("@diff.plus", { fg = c.green })
hl("@diff.minus", { fg = c.red })
hl("@diff.delta", { fg = c.yellow })

hl("@error", { fg = c.red })
hl("@none", {})

-- =============================================================================
-- LSP — DIAGNOSTICS
-- =============================================================================

hl("DiagnosticError", { fg = c.red })
hl("DiagnosticWarn", { fg = c.yellow })
hl("DiagnosticInfo", { fg = c.blue })
hl("DiagnosticHint", { fg = c.cyan })
hl("DiagnosticOk", { fg = c.green })

hl("DiagnosticVirtualTextError", { fg = c.red_l, bg = c.red_bg, italic = true })
hl("DiagnosticVirtualTextWarn", { fg = c.yellow, bg = c.orange_bg, italic = true })
hl("DiagnosticVirtualTextInfo", { fg = c.blue, bg = c.blue_bg, italic = true })
hl("DiagnosticVirtualTextHint", { fg = c.cyan, bg = "#0A1E20", italic = true })
hl("DiagnosticVirtualTextOk", { fg = c.green, bg = c.green_bg, italic = true })

hl("DiagnosticUnderlineError", { undercurl = true, sp = c.red })
hl("DiagnosticUnderlineWarn", { undercurl = true, sp = c.yellow })
hl("DiagnosticUnderlineInfo", { undercurl = true, sp = c.blue })
hl("DiagnosticUnderlineHint", { undercurl = true, sp = c.cyan })
hl("DiagnosticUnderlineOk", { undercurl = true, sp = c.green })

hl("DiagnosticSignError", { fg = c.red })
hl("DiagnosticSignWarn", { fg = c.yellow })
hl("DiagnosticSignInfo", { fg = c.blue })
hl("DiagnosticSignHint", { fg = c.cyan })

hl("DiagnosticFloatingError", { fg = c.red })
hl("DiagnosticFloatingWarn", { fg = c.yellow })
hl("DiagnosticFloatingInfo", { fg = c.blue })
hl("DiagnosticFloatingHint", { fg = c.cyan })

hl("DiagnosticDeprecated", { fg = c.fg_mute, strikethrough = true })
hl("DiagnosticUnnecessary", { fg = c.fg_mute, italic = true })

hl("LspReferenceText", { bg = c.bg3 })
hl("LspReferenceRead", { bg = c.bg3 })
hl("LspReferenceWrite", { bg = c.bg3, underline = true })
hl("LspSignatureActiveParameter", { fg = c.orange, underline = true })
hl("LspInlayHint", { fg = c.fg_mute, bg = c.bg2, italic = true })
hl("LspCodeLens", { fg = c.fg_mute, italic = true })
hl("LspCodeLensSeparator", { fg = c.border })

-- =============================================================================
-- LSP — SEMANTIC TOKENS  (global / language-agnostic)
-- =============================================================================

hl("@lsp.type.boolean", { link = "@boolean" })
hl("@lsp.type.builtinType", { link = "@type.builtin" })
hl("@lsp.type.class", { fg = c.blue })
hl("@lsp.type.comment", { link = "@comment" })
hl("@lsp.type.decorator", { fg = c.pu3 })
hl("@lsp.type.enum", { fg = c.blue })
hl("@lsp.type.enumMember", { fg = c.cyan, bold = true })
hl("@lsp.type.event", { fg = c.orange })
hl("@lsp.type.function", { fg = c.pu4 })
hl("@lsp.type.interface", { fg = c.blue, italic = true })
hl("@lsp.type.keyword", { fg = c.pu4 })
hl("@lsp.type.macro", { fg = c.pu3 })
hl("@lsp.type.method", { fg = c.pu4 })
hl("@lsp.type.modifier", { fg = c.pu3, italic = true })
hl("@lsp.type.namespace", { fg = c.blue_d })
hl("@lsp.type.number", { link = "@number" })
hl("@lsp.type.operator", { link = "@operator" })
hl("@lsp.type.parameter", { fg = c.fg_dim, italic = true })
hl("@lsp.type.property", { fg = c.cyan }) -- THE fix: was c.fg
hl("@lsp.type.regexp", { fg = c.magenta })
hl("@lsp.type.string", { link = "@string" })
hl("@lsp.type.struct", { fg = c.blue })
hl("@lsp.type.type", { fg = c.blue })
hl("@lsp.type.typeAlias", { fg = c.blue })
hl("@lsp.type.typeParameter", { fg = c.blue, italic = true })
hl("@lsp.type.unresolvedReference", { underdotted = true, sp = c.red })
hl("@lsp.type.variable", { fg = c.pu5 }) -- THE fix: was c.fg

-- Semantic token modifiers
hl("@lsp.mod.abstract", { italic = true })
hl("@lsp.mod.async", { italic = true })
hl("@lsp.mod.declaration", { bold = true })
hl("@lsp.mod.defaultLibrary", { italic = true })
hl("@lsp.mod.deprecated", { strikethrough = true, fg = c.fg_mute })
hl("@lsp.mod.documentation", { italic = true })
hl("@lsp.mod.modification", { fg = c.orange })
hl("@lsp.mod.readonly", { fg = c.cyan, italic = true })
hl("@lsp.mod.static", { italic = true })

-- =============================================================================
-- DIFF / GIT
-- =============================================================================

hl("DiffAdd", { fg = c.green, bg = c.green_bg })
hl("DiffChange", { fg = c.yellow, bg = c.blue_bg })
hl("DiffDelete", { fg = c.red, bg = c.red_bg })
hl("DiffText", { fg = c.bg0, bg = c.yellow, bold = true })
hl("DiffAdded", { link = "DiffAdd" })
hl("DiffRemoved", { link = "DiffDelete" })

-- =============================================================================
-- TERMINAL COLORS (all 16 ANSI slots)
-- =============================================================================

vim.g.terminal_color_0 = c.bg2
vim.g.terminal_color_1 = c.red
vim.g.terminal_color_2 = c.green
vim.g.terminal_color_3 = c.yellow
vim.g.terminal_color_4 = c.blue
vim.g.terminal_color_5 = c.magenta
vim.g.terminal_color_6 = c.cyan
vim.g.terminal_color_7 = c.fg
vim.g.terminal_color_8 = c.fg_mute
vim.g.terminal_color_9 = c.red_l
vim.g.terminal_color_10 = c.green_l
vim.g.terminal_color_11 = "#F0D9A0"
vim.g.terminal_color_12 = "#9ECFFF"
vim.g.terminal_color_13 = c.pu4
vim.g.terminal_color_14 = c.cyan_l
vim.g.terminal_color_15 = c.pu5

-- =============================================================================
-- PLUGINS
-- =============================================================================

-- ── nvim-tree ─────────────────────────────────────────────────────────────────
hl("NvimTreeNormal", { fg = c.fg, bg = c.bg1 })
hl("NvimTreeNormalFloat", { fg = c.fg, bg = c.bg_float })
hl("NvimTreeNormalNC", { fg = c.fg_dim, bg = c.bg1 })
hl("NvimTreeCursorLine", { bg = c.bg2 })
hl("NvimTreeFolderIcon", { fg = c.pu4 })
hl("NvimTreeFolderName", { fg = c.blue })
hl("NvimTreeOpenedFolderName", { fg = c.blue, italic = true })
hl("NvimTreeEmptyFolderName", { fg = c.fg_mute })
hl("NvimTreeSymlink", { fg = c.cyan })
hl("NvimTreeSymlinkFolderName", { fg = c.cyan })
hl("NvimTreeExecFile", { fg = c.green, bold = true })
hl("NvimTreeSpecialFile", { fg = c.magenta, underline = true })
hl("NvimTreeImageFile", { fg = c.orange })
hl("NvimTreeGitDirty", { fg = c.orange })
hl("NvimTreeGitNew", { fg = c.green })
hl("NvimTreeGitDeleted", { fg = c.red })
hl("NvimTreeGitMerge", { fg = c.magenta })
hl("NvimTreeGitRenamed", { fg = c.yellow })
hl("NvimTreeGitStaged", { fg = c.green_l })
hl("NvimTreeIndentMarker", { fg = c.border })
hl("NvimTreeRootFolder", { fg = c.pu4, bold = true })
hl("NvimTreeWinSeparator", { fg = c.border, bg = c.bg1 })

-- ── neo-tree ──────────────────────────────────────────────────────────────────
hl("NeoTreeNormal", { fg = c.fg, bg = c.bg1 })
hl("NeoTreeNormalNC", { fg = c.fg_dim, bg = c.bg1 })
hl("NeoTreeDirectoryIcon", { fg = c.pu4 })
hl("NeoTreeDirectoryName", { fg = c.blue })
hl("NeoTreeFileName", { fg = c.fg })
hl("NeoTreeFileIcon", { fg = c.fg_dim })
hl("NeoTreeRootName", { fg = c.pu4, bold = true })
hl("NeoTreeGitAdded", { fg = c.green })
hl("NeoTreeGitConflict", { fg = c.red, bold = true })
hl("NeoTreeGitDeleted", { fg = c.red })
hl("NeoTreeGitModified", { fg = c.orange })
hl("NeoTreeGitUntracked", { fg = c.yellow })
hl("NeoTreeIndentMarker", { fg = c.border })
hl("NeoTreeSymbolicLinkTarget", { fg = c.cyan })
hl("NeoTreeTitleBar", { fg = c.bg0, bg = c.pu4, bold = true })

-- ── telescope.nvim ────────────────────────────────────────────────────────────
hl("TelescopeNormal", { fg = c.fg, bg = c.bg_float })
hl("TelescopeBorder", { fg = c.pu1, bg = c.bg_float })
hl("TelescopeTitle", { fg = c.pu4, bg = c.bg_float, bold = true })
hl("TelescopePromptNormal", { fg = c.fg, bg = c.bg3 })
hl("TelescopePromptBorder", { fg = c.pu2, bg = c.bg3 })
hl("TelescopePromptTitle", { fg = c.bg0, bg = c.pu4, bold = true })
hl("TelescopePromptPrefix", { fg = c.pu4, bg = c.bg3 })
hl("TelescopePromptCounter", { fg = c.fg_mute, bg = c.bg3 })
hl("TelescopeResultsNormal", { fg = c.fg_dim, bg = c.bg_float })
hl("TelescopeResultsBorder", { fg = c.pu1, bg = c.bg_float })
hl("TelescopeResultsTitle", { fg = c.fg_mute, bg = c.bg_float })
hl("TelescopePreviewNormal", { fg = c.fg, bg = c.bg0 })
hl("TelescopePreviewBorder", { fg = c.pu1, bg = c.bg0 })
hl("TelescopePreviewTitle", { fg = c.bg0, bg = c.blue, bold = true })
hl("TelescopeSelection", { fg = c.fg_hi, bg = c.bg3, bold = true })
hl("TelescopeSelectionCaret", { fg = c.pu4, bg = c.bg3 })
hl("TelescopeMultiSelection", { fg = c.orange, bg = c.bg3 })
hl("TelescopeMatching", { fg = c.green, bold = true })

-- ── fzf-lua ───────────────────────────────────────────────────────────────────
hl("FzfLuaNormal", { link = "NormalFloat" })
hl("FzfLuaBorder", { link = "FloatBorder" })
hl("FzfLuaTitle", { link = "FloatTitle" })
hl("FzfLuaHeaderBind", { fg = c.pu4 })
hl("FzfLuaHeaderText", { fg = c.blue })
hl("FzfLuaPathColNr", { fg = c.orange })
hl("FzfLuaPathLineNr", { fg = c.yellow })
hl("FzfLuaBufName", { fg = c.blue })
hl("FzfLuaBufNr", { fg = c.fg_mute })
hl("FzfLuaTabTitle", { fg = c.pu4, bold = true })

-- ── nvim-cmp ──────────────────────────────────────────────────────────────────
hl("CmpNormal", { link = "NormalFloat" })
hl("CmpBorder", { link = "FloatBorder" })
hl("CmpItemAbbr", { fg = c.fg })
hl("CmpItemAbbrMatch", { fg = c.pu4, bold = true })
hl("CmpItemAbbrMatchFuzzy", { fg = c.green })
hl("CmpItemAbbrDeprecated", { fg = c.fg_mute, strikethrough = true })
hl("CmpItemKind", { fg = c.blue })
hl("CmpItemKindText", { fg = c.fg_dim })
hl("CmpItemKindFunction", { fg = c.pu4 })
hl("CmpItemKindMethod", { fg = c.pu4 })
hl("CmpItemKindConstructor", { fg = c.blue })
hl("CmpItemKindField", { fg = c.cyan })
hl("CmpItemKindVariable", { fg = c.pu5 })
hl("CmpItemKindClass", { fg = c.blue })
hl("CmpItemKindInterface", { fg = c.blue, italic = true })
hl("CmpItemKindModule", { fg = c.blue_d })
hl("CmpItemKindProperty", { fg = c.cyan })
hl("CmpItemKindUnit", { fg = c.orange })
hl("CmpItemKindValue", { fg = c.cyan })
hl("CmpItemKindEnum", { fg = c.blue })
hl("CmpItemKindKeyword", { fg = c.pu4 })
hl("CmpItemKindSnippet", { fg = c.magenta })
hl("CmpItemKindColor", { fg = c.orange })
hl("CmpItemKindFile", { fg = c.blue })
hl("CmpItemKindReference", { fg = c.cyan })
hl("CmpItemKindFolder", { fg = c.blue })
hl("CmpItemKindEnumMember", { fg = c.cyan, bold = true })
hl("CmpItemKindConstant", { fg = c.cyan })
hl("CmpItemKindStruct", { fg = c.blue })
hl("CmpItemKindEvent", { fg = c.orange })
hl("CmpItemKindOperator", { fg = c.cyan })
hl("CmpItemKindTypeParameter", { fg = c.blue, italic = true })
hl("CmpItemMenu", { fg = c.fg_mute, italic = true })
hl("CmpGhostText", { fg = c.fg_mute, italic = true })

-- ── blink.cmp ─────────────────────────────────────────────────────────────────
hl("BlinkCmpMenu", { link = "NormalFloat" })
hl("BlinkCmpMenuBorder", { link = "FloatBorder" })
hl("BlinkCmpMenuSelection", { fg = c.bg0, bg = c.pu4, bold = true })
hl("BlinkCmpScrollBarThumb", { bg = c.pu1 })
hl("BlinkCmpScrollBarGutter", { bg = c.bg3 })
hl("BlinkCmpLabel", { fg = c.fg })
hl("BlinkCmpLabelMatch", { fg = c.pu4, bold = true })
hl("BlinkCmpLabelDetail", { fg = c.fg_mute })
hl("BlinkCmpLabelDescription", { fg = c.fg_mute, italic = true })
hl("BlinkCmpLabelDeprecated", { fg = c.fg_mute, strikethrough = true })
hl("BlinkCmpKind", { fg = c.blue })
hl("BlinkCmpKindFunction", { fg = c.pu4 })
hl("BlinkCmpKindMethod", { fg = c.pu4 })
hl("BlinkCmpKindClass", { fg = c.blue })
hl("BlinkCmpKindInterface", { fg = c.blue, italic = true })
hl("BlinkCmpKindVariable", { fg = c.pu5 })
hl("BlinkCmpKindField", { fg = c.cyan })
hl("BlinkCmpKindKeyword", { fg = c.pu4 })
hl("BlinkCmpKindSnippet", { fg = c.magenta })
hl("BlinkCmpKindModule", { fg = c.blue_d })
hl("BlinkCmpKindConstant", { fg = c.cyan })
hl("BlinkCmpDoc", { link = "NormalFloat" })
hl("BlinkCmpDocBorder", { link = "FloatBorder" })
hl("BlinkCmpGhostText", { fg = c.fg_mute, italic = true })
hl("BlinkCmpSignatureHelp", { link = "NormalFloat" })
hl("BlinkCmpSignatureHelpBorder", { link = "FloatBorder" })
hl("BlinkCmpSignatureHelpActiveParameter", { fg = c.orange, underline = true })

-- ── gitsigns.nvim ─────────────────────────────────────────────────────────────
hl("GitSignsAdd", { fg = c.green })
hl("GitSignsChange", { fg = c.yellow })
hl("GitSignsDelete", { fg = c.red })
hl("GitSignsChangedelete", { fg = c.orange })
hl("GitSignsUntracked", { fg = c.blue_d })
hl("GitSignsAddNr", { link = "GitSignsAdd" })
hl("GitSignsChangeNr", { link = "GitSignsChange" })
hl("GitSignsDeleteNr", { link = "GitSignsDelete" })
hl("GitSignsAddLn", { bg = c.green_bg })
hl("GitSignsChangeLn", { bg = c.blue_bg })
hl("GitSignsDeleteLn", { bg = c.red_bg })
hl("GitSignsCurrentLineBlame", { fg = c.fg_mute, italic = true })

-- ── indent-blankline v3 ───────────────────────────────────────────────────────
hl("IblIndent", { fg = c.bg3, nocombine = true })
hl("IblScope", { fg = c.pu2, nocombine = true })
hl("IblWhitespace", { fg = c.bg3 })
hl("IndentBlanklineChar", { link = "IblIndent" })
hl("IndentBlanklineContextChar", { link = "IblScope" })

-- ── lualine ───────────────────────────────────────────────────────────────────
hl("lualine_a_normal", { fg = c.bg0, bg = c.pu4, bold = true })
hl("lualine_b_normal", { fg = c.fg, bg = c.bg3 })
hl("lualine_c_normal", { fg = c.fg_dim, bg = c.bg1 })
hl("lualine_a_insert", { fg = c.bg0, bg = c.green, bold = true })
hl("lualine_b_insert", { fg = c.fg, bg = c.bg3 })
hl("lualine_c_insert", { fg = c.fg_dim, bg = c.bg1 })
hl("lualine_a_visual", { fg = c.bg0, bg = c.orange, bold = true })
hl("lualine_b_visual", { fg = c.fg, bg = c.bg3 })
hl("lualine_c_visual", { fg = c.fg_dim, bg = c.bg1 })
hl("lualine_a_replace", { fg = c.bg0, bg = c.red, bold = true })
hl("lualine_b_replace", { fg = c.fg, bg = c.bg3 })
hl("lualine_c_replace", { fg = c.fg_dim, bg = c.bg1 })
hl("lualine_a_command", { fg = c.bg0, bg = c.yellow, bold = true })
hl("lualine_a_inactive", { fg = c.fg_mute, bg = c.bg1 })
hl("lualine_b_inactive", { fg = c.fg_mute, bg = c.bg1 })
hl("lualine_c_inactive", { fg = c.fg_mute, bg = c.bg0 })

-- ── trouble.nvim ──────────────────────────────────────────────────────────────
hl("TroubleNormal", { fg = c.fg, bg = c.bg1 })
hl("TroubleNormalNC", { fg = c.fg_dim, bg = c.bg1 })
hl("TroubleText", { fg = c.fg_dim })
hl("TroubleCount", { fg = c.pu4 })
hl("TroubleFile", { fg = c.blue, bold = true })
hl("TroublePos", { fg = c.fg_mute })
hl("TroubleLocation", { fg = c.fg_mute })
hl("TroubleIndent", { fg = c.border })
hl("TroubleFoldIcon", { fg = c.pu4 })
hl("TroubleSignError", { link = "DiagnosticSignError" })
hl("TroubleSignWarn", { link = "DiagnosticSignWarn" })
hl("TroubleSignInfo", { link = "DiagnosticSignInfo" })
hl("TroubleSignHint", { link = "DiagnosticSignHint" })

-- ── which-key.nvim ────────────────────────────────────────────────────────────
hl("WhichKey", { fg = c.pu4 })
hl("WhichKeyGroup", { fg = c.blue })
hl("WhichKeyDesc", { fg = c.fg })
hl("WhichKeySeparator", { fg = c.border })
hl("WhichKeyValue", { fg = c.fg_mute })
hl("WhichKeyBorder", { link = "FloatBorder" })
hl("WhichKeyTitle", { link = "FloatTitle" })
hl("WhichKeyNormal", { link = "NormalFloat" })

-- ── mason.nvim ────────────────────────────────────────────────────────────────
hl("MasonNormal", { link = "NormalFloat" })
hl("MasonHeader", { fg = c.bg0, bg = c.pu4, bold = true })
hl("MasonHeaderSecondary", { fg = c.bg0, bg = c.blue, bold = true })
hl("MasonHighlight", { fg = c.pu4 })
hl("MasonHighlightBlock", { fg = c.bg0, bg = c.pu4 })
hl("MasonHighlightBlockBold", { fg = c.bg0, bg = c.pu4, bold = true })
hl("MasonHighlightSecondary", { fg = c.green })
hl("MasonHighlightBlockSecondary", { fg = c.bg0, bg = c.green })
hl("MasonMuted", { fg = c.fg_mute })
hl("MasonMutedBlock", { fg = c.fg_mute, bg = c.bg3 })
hl("MasonLink", { fg = c.blue, underline = true })
hl("MasonError", { fg = c.red })
hl("MasonWarning", { fg = c.yellow })
hl("MasonHeading", { fg = c.pu4, bold = true })

-- ── dashboard.nvim + alpha.nvim ───────────────────────────────────────────────
hl("DashboardHeader", { fg = c.pu4 })
hl("DashboardDesc", { fg = c.fg_dim })
hl("DashboardKey", { fg = c.pu4, bold = true })
hl("DashboardIcon", { fg = c.pu4 })
hl("DashboardShortcut", { fg = c.green })
hl("DashboardMruIcon", { fg = c.blue })
hl("DashboardMruTitle", { fg = c.blue, bold = true })
hl("DashboardProjectTitle", { fg = c.orange, bold = true })
hl("DashboardProjectTitleIcon", { fg = c.orange })
hl("DashboardFooter", { fg = c.fg_mute, italic = true })
hl("AlphaHeader", { link = "DashboardHeader" })
hl("AlphaButtons", { fg = c.blue })
hl("AlphaShortcut", { fg = c.green })
hl("AlphaFooter", { link = "DashboardFooter" })

-- ── noice.nvim ────────────────────────────────────────────────────────────────
hl("NoiceCmdline", { fg = c.fg, bg = c.bg3 })
hl("NoiceCmdlineIcon", { fg = c.pu4 })
hl("NoiceCmdlineIconSearch", { fg = c.yellow })
hl("NoiceCmdlinePopup", { fg = c.fg, bg = c.bg3 })
hl("NoiceCmdlinePopupBorder", { fg = c.pu2 })
hl("NoiceCmdlinePopupBorderSearch", { fg = c.yellow })
hl("NoiceCmdlinePopupTitle", { fg = c.pu4, bold = true })
hl("NoiceConfirm", { link = "NormalFloat" })
hl("NoiceConfirmBorder", { fg = c.pu2 })
hl("NoiceFormatProgressTodo", { fg = c.fg_mute, bg = c.bg3 })
hl("NoiceFormatProgressDone", { fg = c.green, bg = c.bg3 })
hl("NoiceLspProgressTitle", { fg = c.pu4 })
hl("NoiceLspProgressClient", { fg = c.blue })
hl("NoiceLspProgressSpinner", { fg = c.green })
hl("NoicePopup", { link = "NormalFloat" })
hl("NoicePopupBorder", { link = "FloatBorder" })
hl("NoiceMini", { fg = c.fg_dim, bg = c.bg1 })
hl("NoiceSplit", { fg = c.fg, bg = c.bg1 })
hl("NoiceSplitBorder", { link = "FloatBorder" })
hl("NoiceScrollbar", { bg = c.bg3 })
hl("NoiceScrollbarThumb", { bg = c.pu1 })

-- ── nvim-notify ───────────────────────────────────────────────────────────────
hl("NotifyERRORBorder", { fg = c.red })
hl("NotifyERRORIcon", { fg = c.red })
hl("NotifyERRORTitle", { fg = c.red, bold = true })
hl("NotifyERRORBody", { fg = c.fg, bg = c.bg_float })
hl("NotifyWARNBorder", { fg = c.yellow })
hl("NotifyWARNIcon", { fg = c.yellow })
hl("NotifyWARNTitle", { fg = c.yellow, bold = true })
hl("NotifyWARNBody", { fg = c.fg, bg = c.bg_float })
hl("NotifyINFOBorder", { fg = c.blue })
hl("NotifyINFOIcon", { fg = c.blue })
hl("NotifyINFOTitle", { fg = c.blue, bold = true })
hl("NotifyINFOBody", { fg = c.fg, bg = c.bg_float })
hl("NotifyDEBUGBorder", { fg = c.gray })
hl("NotifyDEBUGIcon", { fg = c.gray })
hl("NotifyDEBUGTitle", { fg = c.gray })
hl("NotifyDEBUGBody", { fg = c.fg, bg = c.bg_float })
hl("NotifyTRACEBorder", { fg = c.pu2 })
hl("NotifyTRACEIcon", { fg = c.pu2 })
hl("NotifyTRACETitle", { fg = c.pu2 })
hl("NotifyTRACEBody", { fg = c.fg, bg = c.bg_float })

-- ── nvim-dap + nvim-dap-ui ────────────────────────────────────────────────────
hl("DapBreakpoint", { fg = c.red })
hl("DapBreakpointCondition", { fg = c.orange })
hl("DapBreakpointRejected", { fg = c.fg_mute, italic = true })
hl("DapLogPoint", { fg = c.blue })
hl("DapStopped", { fg = c.green, bg = c.green_bg })
hl("DapStoppedLine", { bg = c.green_bg })
hl("DapUIScope", { fg = c.pu4 })
hl("DapUIType", { fg = c.blue })
hl("DapUIValue", { fg = c.cyan })
hl("DapUIFrameName", { fg = c.fg })
hl("DapUIThread", { fg = c.green })
hl("DapUIWatchesEmpty", { fg = c.fg_mute, italic = true })
hl("DapUIWatchesError", { fg = c.red })
hl("DapUIWatchesValue", { fg = c.cyan })
hl("DapUIBreakpointsCurrentLine", { fg = c.green, bold = true })
hl("DapUIBreakpointsDisabledLine", { fg = c.fg_mute })
hl("DapUIBreakpointsInfo", { fg = c.blue })
hl("DapUIBreakpointsPath", { fg = c.blue_d })
hl("DapUIFloatBorder", { link = "FloatBorder" })
hl("DapUIFloatNormal", { link = "NormalFloat" })

-- ── lazy.nvim ─────────────────────────────────────────────────────────────────
hl("LazyNormal", { link = "NormalFloat" })
hl("LazyBorder", { link = "FloatBorder" })
hl("LazyTitle", { link = "FloatTitle" })
hl("LazyButton", { fg = c.fg, bg = c.bg3 })
hl("LazyButtonActive", { fg = c.bg0, bg = c.pu4, bold = true })
hl("LazyH1", { fg = c.pu4, bold = true })
hl("LazyH2", { fg = c.blue, bold = true })
hl("LazyComment", { fg = c.fg_mute, italic = true })
hl("LazyProgressDone", { fg = c.green })
hl("LazyProgressTodo", { fg = c.fg_mute })
hl("LazyProp", { fg = c.fg_dim })
hl("LazyValue", { fg = c.cyan })
hl("LazyCommit", { fg = c.green, bold = true })
hl("LazyCommitType", { fg = c.pu3 })
hl("LazyCommitScope", { fg = c.blue })
hl("LazyDimmed", { fg = c.fg_mute })
hl("LazySpecial", { fg = c.pu4 })
hl("LazyLocal", { fg = c.orange })
hl("LazyUrl", { fg = c.blue, underline = true })
hl("LazyReasonImport", { fg = c.pu4 })
hl("LazyReasonEvent", { fg = c.yellow })
hl("LazyReasonKeys", { fg = c.green })
hl("LazyReasonStart", { fg = c.cyan })
hl("LazyReasonPlugin", { fg = c.blue })
hl("LazyReasonRuntime", { fg = c.orange })
hl("LazyReasonSource", { fg = c.pu3 })
hl("LazyReasonCmd", { fg = c.red })
hl("LazyReasonFt", { fg = c.blue_d })
hl("LazyReasonRequire", { fg = c.magenta })

-- ── oil.nvim ──────────────────────────────────────────────────────────────────
hl("OilNormal", { fg = c.fg, bg = c.bg0 })
hl("OilNormalFloat", { link = "NormalFloat" })
hl("OilDir", { fg = c.blue, bold = true })
hl("OilDirIcon", { fg = c.pu4 })
hl("OilLink", { fg = c.cyan })
hl("OilLinkTarget", { fg = c.cyan, italic = true })
hl("OilCopy", { fg = c.yellow, bold = true })
hl("OilMove", { fg = c.orange, bold = true })
hl("OilChange", { fg = c.yellow })
hl("OilCreate", { fg = c.green, bold = true })
hl("OilDelete", { fg = c.red, bold = true })
hl("OilPermissionNone", { fg = c.fg_mute })
hl("OilPermissionRead", { fg = c.yellow })
hl("OilPermissionWrite", { fg = c.red })
hl("OilPermissionExecute", { fg = c.green })
hl("OilTypeFile", { fg = c.fg_mute })
hl("OilTypeDir", { fg = c.blue })
hl("OilTypeLink", { fg = c.cyan })
hl("OilTypeSpecial", { fg = c.magenta })
hl("OilSize", { fg = c.fg_mute })
hl("OilMtime", { fg = c.fg_mute })
hl("OilHidden", { fg = c.fg_mute, italic = true })

-- ── flash.nvim ────────────────────────────────────────────────────────────────
hl("FlashBackdrop", { fg = c.fg_mute })
hl("FlashMatch", { fg = c.bg0, bg = c.pu3 })
hl("FlashCurrent", { fg = c.bg0, bg = c.pu4, bold = true })
hl("FlashLabel", { fg = c.bg0, bg = c.orange, bold = true })
hl("FlashPrompt", { fg = c.pu4 })
hl("FlashPromptIcon", { fg = c.pu4 })
hl("FlashCursor", { fg = c.bg0, bg = c.cyan })

-- ── mini.nvim ─────────────────────────────────────────────────────────────────
hl("MiniStatuslineModeNormal", { fg = c.bg0, bg = c.pu4, bold = true })
hl("MiniStatuslineModeInsert", { fg = c.bg0, bg = c.green, bold = true })
hl("MiniStatuslineModeVisual", { fg = c.bg0, bg = c.orange, bold = true })
hl("MiniStatuslineModeReplace", { fg = c.bg0, bg = c.red, bold = true })
hl("MiniStatuslineModeCommand", { fg = c.bg0, bg = c.yellow, bold = true })
hl("MiniStatuslineModeOther", { fg = c.bg0, bg = c.cyan, bold = true })
hl("MiniStatuslineDevinfo", { fg = c.fg_dim, bg = c.bg3 })
hl("MiniStatuslineFilename", { fg = c.fg_dim, bg = c.bg1 })
hl("MiniStatuslineFileinfo", { fg = c.fg_dim, bg = c.bg3 })
hl("MiniStatuslineInactive", { fg = c.fg_mute, bg = c.bg0 })
hl("MiniTablineCurrent", { fg = c.bg0, bg = c.pu4, bold = true })
hl("MiniTablineVisible", { fg = c.fg_dim, bg = c.bg2 })
hl("MiniTablineHidden", { fg = c.fg_mute, bg = c.bg1 })
hl("MiniTablineModifiedCurrent", { fg = c.bg0, bg = c.orange, bold = true })
hl("MiniTablineModifiedVisible", { fg = c.orange, bg = c.bg2 })
hl("MiniTablineModifiedHidden", { fg = c.orange_d, bg = c.bg1 })
hl("MiniTablineFill", { bg = c.bg0 })
hl("MiniCursorword", { bg = c.bg3, underline = true })
hl("MiniCursorwordCurrent", { bg = c.bg3, underline = true })
hl("MiniIndentscopeSymbol", { fg = c.pu2, nocombine = true })
hl("MiniJump", { fg = c.bg0, bg = c.orange, bold = true })
hl("MiniJump2dSpot", { fg = c.bg0, bg = c.pu4, bold = true })
hl("MiniJump2dSpotAhead", { fg = c.bg0, bg = c.blue, bold = true })
hl("MiniJump2dSpotUnique", { fg = c.bg0, bg = c.green, bold = true })
hl("MiniStarterCurrent", { fg = c.pu4, bold = true })
hl("MiniStarterFooter", { fg = c.fg_mute, italic = true })
hl("MiniStarterHeader", { fg = c.pu4 })
hl("MiniStarterInactive", { fg = c.fg_mute, italic = true })
hl("MiniStarterItem", { fg = c.fg })
hl("MiniStarterItemBullet", { fg = c.border })
hl("MiniStarterItemPrefix", { fg = c.green, bold = true })
hl("MiniStarterSection", { fg = c.blue, bold = true })
hl("MiniStarterQuery", { fg = c.cyan })
hl("MiniSurround", { fg = c.bg0, bg = c.orange })
hl("MiniTrailspace", { bg = c.red_bg })
hl("MiniDiffSignAdd", { fg = c.green })
hl("MiniDiffSignChange", { fg = c.yellow })
hl("MiniDiffSignDelete", { fg = c.red })
hl("MiniDiffOverAdd", { bg = c.green_bg })
hl("MiniDiffOverChange", { bg = c.blue_bg })
hl("MiniDiffOverDelete", { bg = c.red_bg })
hl("MiniNotifyBorder", { link = "FloatBorder" })
hl("MiniNotifyNormal", { link = "NormalFloat" })
hl("MiniPickBorder", { link = "FloatBorder" })
hl("MiniPickBorderBusy", { fg = c.yellow })
hl("MiniPickBorderText", { fg = c.pu4, bold = true })
hl("MiniPickMatchCurrent", { fg = c.fg_hi, bg = c.bg3, bold = true })
hl("MiniPickMatchMarked", { fg = c.orange, bg = c.bg3 })
hl("MiniPickMatchRanges", { fg = c.green, bold = true })
hl("MiniPickNormal", { link = "NormalFloat" })
hl("MiniPickPrompt", { fg = c.pu4, bg = c.bg3 })
hl("MiniFilesBorder", { link = "FloatBorder" })
hl("MiniFilesDirectory", { fg = c.blue, bold = true })
hl("MiniFilesFile", { fg = c.fg })
hl("MiniFilesNormal", { link = "NormalFloat" })
hl("MiniFilesTitle", { fg = c.pu4, bold = true })
hl("MiniFilesTitleFocused", { fg = c.pu4, bg = c.bg_float, bold = true })

-- =============================================================================
-- LANGUAGE-SPECIFIC SEMANTIC TOKENS
-- Per-language overrides for Treesitter captures and LSP semantic tokens.
-- These run AFTER the global groups so they win the priority battle.
-- =============================================================================

-- ── RUST  (rust-analyzer) ─────────────────────────────────────────────────────
-- Lifetimes: TS captures as @label in the rust grammar
hl("@label.rust", { fg = c.magenta, italic = true })
hl("@attribute.rust", { fg = c.pu3 })
hl("@attribute.builtin.rust", { fg = c.pu3, italic = true })
hl("@function.macro.rust", { fg = c.pu3, bold = true })

-- rust-analyzer token types
hl("@lsp.type.lifetime", { fg = c.magenta, italic = true })
hl("@lsp.type.selfKeyword", { fg = c.orange, italic = true })
hl("@lsp.type.selfTypeKeyword", { fg = c.blue, italic = true })
hl("@lsp.type.formatSpecifier", { fg = c.cyan })
hl("@lsp.type.escapeSequence", { fg = c.cyan })
hl("@lsp.type.builtinAttribute", { fg = c.pu3, italic = true })
hl("@lsp.type.deriveHelper", { fg = c.pu3, italic = true })
hl("@lsp.type.attributeBracket", { fg = c.pu3 })
hl("@lsp.type.generic", { fg = c.blue, italic = true })
hl("@lsp.type.trait", { fg = c.blue, italic = true })
hl("@lsp.type.union", { fg = c.blue })

-- rust-analyzer token modifiers
hl("@lsp.typemod.mutable", { underline = true })
hl("@lsp.typemod.unsafe", { fg = c.red })
hl("@lsp.typemod.consuming", { italic = true })
hl("@lsp.typemod.callable", { fg = c.pu4 })
hl("@lsp.typemod.library", { italic = true })
hl("@lsp.typemod.injected", { fg = c.fg_dim })
hl("@lsp.typemod.trait", { italic = true })
hl("@lsp.typemod.public", { bold = true })

-- Rust language-specific overrides
hl("@lsp.type.variable.rust", { fg = c.pu5 })
hl("@lsp.type.property.rust", { fg = c.cyan })
hl("@lsp.type.enumMember.rust", { fg = c.cyan, bold = true })

-- ── C  (clangd) ───────────────────────────────────────────────────────────────
hl("@variable.member.c", { fg = c.cyan })
hl("@type.qualifier.c", { fg = c.pu3, italic = true })
hl("@lsp.type.variable.c", { fg = c.pu5 })
hl("@lsp.type.property.c", { fg = c.cyan })
hl("@lsp.type.parameter.c", { fg = c.fg_dim, italic = true })
hl("@lsp.type.macro.c", { fg = c.pu3, bold = true })
hl("@lsp.typemod.static.c", { italic = true })
hl("@lsp.typemod.readonly.c", { fg = c.cyan, italic = true })

-- ── C++  (clangd) ─────────────────────────────────────────────────────────────
hl("@variable.member.cpp", { fg = c.cyan })
hl("@type.qualifier.cpp", { fg = c.pu3, italic = true })
hl("@keyword.modifier.cpp", { fg = c.pu3, italic = true })
hl("@operator.cpp", { fg = c.cyan })
hl("@lsp.type.variable.cpp", { fg = c.pu5 })
hl("@lsp.type.property.cpp", { fg = c.cyan })
hl("@lsp.type.parameter.cpp", { fg = c.fg_dim, italic = true })
hl("@lsp.type.macro.cpp", { fg = c.pu3, bold = true })
hl("@lsp.type.concept", { fg = c.blue, italic = true })
hl("@lsp.type.typeParameter.cpp", { fg = c.blue, italic = true })
hl("@lsp.type.namespace.cpp", { fg = c.blue_d })
hl("@lsp.type.enum.cpp", { fg = c.blue })
hl("@lsp.type.enumMember.cpp", { fg = c.cyan, bold = true })
hl("@lsp.typemod.static.cpp", { italic = true })
hl("@lsp.typemod.readonly.cpp", { fg = c.cyan, italic = true })
hl("@lsp.typemod.virtual", { italic = true })
hl("@lsp.typemod.deduced", { italic = true })
hl("@lsp.typemod.classScope", { fg = c.blue })

-- ── PYTHON  (pyright / basedpyright) ──────────────────────────────────────────
hl("@attribute.python", { fg = c.pu3 })
hl("@variable.builtin.python", { fg = c.orange, italic = true })
hl("@type.python", { fg = c.blue })
hl("@lsp.type.class.python", { fg = c.blue })
hl("@lsp.type.decorator.python", { fg = c.pu3 })
hl("@lsp.type.selfParameter", { fg = c.orange, italic = true })
hl("@lsp.type.clsParameter", { fg = c.orange, italic = true })
hl("@lsp.type.builtinConstant", { fg = c.orange })
hl("@lsp.type.variable.python", { fg = c.pu5 })
hl("@lsp.type.parameter.python", { fg = c.fg_dim, italic = true })
hl("@lsp.type.property.python", { fg = c.cyan })
hl("@lsp.type.typeParameter.python", { fg = c.blue, italic = true })
hl("@lsp.typemod.typeHint", { fg = c.blue })

-- ── JAVASCRIPT / TYPESCRIPT  (tsserver / vtsls) ───────────────────────────────
hl("@tag.jsx", { fg = c.pu4 })
hl("@tag.tsx", { fg = c.pu4 })
hl("@tag.attribute.jsx", { fg = c.blue })
hl("@tag.attribute.tsx", { fg = c.blue })
hl("@tag.builtin.jsx", { fg = c.cyan_l, italic = true })
hl("@tag.builtin.tsx", { fg = c.cyan_l, italic = true })
hl("@tag.delimiter.jsx", { fg = c.fg_mute })
hl("@tag.delimiter.tsx", { fg = c.fg_mute })
hl("@keyword.coroutine.javascript", { fg = c.pu4, italic = true })
hl("@keyword.coroutine.typescript", { fg = c.pu4, italic = true })
hl("@variable.member.javascript", { fg = c.cyan })
hl("@variable.member.typescript", { fg = c.cyan })
hl("@lsp.type.property.typescript", { fg = c.cyan })
hl("@lsp.type.property.javascript", { fg = c.cyan })
hl("@lsp.type.variable.typescript", { fg = c.pu5 })
hl("@lsp.type.variable.javascript", { fg = c.pu5 })
hl("@lsp.type.parameter.typescript", { fg = c.fg_dim, italic = true })
hl("@lsp.type.parameter.javascript", { fg = c.fg_dim, italic = true })
hl("@lsp.typemod.async.typescript", { italic = true })
hl("@lsp.typemod.async.javascript", { italic = true })
hl("@lsp.typemod.readonly.typescript", { fg = c.cyan, italic = true })
hl("@lsp.typemod.defaultLibrary.typescript", { italic = true })

-- ── JAVA  (jdtls) ─────────────────────────────────────────────────────────────
hl("@variable.member.java", { fg = c.cyan })
hl("@keyword.modifier.java", { fg = c.pu3, italic = true })
hl("@lsp.type.annotation", { fg = c.pu3 })
hl("@lsp.type.annotationMember", { fg = c.pu3, italic = true })
hl("@lsp.type.record.java", { fg = c.blue })
hl("@lsp.type.variable.java", { fg = c.pu5 })
hl("@lsp.type.property.java", { fg = c.cyan })
hl("@lsp.type.parameter.java", { fg = c.fg_dim, italic = true })
hl("@lsp.type.typeParameter.java", { fg = c.blue, italic = true })
hl("@lsp.type.enumMember.java", { fg = c.cyan, bold = true })
hl("@lsp.type.interface.java", { fg = c.blue, italic = true })
hl("@lsp.typemod.static.java", { italic = true })
hl("@lsp.typemod.readonly.java", { fg = c.cyan, italic = true })
hl("@lsp.typemod.deprecated.java", { fg = c.fg_mute, strikethrough = true })

-- ── C#  (OmniSharp / roslyn) ──────────────────────────────────────────────────
hl("@variable.member.c_sharp", { fg = c.cyan })
hl("@attribute.c_sharp", { fg = c.pu3 })
hl("@lsp.type.class.cs", { fg = c.blue })
hl("@lsp.type.struct.cs", { fg = c.blue })
hl("@lsp.type.interface.cs", { fg = c.blue, italic = true })
hl("@lsp.type.enum.cs", { fg = c.blue })
hl("@lsp.type.enumMember.cs", { fg = c.cyan, bold = true })
hl("@lsp.type.delegate", { fg = c.blue, italic = true })
hl("@lsp.type.event", { fg = c.orange })
hl("@lsp.type.record.cs", { fg = c.blue })
hl("@lsp.type.recordStruct", { fg = c.blue })
hl("@lsp.type.property.cs", { fg = c.cyan })
hl("@lsp.type.field", { fg = c.cyan })
hl("@lsp.type.local", { fg = c.pu5 })
hl("@lsp.type.variable.cs", { fg = c.pu5 })
hl("@lsp.type.parameter.cs", { fg = c.fg_dim, italic = true })
hl("@lsp.type.typeParameter.cs", { fg = c.blue, italic = true })
hl("@lsp.type.namespace.cs", { fg = c.blue_d })
hl("@lsp.type.method.cs", { fg = c.pu4 })
hl("@lsp.type.extensionMethod", { fg = c.pu4, italic = true })
hl("@lsp.type.xmlDocCommentAttributeName", { fg = c.blue })
hl("@lsp.typemod.static.cs", { italic = true })
hl("@lsp.typemod.readonly.cs", { fg = c.cyan, italic = true })
hl("@lsp.typemod.abstract.cs", { italic = true })
hl("@lsp.typemod.sealed", { italic = true })
hl("@lsp.typemod.override", { italic = true })
hl("@lsp.typemod.virtual.cs", { italic = true })
hl("@lsp.typemod.async.cs", { italic = true })
hl("@lsp.typemod.deprecated.cs", { fg = c.fg_mute, strikethrough = true })

-- ── KOTLIN  (kotlin-language-server) ──────────────────────────────────────────
hl("@variable.member.kotlin", { fg = c.cyan })
hl("@keyword.modifier.kotlin", { fg = c.pu3, italic = true })
hl("@keyword.coroutine.kotlin", { fg = c.pu4, italic = true })
hl("@lsp.type.variable.kotlin", { fg = c.pu5 })
hl("@lsp.type.property.kotlin", { fg = c.cyan })
hl("@lsp.type.parameter.kotlin", { fg = c.fg_dim, italic = true })
hl("@lsp.type.typeParameter.kotlin", { fg = c.blue, italic = true })
hl("@lsp.type.class.kotlin", { fg = c.blue })
hl("@lsp.type.interface.kotlin", { fg = c.blue, italic = true })
hl("@lsp.type.enumMember.kotlin", { fg = c.cyan, bold = true })
hl("@lsp.type.annotation.kotlin", { fg = c.pu3 })
hl("@lsp.typemod.abstract.kotlin", { italic = true })
hl("@lsp.typemod.override.kotlin", { italic = true })

-- ── LUA  (LuaLS) ──────────────────────────────────────────────────────────────
hl("@variable.member.lua", { fg = c.cyan })
hl("@variable.builtin.lua", { fg = c.orange, italic = true })
hl("@function.builtin.lua", { fg = c.cyan_l, italic = true })
hl("@lsp.type.property.lua", { fg = c.cyan })
hl("@lsp.type.variable.lua", { fg = c.pu5 })
hl("@lsp.type.parameter.lua", { fg = c.fg_dim, italic = true })

-- ── CMAKE ─────────────────────────────────────────────────────────────────────
hl("@function.cmake", { fg = c.pu4 })
hl("@variable.cmake", { fg = c.pu5 })
hl("@variable.builtin.cmake", { fg = c.orange, italic = true })
hl("@string.cmake", { fg = c.green })
hl("@keyword.cmake", { fg = c.pu4 })
hl("@string.special.cmake", { fg = c.orange })
hl("@punctuation.special.cmake", { fg = c.orange })

-- ── TOML ──────────────────────────────────────────────────────────────────────
hl("@type.toml", { fg = c.pu4, bold = true })
hl("@property.toml", { fg = c.blue })
hl("@string.toml", { fg = c.green })
hl("@number.toml", { fg = c.orange })
hl("@boolean.toml", { fg = c.orange })
hl("@comment.toml", { fg = c.fg_mute, italic = true })
hl("@punctuation.special.toml", { fg = c.pu3 })
hl("@string.special.toml", { fg = c.magenta })

-- ── JSON ──────────────────────────────────────────────────────────────────────
hl("@label.json", { fg = c.blue })
hl("@property.json", { fg = c.blue })
hl("@string.json", { fg = c.green })
hl("@number.json", { fg = c.orange })
hl("@boolean.json", { fg = c.orange })
hl("@constant.builtin.json", { fg = c.orange, italic = true })
hl("@punctuation.bracket.json", { fg = c.pu1 })
hl("@punctuation.delimiter.json", { fg = c.fg_mute })

-- ── INI / CONF / GITCONFIG ────────────────────────────────────────────────────
hl("@type.ini", { fg = c.pu4, bold = true })
hl("@property.ini", { fg = c.blue })
hl("@string.ini", { fg = c.green })
hl("@comment.ini", { fg = c.fg_mute, italic = true })
hl("@type.gitconfig", { fg = c.pu4, bold = true })
hl("@property.gitconfig", { fg = c.blue })
hl("@string.gitconfig", { fg = c.green })
hl("@type.conf", { fg = c.pu4, bold = true })
hl("@property.conf", { fg = c.blue })
hl("@string.conf", { fg = c.green })

-- ── YAML ──────────────────────────────────────────────────────────────────────
hl("@property.yaml", { fg = c.blue })
hl("@string.yaml", { fg = c.green })
hl("@boolean.yaml", { fg = c.orange })
hl("@number.yaml", { fg = c.orange })
hl("@type.yaml", { fg = c.pu4 })
hl("@punctuation.special.yaml", { fg = c.pu3 })
hl("@string.special.symbol.yaml", { fg = c.magenta })
hl("@comment.yaml", { fg = c.fg_mute, italic = true })

-- ── BASH / SH ─────────────────────────────────────────────────────────────────
hl("@function.bash", { fg = c.pu4 })
hl("@variable.bash", { fg = c.orange })
hl("@variable.builtin.bash", { fg = c.orange, italic = true })
hl("@string.special.bash", { fg = c.cyan })
hl("@punctuation.special.bash", { fg = c.cyan })
hl("@operator.bash", { fg = c.cyan })
hl("@keyword.bash", { fg = c.pu4 })
hl("@keyword.conditional.bash", { fg = c.pu4 })
hl("@constant.bash", { fg = c.cyan })
hl("@string.bash", { fg = c.green })

-- ── SQL ───────────────────────────────────────────────────────────────────────
hl("@keyword.sql", { fg = c.pu4 })
hl("@keyword.operator.sql", { fg = c.cyan })
hl("@type.sql", { fg = c.blue })
hl("@type.builtin.sql", { fg = c.blue, italic = true })
hl("@function.builtin.sql", { fg = c.cyan_l, italic = true })
hl("@string.sql", { fg = c.green })
hl("@number.sql", { fg = c.orange })
hl("@operator.sql", { fg = c.cyan })
hl("@variable.sql", { fg = c.orange })
hl("@attribute.sql", { fg = c.pu3 })

-- ── MARKDOWN ──────────────────────────────────────────────────────────────────
hl("@markup.raw.markdown_inline", { fg = c.green, bg = c.bg2 })
hl("@markup.raw.block.markdown", { fg = c.fg })
hl("@markup.link.label.markdown", { fg = c.cyan, bold = true })
hl("@markup.link.url.markdown", { fg = c.blue_d, underline = true, italic = true })
hl("@punctuation.special.markdown", { fg = c.pu3 })

-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║  GENTOO SYNTAX COLORS — JS / TS / CSS / Svelte                         ║
-- ║  ~/.config/nvim/after/plugin/svelte_hl.lua                             ║
-- ╚══════════════════════════════════════════════════════════════════════════╝
--
-- Gentoo palette:
--   #0D0A17  bg deepest     #1A1628  bg alt
--   #54487A  purple dark    #61538D  purple mid
--   #6E56AF  purple bright  #8A72C8  purple pale
--   #A994E0  purple light   #C4B0F0  purple whisper
--   #DDDAEC  grey fg        #DDDFFF  white-blue fg
--   #73D216  green          #4A8A0E  green dim
--   #D9534F  red            #C97B30  orange
--   #D4B860  yellow         #4EB8C8  teal

local hi = function(g, o)
	vim.api.nvim_set_hl(0, g, o)
end

-- ═══════════════════════════════════════════════════════════════════════════
--  JAVASCRIPT / TYPESCRIPT — KEYWORDS
-- ═══════════════════════════════════════════════════════════════════════════

-- Declaration keywords: const let var
hi("@keyword.declaration", { fg = "#6E56AF", bold = true })
hi("@keyword.declaration.javascript", { fg = "#6E56AF", bold = true })
hi("@keyword.declaration.typescript", { fg = "#6E56AF", bold = true })

-- const specifically — make it pop more than let
hi("@keyword.storage", { fg = "#8A72C8", bold = true })

-- Control flow: if else switch case break continue return
hi("@keyword.conditional", { fg = "#A994E0", bold = true })
hi("@keyword.conditional.javascript", { fg = "#A994E0", bold = true })
hi("@keyword.conditional.typescript", { fg = "#A994E0", bold = true })

-- Loops: for while do
hi("@keyword.repeat", { fg = "#A994E0", bold = true })
hi("@keyword.repeat.javascript", { fg = "#A994E0", bold = true })
hi("@keyword.repeat.typescript", { fg = "#A994E0", bold = true })

-- Return keyword
hi("@keyword.return", { fg = "#C4B0F0", bold = true })
hi("@keyword.return.javascript", { fg = "#C4B0F0", bold = true })
hi("@keyword.return.typescript", { fg = "#C4B0F0", bold = true })

-- import export default from as
hi("@keyword.import", { fg = "#73D216", bold = true })
hi("@keyword.import.javascript", { fg = "#73D216", bold = true })
hi("@keyword.import.typescript", { fg = "#73D216", bold = true })
hi("@include", { fg = "#73D216", bold = true })

-- async await
hi("@keyword.coroutine", { fg = "#D4B860", bold = true })
hi("@keyword.coroutine.javascript", { fg = "#D4B860", bold = true })
hi("@keyword.coroutine.typescript", { fg = "#D4B860", bold = true })

-- typeof instanceof void delete in of new throw
hi("@keyword.operator", { fg = "#8A72C8" })
hi("@keyword.operator.javascript", { fg = "#8A72C8" })
hi("@keyword.operator.typescript", { fg = "#8A72C8" })

-- try catch finally
hi("@keyword.exception", { fg = "#D9534F", bold = true })
hi("@keyword.exception.javascript", { fg = "#D9534F", bold = true })
hi("@keyword.exception.typescript", { fg = "#D9534F", bold = true })

-- class extends implements
hi("@keyword.class", { fg = "#61538D", bold = true })
hi("@keyword", { fg = "#6E56AF" })
hi("@keyword.javascript", { fg = "#6E56AF" })
hi("@keyword.typescript", { fg = "#6E56AF" })

-- TS-specific: type interface enum namespace declare abstract
hi("@keyword.type", { fg = "#61538D", bold = true })
hi("@keyword.type.typescript", { fg = "#61538D", bold = true })
hi("@keyword.modifier", { fg = "#61538D", italic = true }) -- public private protected readonly

-- ═══════════════════════════════════════════════════════════════════════════
--  JAVASCRIPT / TYPESCRIPT — IDENTIFIERS
-- ═══════════════════════════════════════════════════════════════════════════

-- Regular variables
hi("@variable", { fg = "#DDDAEC" })
hi("@variable.javascript", { fg = "#DDDAEC" })
hi("@variable.typescript", { fg = "#DDDAEC" })

-- Parameters
hi("@variable.parameter", { fg = "#C4B0F0", italic = true })
hi("@variable.parameter.javascript", { fg = "#C4B0F0", italic = true })
hi("@variable.parameter.typescript", { fg = "#C4B0F0", italic = true })

-- Object members / properties
hi("@variable.member", { fg = "#A994E0" })
hi("@variable.member.javascript", { fg = "#A994E0" })
hi("@variable.member.typescript", { fg = "#A994E0" })

-- Builtin vars: this super arguments globalThis
hi("@variable.builtin", { fg = "#8A72C8", italic = true })
hi("@variable.builtin.javascript", { fg = "#8A72C8", italic = true })
hi("@variable.builtin.typescript", { fg = "#8A72C8", italic = true })

-- Functions
hi("@function", { fg = "#73D216", bold = true })
hi("@function.javascript", { fg = "#73D216", bold = true })
hi("@function.typescript", { fg = "#73D216", bold = true })
hi("@function.call", { fg = "#73D216" })
hi("@function.call.javascript", { fg = "#73D216" })
hi("@function.call.typescript", { fg = "#73D216" })
hi("@function.builtin", { fg = "#4EB8C8", bold = true })
hi("@function.builtin.javascript", { fg = "#4EB8C8", bold = true })
hi("@function.builtin.typescript", { fg = "#4EB8C8", bold = true })
hi("@function.method", { fg = "#73D216" })
hi("@function.method.call", { fg = "#73D216" })

-- Arrow functions get italic
hi("@function.arrow", { fg = "#73D216", italic = true })
hi("@function.arrow.javascript", { fg = "#73D216", italic = true })

-- Constructors
hi("@constructor", { fg = "#61538D", bold = true })
hi("@constructor.javascript", { fg = "#61538D", bold = true })
hi("@constructor.typescript", { fg = "#61538D", bold = true })

-- Type names (TS)
hi("@type", { fg = "#61538D" })
hi("@type.typescript", { fg = "#61538D" })
hi("@type.builtin", { fg = "#54487A", italic = true })
hi("@type.builtin.typescript", { fg = "#54487A", italic = true })
hi("@type.definition", { fg = "#61538D", bold = true })

-- Property access: obj.PROP
hi("@property", { fg = "#A994E0" })
hi("@property.javascript", { fg = "#A994E0" })
hi("@property.typescript", { fg = "#A994E0" })

-- ═══════════════════════════════════════════════════════════════════════════
--  JAVASCRIPT / TYPESCRIPT — LITERALS
-- ═══════════════════════════════════════════════════════════════════════════
hi("@string", { fg = "#4A8A0E" })
hi("@string.javascript", { fg = "#4A8A0E" })
hi("@string.typescript", { fg = "#4A8A0E" })
hi("@string.special", { fg = "#73D216" }) -- template literal
hi("@string.special.javascript", { fg = "#73D216" }) -- `${expr}`
hi("@string.regex", { fg = "#C97B30" })
hi("@string.regex.javascript", { fg = "#C97B30" })
hi("@string.escape", { fg = "#4EB8C8" })

hi("@number", { fg = "#D4B860" })
hi("@number.javascript", { fg = "#D4B860" })
hi("@number.typescript", { fg = "#D4B860" })
hi("@number.float", { fg = "#D4B860" })

hi("@boolean", { fg = "#8A72C8", bold = true })
hi("@boolean.javascript", { fg = "#8A72C8", bold = true })
hi("@boolean.typescript", { fg = "#8A72C8", bold = true })

hi("@constant", { fg = "#C4B0F0" })
hi("@constant.javascript", { fg = "#C4B0F0" })
hi("@constant.typescript", { fg = "#C4B0F0" })
hi("@constant.builtin", { fg = "#8A72C8", italic = true }) -- null undefined NaN Infinity
hi("@constant.builtin.javascript", { fg = "#8A72C8", italic = true })
hi("@constant.builtin.typescript", { fg = "#8A72C8", italic = true })

hi("@comment", { fg = "#54487A", italic = true })
hi("@comment.javascript", { fg = "#54487A", italic = true })
hi("@comment.typescript", { fg = "#54487A", italic = true })
hi("@comment.documentation", { fg = "#61538D", italic = true }) -- JSDoc

-- ═══════════════════════════════════════════════════════════════════════════
--  JAVASCRIPT / TYPESCRIPT — OPERATORS & PUNCTUATION
-- ═══════════════════════════════════════════════════════════════════════════
hi("@operator", { fg = "#6E56AF" })
hi("@operator.javascript", { fg = "#6E56AF" })
hi("@operator.typescript", { fg = "#6E56AF" })

hi("@punctuation.bracket", { fg = "#61538D" })
hi("@punctuation.bracket.javascript", { fg = "#61538D" })
hi("@punctuation.bracket.typescript", { fg = "#61538D" })
hi("@punctuation.delimiter", { fg = "#54487A" })
hi("@punctuation.delimiter.javascript", { fg = "#54487A" })
hi("@punctuation.delimiter.typescript", { fg = "#54487A" })
hi("@punctuation.special", { fg = "#6E56AF", bold = true }) -- template ${
hi("@punctuation.special.javascript", { fg = "#6E56AF", bold = true })

-- ═══════════════════════════════════════════════════════════════════════════
--  IMPORTS — module path string gets a different shade
-- ═══════════════════════════════════════════════════════════════════════════
hi("@string.special.path", { fg = "#73D216", underline = true })
hi("@string.special.path.javascript", { fg = "#73D216", underline = true })
hi("@string.special.path.typescript", { fg = "#73D216", underline = true })
hi("@module", { fg = "#73D216" })
hi("@module.javascript", { fg = "#73D216" })
hi("@module.typescript", { fg = "#73D216" })
hi("@namespace", { fg = "#61538D" })

-- ═══════════════════════════════════════════════════════════════════════════
--  CSS — EVERYTHING
-- ═══════════════════════════════════════════════════════════════════════════

-- Selectors
hi("@selector.css", { fg = "#6E56AF", bold = true })
hi("@type.css", { fg = "#6E56AF", bold = true }) -- element selectors: div, span, p
hi("@type.tag.css", { fg = "#6E56AF", bold = true })

-- Class and ID selectors
hi("@type.selector.css", { fg = "#8A72C8", bold = true })
hi("@string.selector.css", { fg = "#A994E0" })

-- Properties: color, background, font-size etc.
hi("@property.css", { fg = "#A994E0" })
hi("@property.id.css", { fg = "#C4B0F0", bold = true })
hi("@property.class.css", { fg = "#8A72C8" })

-- Values
hi("@string.css", { fg = "#4A8A0E" })
hi("@number.css", { fg = "#D4B860" })
hi("@float.css", { fg = "#D4B860" })
hi("@number.percentage.css", { fg = "#D4B860", italic = true })

-- Units: px em rem vh vw etc.
hi("@keyword.unit.css", { fg = "#C97B30" })
hi("@keyword.css", { fg = "#6E56AF", italic = true }) -- @media @keyframes @import

-- Color values: #hex, rgb(), hsl()
hi("@constant.css", { fg = "#73D216" })
hi("@function.css", { fg = "#4EB8C8" }) -- rgb() calc() var() etc.
hi("@variable.css", { fg = "#C4B0F0", italic = true }) -- --custom-property

-- Pseudo-classes and pseudo-elements: :hover ::before
hi("@type.pseudo.css", { fg = "#61538D", italic = true })

-- Important / At-rules
hi("@keyword.important.css", { fg = "#D9534F", bold = true })

-- Punctuation
hi("@punctuation.delimiter.css", { fg = "#54487A" })
hi("@punctuation.bracket.css", { fg = "#61538D" })

-- Comments
hi("@comment.css", { fg = "#54487A", italic = true })

-- ═══════════════════════════════════════════════════════════════════════════
--  HTML (shared with Svelte templates)
-- ═══════════════════════════════════════════════════════════════════════════
hi("@tag", { fg = "#61538D", bold = true })
hi("@tag.html", { fg = "#61538D", bold = true })
hi("@tag.delimiter", { fg = "#54487A" })
hi("@tag.delimiter.html", { fg = "#54487A" })
hi("@tag.attribute", { fg = "#DDDAEC" })
hi("@tag.attribute.html", { fg = "#DDDAEC" })
hi("@tag.attribute.name.html", { fg = "#A994E0" }) -- attribute key
hi("@string.html", { fg = "#4A8A0E" }) -- attribute value

-- ═══════════════════════════════════════════════════════════════════════════
--  SVELTE — DIRECTIVES & CONTROL FLOW
-- ═══════════════════════════════════════════════════════════════════════════
hi("@tag.svelte", { fg = "#6E56AF", bold = true })
hi("@tag.delimiter.svelte", { fg = "#54487A" })
hi("@tag.attribute.svelte", { fg = "#DDDAEC" })
hi("@tag.attribute.name.svelte", { fg = "#A994E0", italic = true })
hi("@tag.builtin.svelte", { fg = "#73D216", bold = true, italic = true }) -- <svelte:*>

-- class:active  bind:value  on:click  use:action  let:item
hi("@attribute.svelte", { fg = "#61538D", italic = true })
hi("@keyword.directive.on.svelte", { fg = "#D9534F", bold = true })
hi("@keyword.directive.bind.svelte", { fg = "#6E56AF", bold = true })
hi("@keyword.directive.use.svelte", { fg = "#73D216", bold = true })
hi("@keyword.directive.transition.svelte", { fg = "#8A72C8", italic = true })
hi("@keyword.directive.animate.svelte", { fg = "#8A72C8", italic = true })
hi("@keyword.directive.class.svelte", { fg = "#61538D", italic = true })
hi("@keyword.directive.let.svelte", { fg = "#A994E0", italic = true })

-- {#if} {#each} {#await} {#key} {:else} {/if}
hi("@keyword.control.svelte", { fg = "#6E56AF", bold = true })
hi("@keyword.control.end.svelte", { fg = "#54487A", bold = true })
hi("@keyword.control.else.svelte", { fg = "#61538D", bold = true })

-- { expressions }
hi("@punctuation.special.svelte", { fg = "#6E56AF", bold = true })
hi("@embedded.svelte", { fg = "#DDDAEC" })

-- $: reactive, $store references
hi("@label.svelte", { fg = "#D9534F", bold = true })
hi("@variable.svelte_store.svelte", { fg = "#8A72C8", italic = true })

-- ═══════════════════════════════════════════════════════════════════════════
--  LEGACY / FALLBACK  (non-treesitter or partial parsers)
-- ═══════════════════════════════════════════════════════════════════════════
hi("Keyword", { fg = "#6E56AF", bold = true })
hi("Statement", { fg = "#6E56AF" })
hi("Conditional", { fg = "#A994E0", bold = true })
hi("Repeat", { fg = "#A994E0", bold = true })
hi("Include", { fg = "#73D216", bold = true })
hi("Define", { fg = "#73D216" })
hi("StorageClass", { fg = "#8A72C8", bold = true })
hi("Structure", { fg = "#61538D", bold = true })
hi("Type", { fg = "#61538D" })
hi("TypeDef", { fg = "#61538D", bold = true })
hi("Function", { fg = "#73D216", bold = true })
hi("Identifier", { fg = "#DDDAEC" })
hi("String", { fg = "#4A8A0E" })
hi("Number", { fg = "#D4B860" })
hi("Float", { fg = "#D4B860" })
hi("Boolean", { fg = "#8A72C8", bold = true })
hi("Constant", { fg = "#C4B0F0" })
hi("Special", { fg = "#4EB8C8" })
hi("SpecialChar", { fg = "#4EB8C8" })
hi("Operator", { fg = "#6E56AF" })
hi("Delimiter", { fg = "#54487A" })
hi("Comment", { fg = "#54487A", italic = true })
hi("Todo", { fg = "#D4B860", bold = true })
hi("Error", { fg = "#D9534F", bold = true })
hi("PreProc", { fg = "#73D216" })

-- ═══════════════════════════════════════════════════════════════════════════
--  DIAGNOSTICS
-- ═══════════════════════════════════════════════════════════════════════════
hi("DiagnosticError", { fg = "#D9534F" })
hi("DiagnosticWarn", { fg = "#C97B30" })
hi("DiagnosticInfo", { fg = "#6E56AF" })
hi("DiagnosticHint", { fg = "#61538D" })
hi("DiagnosticUnnecessary", { fg = "#54487A", italic = true })
hi("DiagnosticUnderlineError", { undercurl = true, sp = "#D9534F" })
hi("DiagnosticUnderlineWarn", { undercurl = true, sp = "#C97B30" })
hi("DiagnosticUnderlineInfo", { undercurl = true, sp = "#6E56AF" })
hi("DiagnosticUnderlineHint", { undercurl = true, sp = "#61538D" })
hi("DiagnosticVirtualTextError", { fg = "#D9534F", bg = "#1A0A0A", italic = true })
hi("DiagnosticVirtualTextWarn", { fg = "#C97B30", bg = "#1A1200", italic = true })
hi("DiagnosticVirtualTextInfo", { fg = "#6E56AF", bg = "#100E1A", italic = true })
hi("DiagnosticVirtualTextHint", { fg = "#54487A", bg = "#0E0C16", italic = true })
