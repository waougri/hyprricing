-- =============================================================================
-- gentoo.nvim  –  v2 "Deep Edition"
-- A production-grade dark colorscheme rooted in the Gentoo Linux brand palette.
--
-- Design contract (every rule is intentional, not accidental):
--
--   PURPLE  → language structure: keywords, control-flow, function names
--   BLUE    → types, shapes, modules, namespaces, constructors
--   GREEN   → string data  (Gentoo brand green — instantly iconic)
--   ORANGE  → literal values: numbers, booleans, @variable.builtin
--   CYAN    → operators, constants, builtins, escapes
--   YELLOW  → labels, warnings, diff-change  (warning cadence)
--   RED     → errors, exceptions, deletion    (error cadence)
--   MAGENTA → decorators, special constructs, regex, symbols
--
--   italic  → passive / contextual  (comments, parameters, modifiers)
--   bold    → declaration / emphasis (headings, selected items)
--
-- Coverage:
--   • Core editor UI (every group)
--   • Traditional :syntax groups
--   • Treesitter  – all standard + extended captures
--   • LSP semantic tokens + all diagnostic variants
--   • Diff / Git / spelling
--   • Terminal (all 16 colors)
--   • Plugins: nvim-tree, neo-tree, telescope, fzf-lua, nvim-cmp, blink.cmp,
--     gitsigns, indent-blankline, lualine, trouble, which-key, mason,
--     dashboard, alpha, noice, nvim-notify, nvim-dap + dap-ui, lazy.nvim,
--     oil.nvim, flash.nvim, mini.nvim suite, render-markdown, todo-comments,
--     snacks.nvim, headlines, aerial, barbecue/winbar, nvim-scrollbar,
--     nvim-ufo (folds), satellite.nvim, dropbar.nvim
-- =============================================================================

if vim.g.colors_name then vim.cmd("hi clear") end
if vim.fn.exists("syntax_on") == 1 then vim.cmd("syntax reset") end

vim.o.background       = "dark"
vim.o.termguicolors    = true
vim.g.colors_name      = "gentoo"

-- =============================================================================
-- PALETTE
-- Gentoo official: #54487A  #61538D  #6E56AF  #DDDAEC  #DDDFFF
--                  #73D216  #D9534F
-- Extended to form a complete, coherent dark theme.
-- =============================================================================
local c = {
  -- ── Backgrounds (ascending luminosity, all carry a purple undertone) ───────
  bg_hard  = "#09091A",   -- hardest variant (transparent-bg fallback)
  bg0      = "#0E0E1E",   -- main editor background
  bg1      = "#161626",   -- statusline / inactive panes / sidebar
  bg2      = "#1E1E32",   -- cursorline / visual selection base
  bg3      = "#27273F",   -- popup / menu background
  bg4      = "#30304C",   -- active popup item / hover
  bg_float = "#141424",   -- floating windows (slightly deeper than bg1)

  -- ── Foregrounds ────────────────────────────────────────────────────────────
  fg       = "#DDDAEC",   -- Gentoo brand grey — main text
  fg_hi    = "#EDEAF8",   -- slightly brighter for emphasis
  fg_dim   = "#9893B0",   -- secondary / inactive text
  fg_mute  = "#57546A",   -- barely visible (line-numbers, punctuation)

  -- ── Gentoo Purples ─────────────────────────────────────────────────────────
  pu0      = "#54487A",   -- official Gentoo purple (bg accents, borders)
  pu1      = "#61538D",   -- light purple  (borders, separators)
  pu2      = "#6E56AF",   -- medium purple (indent scope, selection hi)
  pu3      = "#8C6FC1",   -- bright purple (macros, preprocessor, @attribute)
  pu4      = "#B48BFF",   -- primary accent (keywords, function names)
  pu5      = "#DDDFFF",   -- Gentoo brand near-white (special identifiers)

  -- ── Gentoo Green (strings — the data layer) ────────────────────────────────
  green    = "#73D216",   -- official Gentoo green
  green_l  = "#90E83A",   -- brighter (matching text highlights)
  green_bg = "#162510",   -- diff-add background

  -- ── Type / shape layer ─────────────────────────────────────────────────────
  blue     = "#7DC8FF",   -- types, modules, constructors
  blue_d   = "#4A8EC2",   -- dimmer blue (inactive, secondary types)
  blue_bg  = "#0D1E30",   -- diff-change background

  -- ── Operator / constant layer ──────────────────────────────────────────────
  cyan     = "#4ECDC4",   -- operators, constants, string escapes
  cyan_l   = "#72E8E1",   -- brighter cyan (builtin functions)

  -- ── Literal value layer ────────────────────────────────────────────────────
  orange   = "#FF9E64",   -- numbers, booleans, self/this
  orange_d = "#CC7940",   -- dimmer orange

  -- ── Warning / label layer ──────────────────────────────────────────────────
  yellow   = "#E8C97D",   -- labels, diff-change fg, warnings

  -- ── Error / exception layer ────────────────────────────────────────────────
  red      = "#D9534F",   -- official Gentoo red
  red_l    = "#F07070",   -- brighter red (virtual text)
  red_bg   = "#250D0D",   -- diff-delete / error background

  -- ── Decorator / special layer ──────────────────────────────────────────────
  magenta  = "#C47ED4",   -- decorators, regex, special chars, symbols

  -- ── Structural ─────────────────────────────────────────────────────────────
  gray     = "#4A4860",
  border   = "#35334E",
  none     = "NONE",
}

-- Shorthand setter
local function hl(group, opts)
  vim.api.nvim_set_hl(0, group, opts or {})
end

-- =============================================================================
-- CORE EDITOR UI
-- =============================================================================

hl("Normal",          { fg = c.fg,      bg = c.bg0 })
hl("NormalFloat",     { fg = c.fg,      bg = c.bg_float })
hl("NormalNC",        { fg = c.fg_dim,  bg = c.bg0 })
hl("FloatBorder",     { fg = c.pu1,     bg = c.bg_float })
hl("FloatTitle",      { fg = c.pu4,     bg = c.bg_float, bold = true })
hl("FloatFooter",     { fg = c.fg_mute, bg = c.bg_float })

-- Cursor family
hl("Cursor",          { fg = c.bg0,     bg = c.pu4 })
hl("CursorIM",        { fg = c.bg0,     bg = c.cyan })
hl("TermCursor",      { fg = c.bg0,     bg = c.green })
hl("lCursor",         { link = "Cursor" })

-- Lines
hl("CursorLine",      { bg = c.bg2 })
hl("CursorColumn",    { bg = c.bg2 })
hl("ColorColumn",     { bg = c.bg2 })
hl("CursorLineNr",    { fg = c.pu4,     bold = true })
hl("LineNr",          { fg = c.fg_mute })
hl("LineNrAbove",     { fg = c.fg_mute })
hl("LineNrBelow",     { fg = c.fg_mute })
hl("SignColumn",      { fg = c.fg_mute, bg = c.bg0 })
hl("FoldColumn",      { fg = c.gray,    bg = c.bg0 })

-- Windows / splits
hl("VertSplit",       { fg = c.border })
hl("WinSeparator",    { fg = c.border })
hl("WinBar",          { fg = c.fg_dim,  bg = c.bg1, bold = true })
hl("WinBarNC",        { fg = c.fg_mute, bg = c.bg0 })

-- Statusline
hl("StatusLine",      { fg = c.fg,      bg = c.bg1 })
hl("StatusLineNC",    { fg = c.fg_mute, bg = c.bg0 })
hl("StatusLineTerm",  { link = "StatusLine" })
hl("StatusLineTermNC",{ link = "StatusLineNC" })

-- Tabs
hl("TabLine",         { fg = c.fg_dim,  bg = c.bg1 })
hl("TabLineFill",     { bg = c.bg0 })
hl("TabLineSel",      { fg = c.bg0,     bg = c.pu4, bold = true })

-- Popup menu (autocomplete)
hl("Pmenu",           { fg = c.fg,      bg = c.bg3 })
hl("PmenuSel",        { fg = c.bg0,     bg = c.pu4, bold = true })
hl("PmenuSbar",       { bg = c.bg3 })
hl("PmenuThumb",      { bg = c.pu1 })
hl("PmenuMatch",      { fg = c.green,   bold = true })
hl("PmenuMatchSel",   { fg = c.green_l, bg = c.pu4, bold = true })
hl("PmenuKind",       { fg = c.blue,    bg = c.bg3 })
hl("PmenuKindSel",    { fg = c.blue,    bg = c.pu4 })
hl("PmenuExtra",      { fg = c.fg_mute, bg = c.bg3 })
hl("PmenuExtraSel",   { fg = c.fg_dim,  bg = c.pu4 })

-- Wild / command-line completion
hl("WildMenu",        { fg = c.bg0,     bg = c.pu4, bold = true })

-- Titles and messages
hl("Title",           { fg = c.pu4,     bold = true })
hl("ModeMsg",         { fg = c.green,   bold = true })
hl("MsgArea",         { fg = c.fg })
hl("MsgSeparator",    { fg = c.border })
hl("MoreMsg",         { fg = c.cyan })
hl("ErrorMsg",        { fg = c.red,     bold = true })
hl("WarningMsg",      { fg = c.yellow,  bold = true })
hl("Question",        { fg = c.cyan })
hl("Directory",       { fg = c.blue })

-- Selection
hl("Visual",          { bg = c.bg4,     fg = c.fg_hi })
hl("VisualNOS",       { bg = c.bg4 })
hl("SelectionHighlight", { bg = c.bg3 })

-- Search
hl("Search",          { fg = c.bg0,     bg = c.yellow })
hl("IncSearch",       { fg = c.bg0,     bg = c.orange,  bold = true })
hl("CurSearch",       { link = "IncSearch" })
hl("Substitute",      { fg = c.bg0,     bg = c.red,     bold = true })

-- Misc structural
hl("MatchParen",      { fg = c.pu4,     bold = true,    underline = true })
hl("Folded",          { fg = c.fg_dim,  bg = c.bg2,     italic = true })
hl("Conceal",         { fg = c.pu3 })
hl("SpecialKey",      { fg = c.gray })
hl("NonText",         { fg = c.gray })
hl("Whitespace",      { fg = c.bg4 })
hl("EndOfBuffer",     { fg = c.bg1 })

-- Spelling
hl("SpellBad",        { undercurl = true, sp = c.red })
hl("SpellCap",        { undercurl = true, sp = c.yellow })
hl("SpellLocal",      { undercurl = true, sp = c.cyan })
hl("SpellRare",       { undercurl = true, sp = c.magenta })

-- Quickfix / location list
hl("QuickFixLine",    { bg = c.bg2,     bold = true })
hl("qfFileName",      { fg = c.blue })
hl("qfLineNr",        { fg = c.fg_mute })
hl("qfSeparator",     { fg = c.border })

-- Health check
hl("healthSuccess",   { fg = c.green,   bold = true })
hl("healthWarning",   { fg = c.yellow })
hl("healthError",     { fg = c.red })

-- =============================================================================
-- TRADITIONAL SYNTAX GROUPS
-- =============================================================================

hl("Comment",         { fg = c.fg_mute, italic = true })

-- Constants (the "value" cluster — cyan)
hl("Constant",        { fg = c.cyan })
hl("String",          { fg = c.green })
hl("Character",       { fg = c.green })
hl("Number",          { fg = c.orange })
hl("Boolean",         { fg = c.orange })
hl("Float",           { fg = c.orange })

-- Identifiers
hl("Identifier",      { fg = c.fg })
hl("Function",        { fg = c.pu4 })

-- Statements — purple (language control)
hl("Statement",       { fg = c.pu4 })
hl("Conditional",     { fg = c.pu4 })
hl("Repeat",          { fg = c.pu4 })
hl("Label",           { fg = c.yellow })    -- labels are NOT the same as keywords
hl("Operator",        { fg = c.cyan })
hl("Keyword",         { fg = c.pu4 })
hl("Exception",       { fg = c.red })       -- try/catch/throw = error cadence

-- Pre-processor — dimmer purple (meta layer)
hl("PreProc",         { fg = c.pu3 })
hl("Include",         { fg = c.pu3 })
hl("Define",          { fg = c.pu3 })
hl("Macro",           { fg = c.pu3 })
hl("PreCondit",       { fg = c.pu3 })

-- Types — blue (shape layer)
hl("Type",            { fg = c.blue })
hl("StorageClass",    { fg = c.pu3,  italic = true })  -- static/const/extern
hl("Structure",       { fg = c.blue })
hl("Typedef",         { fg = c.blue })

-- Special
hl("Special",         { fg = c.magenta })
hl("SpecialChar",     { fg = c.magenta })
hl("Tag",             { fg = c.pu4 })
hl("Delimiter",       { fg = c.fg_mute })
hl("SpecialComment",  { fg = c.fg_dim,  italic = true })
hl("Debug",           { fg = c.red })

-- Misc
hl("Underlined",      { fg = c.blue,  underline = true })
hl("Ignore",          { fg = c.gray })
hl("Error",           { fg = c.red,   bold = true })
hl("Todo",            { fg = c.bg0,   bg = c.orange, bold = true })
hl("Note",            { fg = c.bg0,   bg = c.blue,   bold = true })

-- =============================================================================
-- TREESITTER — full coverage
-- The @* namespaces follow the same color contract as the syntax groups above.
-- =============================================================================

-- ── Literals ──────────────────────────────────────────────────────────────────
hl("@boolean",                    { fg = c.orange })
hl("@number",                     { fg = c.orange })
hl("@number.float",               { fg = c.orange })
hl("@character",                  { fg = c.green })
hl("@character.special",          { fg = c.magenta })
hl("@string",                     { fg = c.green })
hl("@string.documentation",       { fg = c.green,   italic = true })
hl("@string.escape",              { fg = c.cyan })         -- \n, \t, etc.
hl("@string.regexp",              { fg = c.magenta })      -- /regex/
hl("@string.special",             { fg = c.magenta })
hl("@string.special.symbol",      { fg = c.magenta })
hl("@string.special.url",         { fg = c.blue,    underline = true })

-- ── Comments ──────────────────────────────────────────────────────────────────
hl("@comment",                    { fg = c.fg_mute, italic = true })
hl("@comment.documentation",      { fg = c.fg_dim,  italic = true })
hl("@comment.error",              { fg = c.red,     italic = true })
hl("@comment.warning",            { fg = c.yellow,  italic = true })
hl("@comment.todo",               { fg = c.orange,  bold = true, italic = true })
hl("@comment.note",               { fg = c.cyan,    bold = true, italic = true })

-- ── Variables ─────────────────────────────────────────────────────────────────
hl("@variable",                   { fg = c.fg })
hl("@variable.builtin",           { fg = c.orange,  italic = true }) -- self, this, super
hl("@variable.member",            { fg = c.fg })
hl("@variable.parameter",         { fg = c.fg_dim,  italic = true })
hl("@variable.parameter.builtin", { fg = c.orange,  italic = true })

-- ── Functions ─────────────────────────────────────────────────────────────────
hl("@function",                   { fg = c.pu4 })
hl("@function.builtin",           { fg = c.cyan_l,  italic = true }) -- print(), len()
hl("@function.call",              { fg = c.pu4 })
hl("@function.macro",             { fg = c.pu3 })
hl("@function.method",            { fg = c.pu4 })
hl("@function.method.call",       { fg = c.pu4 })

-- ── Keywords ──────────────────────────────────────────────────────────────────
hl("@keyword",                    { fg = c.pu4 })
hl("@keyword.conditional",        { fg = c.pu4 })
hl("@keyword.conditional.ternary",{ fg = c.cyan })         -- ? :
hl("@keyword.coroutine",          { fg = c.pu4,  italic = true })
hl("@keyword.debug",              { fg = c.red })
hl("@keyword.directive",          { fg = c.pu3 })
hl("@keyword.directive.define",   { fg = c.pu3 })
hl("@keyword.exception",          { fg = c.red })
hl("@keyword.function",           { fg = c.pu4 })
hl("@keyword.import",             { fg = c.pu3 })
hl("@keyword.modifier",           { fg = c.pu3,  italic = true }) -- public/private/static
hl("@keyword.operator",           { fg = c.cyan })
hl("@keyword.repeat",             { fg = c.pu4 })
hl("@keyword.return",             { fg = c.pu4,  italic = true }) -- return/yield are "exit" reads
hl("@keyword.storage",            { fg = c.pu3,  italic = true })
hl("@keyword.type",               { fg = c.pu4 })

-- ── Types ─────────────────────────────────────────────────────────────────────
hl("@type",                       { fg = c.blue })
hl("@type.builtin",               { fg = c.blue,    italic = true })
hl("@type.definition",            { fg = c.blue })
hl("@type.qualifier",             { fg = c.pu3,     italic = true })
hl("@constructor",                { fg = c.blue })

-- ── Modules / namespaces ──────────────────────────────────────────────────────
hl("@module",                     { fg = c.blue_d })
hl("@module.builtin",             { fg = c.blue_d,  italic = true })
hl("@namespace",                  { link = "@module" })

-- ── Constants ─────────────────────────────────────────────────────────────────
hl("@constant",                   { fg = c.cyan })
hl("@constant.builtin",           { fg = c.cyan,    italic = true })
hl("@constant.macro",             { fg = c.pu3 })

-- ── Labels, operators, punctuation ────────────────────────────────────────────
hl("@label",                      { fg = c.yellow })
hl("@operator",                   { fg = c.cyan })
hl("@punctuation.bracket",        { fg = c.fg_dim })
hl("@punctuation.delimiter",      { fg = c.fg_mute })
hl("@punctuation.special",        { fg = c.magenta })

-- ── Properties / attributes ───────────────────────────────────────────────────
hl("@property",                   { fg = c.fg })
hl("@attribute",                  { fg = c.pu3 })
hl("@attribute.builtin",          { fg = c.pu3,     italic = true })
hl("@conceal",                    { fg = c.pu3 })

-- ── Tags (HTML/JSX/XML) ───────────────────────────────────────────────────────
hl("@tag",                        { fg = c.pu4 })
hl("@tag.attribute",              { fg = c.blue })
hl("@tag.builtin",                { fg = c.pu4,     italic = true })
hl("@tag.delimiter",              { fg = c.fg_mute })

-- ── Markup (Markdown, Org, etc.) ──────────────────────────────────────────────
hl("@markup.heading",             { fg = c.pu4,     bold = true })
hl("@markup.heading.1",           { fg = c.pu4,     bold = true })
hl("@markup.heading.2",           { fg = c.blue,    bold = true })
hl("@markup.heading.3",           { fg = c.green,   bold = true })
hl("@markup.heading.4",           { fg = c.orange,  bold = true })
hl("@markup.heading.5",           { fg = c.cyan,    bold = true })
hl("@markup.heading.6",           { fg = c.magenta, bold = true })
hl("@markup.link",                { fg = c.blue,    underline = true })
hl("@markup.link.label",          { fg = c.cyan })
hl("@markup.link.url",            { fg = c.blue_d,  underline = true, italic = true })
hl("@markup.list",                { fg = c.pu3 })
hl("@markup.list.checked",        { fg = c.green })
hl("@markup.list.unchecked",      { fg = c.fg_mute })
hl("@markup.quote",               { fg = c.fg_dim,  italic = true })
hl("@markup.raw",                 { fg = c.green })
hl("@markup.raw.block",           { fg = c.green })
hl("@markup.strikethrough",       { fg = c.fg_mute, strikethrough = true })
hl("@markup.strong",              { fg = c.fg_hi,   bold = true })
hl("@markup.italic",              { fg = c.fg,      italic = true })
hl("@markup.underline",           { underline = true })
hl("@markup.math",                { fg = c.cyan })

-- ── Diff annotations ──────────────────────────────────────────────────────────
hl("@diff.plus",                  { fg = c.green })
hl("@diff.minus",                 { fg = c.red })
hl("@diff.delta",                 { fg = c.yellow })

-- ── Misc ──────────────────────────────────────────────────────────────────────
hl("@error",                      { fg = c.red })
hl("@none",                       {})

-- =============================================================================
-- LSP — DIAGNOSTICS
-- =============================================================================

-- Base (sign column + inline text)
hl("DiagnosticError",             { fg = c.red })
hl("DiagnosticWarn",              { fg = c.yellow })
hl("DiagnosticInfo",              { fg = c.blue })
hl("DiagnosticHint",              { fg = c.cyan })
hl("DiagnosticOk",                { fg = c.green })

-- Virtual text (end-of-line annotations)
hl("DiagnosticVirtualTextError",  { fg = c.red_l,   bg = c.red_bg,   italic = true })
hl("DiagnosticVirtualTextWarn",   { fg = c.yellow,  bg = "#251F0A",  italic = true })
hl("DiagnosticVirtualTextInfo",   { fg = c.blue,    bg = c.blue_bg,  italic = true })
hl("DiagnosticVirtualTextHint",   { fg = c.cyan,    bg = "#0A1E20",  italic = true })
hl("DiagnosticVirtualTextOk",     { fg = c.green,   bg = c.green_bg, italic = true })

-- Underlines
hl("DiagnosticUnderlineError",    { undercurl = true, sp = c.red })
hl("DiagnosticUnderlineWarn",     { undercurl = true, sp = c.yellow })
hl("DiagnosticUnderlineInfo",     { undercurl = true, sp = c.blue })
hl("DiagnosticUnderlineHint",     { undercurl = true, sp = c.cyan })
hl("DiagnosticUnderlineOk",       { undercurl = true, sp = c.green })

-- Sign column glyphs
hl("DiagnosticSignError",         { fg = c.red })
hl("DiagnosticSignWarn",          { fg = c.yellow })
hl("DiagnosticSignInfo",          { fg = c.blue })
hl("DiagnosticSignHint",          { fg = c.cyan })

-- Float window
hl("DiagnosticFloatingError",     { fg = c.red })
hl("DiagnosticFloatingWarn",      { fg = c.yellow })
hl("DiagnosticFloatingInfo",      { fg = c.blue })
hl("DiagnosticFloatingHint",      { fg = c.cyan })

-- Deprecated
hl("DiagnosticDeprecated",        { fg = c.fg_mute, strikethrough = true })
hl("DiagnosticUnnecessary",       { fg = c.fg_mute, italic = true })

-- LSP highlight references
hl("LspReferenceText",            { bg = c.bg3 })
hl("LspReferenceRead",            { bg = c.bg3 })
hl("LspReferenceWrite",           { bg = c.bg3, underline = true })
hl("LspSignatureActiveParameter", { fg = c.orange, underline = true })
hl("LspInlayHint",                { fg = c.fg_mute, bg = c.bg2, italic = true })
hl("LspCodeLens",                 { fg = c.fg_mute, italic = true })
hl("LspCodeLensSeparator",        { fg = c.border })

-- =============================================================================
-- LSP — SEMANTIC TOKENS
-- These layer on top of Treesitter and can override it per-token.
-- =============================================================================

hl("@lsp.type.boolean",           { link = "@boolean" })
hl("@lsp.type.builtinType",       { link = "@type.builtin" })
hl("@lsp.type.class",             { fg = c.blue })
hl("@lsp.type.comment",           { link = "@comment" })
hl("@lsp.type.decorator",         { fg = c.pu3 })
hl("@lsp.type.enum",              { fg = c.blue })
hl("@lsp.type.enumMember",        { fg = c.cyan })
hl("@lsp.type.event",             { fg = c.orange })
hl("@lsp.type.function",          { fg = c.pu4 })
hl("@lsp.type.interface",         { fg = c.blue,    italic = true })
hl("@lsp.type.keyword",           { fg = c.pu4 })
hl("@lsp.type.macro",             { fg = c.pu3 })
hl("@lsp.type.method",            { fg = c.pu4 })
hl("@lsp.type.modifier",          { fg = c.pu3,     italic = true })
hl("@lsp.type.namespace",         { fg = c.blue_d })
hl("@lsp.type.number",            { link = "@number" })
hl("@lsp.type.operator",          { link = "@operator" })
hl("@lsp.type.parameter",         { fg = c.fg_dim,  italic = true })
hl("@lsp.type.property",          { fg = c.fg })
hl("@lsp.type.regexp",            { fg = c.magenta })
hl("@lsp.type.string",            { link = "@string" })
hl("@lsp.type.struct",            { fg = c.blue })
hl("@lsp.type.type",              { fg = c.blue })
hl("@lsp.type.typeAlias",         { fg = c.blue })
hl("@lsp.type.typeParameter",     { fg = c.blue,    italic = true })
hl("@lsp.type.unresolvedReference",{ underdotted = true, sp = c.red })
hl("@lsp.type.variable",          { fg = c.fg })

-- Semantic token modifiers
hl("@lsp.mod.abstract",           { italic = true })
hl("@lsp.mod.async",              { italic = true })
hl("@lsp.mod.declaration",        { bold = true })
hl("@lsp.mod.defaultLibrary",     { italic = true })
hl("@lsp.mod.deprecated",         { strikethrough = true, fg = c.fg_mute })
hl("@lsp.mod.documentation",      { italic = true })
hl("@lsp.mod.modification",       { fg = c.orange })
hl("@lsp.mod.readonly",           { fg = c.cyan,    italic = true })
hl("@lsp.mod.static",             { italic = true })

-- =============================================================================
-- DIFF / GIT
-- Using semantic background tints matching the Gentoo brand palette.
-- =============================================================================

hl("DiffAdd",     { fg = c.green,  bg = c.green_bg })
hl("DiffChange",  { fg = c.yellow, bg = c.blue_bg })
hl("DiffDelete",  { fg = c.red,    bg = c.red_bg })
hl("DiffText",    { fg = c.bg0,    bg = c.yellow, bold = true })
hl("DiffAdded",   { link = "DiffAdd" })
hl("DiffRemoved", { link = "DiffDelete" })

-- =============================================================================
-- TERMINAL COLORS (all 16 ANSI slots)
-- =============================================================================

vim.g.terminal_color_0  = c.bg2        -- black
vim.g.terminal_color_1  = c.red        -- red
vim.g.terminal_color_2  = c.green      -- green
vim.g.terminal_color_3  = c.yellow     -- yellow
vim.g.terminal_color_4  = c.blue       -- blue
vim.g.terminal_color_5  = c.magenta    -- magenta
vim.g.terminal_color_6  = c.cyan       -- cyan
vim.g.terminal_color_7  = c.fg         -- white
vim.g.terminal_color_8  = c.fg_mute    -- bright black (dark grey)
vim.g.terminal_color_9  = c.red_l      -- bright red
vim.g.terminal_color_10 = c.green_l    -- bright green
vim.g.terminal_color_11 = "#F0D9A0"    -- bright yellow
vim.g.terminal_color_12 = "#9ECFFF"    -- bright blue
vim.g.terminal_color_13 = c.pu4        -- bright magenta
vim.g.terminal_color_14 = c.cyan_l     -- bright cyan
vim.g.terminal_color_15 = c.pu5        -- bright white (Gentoo near-white)

-- =============================================================================
-- PLUGINS
-- =============================================================================

-- ── nvim-tree ─────────────────────────────────────────────────────────────────
hl("NvimTreeNormal",              { fg = c.fg,      bg = c.bg1 })
hl("NvimTreeNormalFloat",         { fg = c.fg,      bg = c.bg_float })
hl("NvimTreeNormalNC",            { fg = c.fg_dim,  bg = c.bg1 })
hl("NvimTreeCursorLine",          { bg = c.bg2 })
hl("NvimTreeFolderIcon",          { fg = c.pu4 })
hl("NvimTreeFolderName",          { fg = c.blue })
hl("NvimTreeOpenedFolderName",    { fg = c.blue,    italic = true })
hl("NvimTreeEmptyFolderName",     { fg = c.fg_mute })
hl("NvimTreeSymlink",             { fg = c.cyan })
hl("NvimTreeSymlinkFolderName",   { fg = c.cyan })
hl("NvimTreeExecFile",            { fg = c.green,   bold = true })
hl("NvimTreeSpecialFile",         { fg = c.magenta, underline = true })
hl("NvimTreeImageFile",           { fg = c.orange })
hl("NvimTreeGitDirty",            { fg = c.orange })
hl("NvimTreeGitNew",              { fg = c.green })
hl("NvimTreeGitDeleted",          { fg = c.red })
hl("NvimTreeGitMerge",            { fg = c.magenta })
hl("NvimTreeGitRenamed",          { fg = c.yellow })
hl("NvimTreeGitStaged",           { fg = c.green_l })
hl("NvimTreeIndentMarker",        { fg = c.border })
hl("NvimTreeRootFolder",          { fg = c.pu4,     bold = true })
hl("NvimTreeWinSeparator",        { fg = c.border,  bg = c.bg1 })

-- ── neo-tree ──────────────────────────────────────────────────────────────────
hl("NeoTreeNormal",               { fg = c.fg,      bg = c.bg1 })
hl("NeoTreeNormalNC",             { fg = c.fg_dim,  bg = c.bg1 })
hl("NeoTreeDirectoryIcon",        { fg = c.pu4 })
hl("NeoTreeDirectoryName",        { fg = c.blue })
hl("NeoTreeFileName",             { fg = c.fg })
hl("NeoTreeFileIcon",             { fg = c.fg_dim })
hl("NeoTreeRootName",             { fg = c.pu4,     bold = true })
hl("NeoTreeGitAdded",             { fg = c.green })
hl("NeoTreeGitConflict",          { fg = c.red,     bold = true })
hl("NeoTreeGitDeleted",           { fg = c.red })
hl("NeoTreeGitModified",          { fg = c.orange })
hl("NeoTreeGitUntracked",         { fg = c.yellow })
hl("NeoTreeIndentMarker",         { fg = c.border })
hl("NeoTreeSymbolicLinkTarget",   { fg = c.cyan })
hl("NeoTreeTitleBar",             { fg = c.bg0,     bg = c.pu4, bold = true })

-- ── telescope.nvim ────────────────────────────────────────────────────────────
hl("TelescopeNormal",             { fg = c.fg,      bg = c.bg_float })
hl("TelescopeBorder",             { fg = c.pu1,     bg = c.bg_float })
hl("TelescopeTitle",              { fg = c.pu4,     bg = c.bg_float, bold = true })
hl("TelescopePromptNormal",       { fg = c.fg,      bg = c.bg3 })
hl("TelescopePromptBorder",       { fg = c.pu2,     bg = c.bg3 })
hl("TelescopePromptTitle",        { fg = c.bg0,     bg = c.pu4,      bold = true })
hl("TelescopePromptPrefix",       { fg = c.pu4,     bg = c.bg3 })
hl("TelescopePromptCounter",      { fg = c.fg_mute, bg = c.bg3 })
hl("TelescopeResultsNormal",      { fg = c.fg_dim,  bg = c.bg_float })
hl("TelescopeResultsBorder",      { fg = c.pu1,     bg = c.bg_float })
hl("TelescopeResultsTitle",       { fg = c.fg_mute, bg = c.bg_float })
hl("TelescopePreviewNormal",      { fg = c.fg,      bg = c.bg0 })
hl("TelescopePreviewBorder",      { fg = c.pu1,     bg = c.bg0 })
hl("TelescopePreviewTitle",       { fg = c.bg0,     bg = c.blue,     bold = true })
hl("TelescopeSelection",          { fg = c.fg_hi,   bg = c.bg3,      bold = true })
hl("TelescopeSelectionCaret",     { fg = c.pu4,     bg = c.bg3 })
hl("TelescopeMultiSelection",     { fg = c.orange,  bg = c.bg3 })
hl("TelescopeMatching",           { fg = c.green,   bold = true })

-- ── fzf-lua ───────────────────────────────────────────────────────────────────
hl("FzfLuaNormal",                { link = "NormalFloat" })
hl("FzfLuaBorder",                { link = "FloatBorder" })
hl("FzfLuaTitle",                 { link = "FloatTitle" })
hl("FzfLuaHeaderBind",            { fg = c.pu4 })
hl("FzfLuaHeaderText",            { fg = c.blue })
hl("FzfLuaPathColNr",             { fg = c.orange })
hl("FzfLuaPathLineNr",            { fg = c.yellow })
hl("FzfLuaBufName",               { fg = c.blue })
hl("FzfLuaBufNr",                 { fg = c.fg_mute })
hl("FzfLuaTabTitle",              { fg = c.pu4,     bold = true })

-- ── nvim-cmp ──────────────────────────────────────────────────────────────────
hl("CmpNormal",                   { link = "NormalFloat" })
hl("CmpBorder",                   { link = "FloatBorder" })
hl("CmpItemAbbr",                 { fg = c.fg })
hl("CmpItemAbbrMatch",            { fg = c.pu4,     bold = true })
hl("CmpItemAbbrMatchFuzzy",       { fg = c.green })
hl("CmpItemAbbrDeprecated",       { fg = c.fg_mute, strikethrough = true })
hl("CmpItemKind",                 { fg = c.blue })
hl("CmpItemKindText",             { fg = c.fg_dim })
hl("CmpItemKindFunction",         { fg = c.pu4 })
hl("CmpItemKindMethod",           { fg = c.pu4 })
hl("CmpItemKindConstructor",      { fg = c.blue })
hl("CmpItemKindField",            { fg = c.fg })
hl("CmpItemKindVariable",         { fg = c.fg })
hl("CmpItemKindClass",            { fg = c.blue })
hl("CmpItemKindInterface",        { fg = c.blue,    italic = true })
hl("CmpItemKindModule",           { fg = c.blue_d })
hl("CmpItemKindProperty",         { fg = c.fg })
hl("CmpItemKindUnit",             { fg = c.orange })
hl("CmpItemKindValue",            { fg = c.cyan })
hl("CmpItemKindEnum",             { fg = c.blue })
hl("CmpItemKindKeyword",          { fg = c.pu4 })
hl("CmpItemKindSnippet",          { fg = c.magenta })
hl("CmpItemKindColor",            { fg = c.orange })
hl("CmpItemKindFile",             { fg = c.blue })
hl("CmpItemKindReference",        { fg = c.cyan })
hl("CmpItemKindFolder",           { fg = c.blue })
hl("CmpItemKindEnumMember",       { fg = c.cyan })
hl("CmpItemKindConstant",         { fg = c.cyan })
hl("CmpItemKindStruct",           { fg = c.blue })
hl("CmpItemKindEvent",            { fg = c.orange })
hl("CmpItemKindOperator",         { fg = c.cyan })
hl("CmpItemKindTypeParameter",    { fg = c.blue,    italic = true })
hl("CmpItemMenu",                 { fg = c.fg_mute, italic = true })
hl("CmpGhostText",                { fg = c.fg_mute, italic = true })

-- ── blink.cmp (modern cmp replacement) ───────────────────────────────────────
hl("BlinkCmpMenu",                { link = "NormalFloat" })
hl("BlinkCmpMenuBorder",          { link = "FloatBorder" })
hl("BlinkCmpMenuSelection",       { fg = c.bg0,     bg = c.pu4,      bold = true })
hl("BlinkCmpScrollBarThumb",      { bg = c.pu1 })
hl("BlinkCmpScrollBarGutter",     { bg = c.bg3 })
hl("BlinkCmpLabel",               { fg = c.fg })
hl("BlinkCmpLabelMatch",          { fg = c.pu4,     bold = true })
hl("BlinkCmpLabelDetail",         { fg = c.fg_mute })
hl("BlinkCmpLabelDescription",    { fg = c.fg_mute, italic = true })
hl("BlinkCmpLabelDeprecated",     { fg = c.fg_mute, strikethrough = true })
hl("BlinkCmpKind",                { fg = c.blue })
hl("BlinkCmpKindFunction",        { fg = c.pu4 })
hl("BlinkCmpKindMethod",          { fg = c.pu4 })
hl("BlinkCmpKindClass",           { fg = c.blue })
hl("BlinkCmpKindInterface",       { fg = c.blue,    italic = true })
hl("BlinkCmpKindVariable",        { fg = c.fg })
hl("BlinkCmpKindField",           { fg = c.fg })
hl("BlinkCmpKindKeyword",         { fg = c.pu4 })
hl("BlinkCmpKindSnippet",         { fg = c.magenta })
hl("BlinkCmpKindModule",          { fg = c.blue_d })
hl("BlinkCmpKindConstant",        { fg = c.cyan })
hl("BlinkCmpDoc",                 { link = "NormalFloat" })
hl("BlinkCmpDocBorder",           { link = "FloatBorder" })
hl("BlinkCmpGhostText",           { fg = c.fg_mute, italic = true })
hl("BlinkCmpSignatureHelp",       { link = "NormalFloat" })
hl("BlinkCmpSignatureHelpBorder", { link = "FloatBorder" })
hl("BlinkCmpSignatureHelpActiveParameter", { fg = c.orange, underline = true })

-- ── gitsigns.nvim ─────────────────────────────────────────────────────────────
hl("GitSignsAdd",                 { fg = c.green })
hl("GitSignsChange",              { fg = c.yellow })
hl("GitSignsDelete",              { fg = c.red })
hl("GitSignsChangedelete",        { fg = c.orange })
hl("GitSignsUntracked",           { fg = c.blue_d })
hl("GitSignsAddNr",               { link = "GitSignsAdd" })
hl("GitSignsChangeNr",            { link = "GitSignsChange" })
hl("GitSignsDeleteNr",            { link = "GitSignsDelete" })
hl("GitSignsAddLn",               { bg = c.green_bg })
hl("GitSignsChangeLn",            { bg = c.blue_bg })
hl("GitSignsDeleteLn",            { bg = c.red_bg })
hl("GitSignsCurrentLineBlame",    { fg = c.fg_mute, italic = true })

-- ── indent-blankline (ibl) v3 ─────────────────────────────────────────────────
hl("IblIndent",                   { fg = c.bg3,     nocombine = true })
hl("IblScope",                    { fg = c.pu2,     nocombine = true })
hl("IblWhitespace",               { fg = c.bg3 })
-- Legacy (v2) fallback
hl("IndentBlanklineChar",         { link = "IblIndent" })
hl("IndentBlanklineContextChar",  { link = "IblScope" })

-- ── lualine ───────────────────────────────────────────────────────────────────
hl("lualine_a_normal",            { fg = c.bg0,     bg = c.pu4,      bold = true })
hl("lualine_b_normal",            { fg = c.fg,      bg = c.bg3 })
hl("lualine_c_normal",            { fg = c.fg_dim,  bg = c.bg1 })
hl("lualine_a_insert",            { fg = c.bg0,     bg = c.green,    bold = true })
hl("lualine_b_insert",            { fg = c.fg,      bg = c.bg3 })
hl("lualine_c_insert",            { fg = c.fg_dim,  bg = c.bg1 })
hl("lualine_a_visual",            { fg = c.bg0,     bg = c.orange,   bold = true })
hl("lualine_b_visual",            { fg = c.fg,      bg = c.bg3 })
hl("lualine_c_visual",            { fg = c.fg_dim,  bg = c.bg1 })
hl("lualine_a_replace",           { fg = c.bg0,     bg = c.red,      bold = true })
hl("lualine_b_replace",           { fg = c.fg,      bg = c.bg3 })
hl("lualine_c_replace",           { fg = c.fg_dim,  bg = c.bg1 })
hl("lualine_a_command",           { fg = c.bg0,     bg = c.yellow,   bold = true })
hl("lualine_a_inactive",          { fg = c.fg_mute, bg = c.bg1 })
hl("lualine_b_inactive",          { fg = c.fg_mute, bg = c.bg1 })
hl("lualine_c_inactive",          { fg = c.fg_mute, bg = c.bg0 })

-- ── trouble.nvim ──────────────────────────────────────────────────────────────
hl("TroubleNormal",               { fg = c.fg,      bg = c.bg1 })
hl("TroubleNormalNC",             { fg = c.fg_dim,  bg = c.bg1 })
hl("TroubleText",                 { fg = c.fg_dim })
hl("TroubleCount",                { fg = c.pu4 })
hl("TroubleFile",                 { fg = c.blue,    bold = true })
hl("TroublePos",                  { fg = c.fg_mute })
hl("TroubleLocation",             { fg = c.fg_mute })
hl("TroubleIndent",               { fg = c.border })
hl("TroubleFoldIcon",             { fg = c.pu4 })
hl("TroubleSignError",            { link = "DiagnosticSignError" })
hl("TroubleSignWarn",             { link = "DiagnosticSignWarn" })
hl("TroubleSignInfo",             { link = "DiagnosticSignInfo" })
hl("TroubleSignHint",             { link = "DiagnosticSignHint" })

-- ── which-key.nvim ────────────────────────────────────────────────────────────
hl("WhichKey",                    { fg = c.pu4 })
hl("WhichKeyGroup",               { fg = c.blue })
hl("WhichKeyDesc",                { fg = c.fg })
hl("WhichKeySeparator",           { fg = c.border })
hl("WhichKeyValue",               { fg = c.fg_mute })
hl("WhichKeyBorder",              { link = "FloatBorder" })
hl("WhichKeyTitle",               { link = "FloatTitle" })
hl("WhichKeyNormal",              { link = "NormalFloat" })

-- ── mason.nvim ────────────────────────────────────────────────────────────────
hl("MasonNormal",                 { link = "NormalFloat" })
hl("MasonHeader",                 { fg = c.bg0,     bg = c.pu4,      bold = true })
hl("MasonHeaderSecondary",        { fg = c.bg0,     bg = c.blue,     bold = true })
hl("MasonHighlight",              { fg = c.pu4 })
hl("MasonHighlightBlock",         { fg = c.bg0,     bg = c.pu4 })
hl("MasonHighlightBlockBold",     { fg = c.bg0,     bg = c.pu4,      bold = true })
hl("MasonHighlightSecondary",     { fg = c.green })
hl("MasonHighlightBlockSecondary",{ fg = c.bg0,     bg = c.green })
hl("MasonMuted",                  { fg = c.fg_mute })
hl("MasonMutedBlock",             { fg = c.fg_mute, bg = c.bg3 })
hl("MasonLink",                   { fg = c.blue,    underline = true })
hl("MasonError",                  { fg = c.red })
hl("MasonWarning",                { fg = c.yellow })
hl("MasonHeading",                { fg = c.pu4,     bold = true })

-- ── dashboard.nvim ────────────────────────────────────────────────────────────
hl("DashboardHeader",             { fg = c.pu4 })
hl("DashboardDesc",               { fg = c.fg_dim })
hl("DashboardKey",                { fg = c.pu4,     bold = true })
hl("DashboardIcon",               { fg = c.pu4 })
hl("DashboardShortcut",           { fg = c.green })
hl("DashboardMruIcon",            { fg = c.blue })
hl("DashboardMruTitle",           { fg = c.blue,    bold = true })
hl("DashboardProjectTitle",       { fg = c.orange,  bold = true })
hl("DashboardProjectTitleIcon",   { fg = c.orange })
hl("DashboardFooter",             { fg = c.fg_mute, italic = true })
-- alpha.nvim
hl("AlphaHeader",                 { link = "DashboardHeader" })
hl("AlphaButtons",                { fg = c.blue })
hl("AlphaShortcut",               { fg = c.green })
hl("AlphaFooter",                 { link = "DashboardFooter" })

-- ── noice.nvim ────────────────────────────────────────────────────────────────
hl("NoiceCmdline",                { fg = c.fg,      bg = c.bg3 })
hl("NoiceCmdlineIcon",            { fg = c.pu4 })
hl("NoiceCmdlineIconSearch",      { fg = c.yellow })
hl("NoiceCmdlinePopup",           { fg = c.fg,      bg = c.bg3 })
hl("NoiceCmdlinePopupBorder",     { fg = c.pu2 })
hl("NoiceCmdlinePopupBorderSearch",{ fg = c.yellow })
hl("NoiceCmdlinePopupTitle",      { fg = c.pu4,     bold = true })
hl("NoiceConfirm",                { link = "NormalFloat" })
hl("NoiceConfirmBorder",          { fg = c.pu2 })
hl("NoiceFormatProgressTodo",     { fg = c.fg_mute, bg = c.bg3 })
hl("NoiceFormatProgressDone",     { fg = c.green,   bg = c.bg3 })
hl("NoiceLspProgressTitle",       { fg = c.pu4 })
hl("NoiceLspProgressClient",      { fg = c.blue })
hl("NoiceLspProgressSpinner",     { fg = c.green })
hl("NoicePopup",                  { link = "NormalFloat" })
hl("NoicePopupBorder",            { link = "FloatBorder" })
hl("NoiceMini",                   { fg = c.fg_dim,  bg = c.bg1 })
hl("NoiceSplit",                  { fg = c.fg,      bg = c.bg1 })
hl("NoiceSplitBorder",            { link = "FloatBorder" })
hl("NoiceScrollbar",              { bg = c.bg3 })
hl("NoiceScrollbarThumb",         { bg = c.pu1 })

-- ── nvim-notify ───────────────────────────────────────────────────────────────
hl("NotifyERRORBorder",           { fg = c.red })
hl("NotifyERRORIcon",             { fg = c.red })
hl("NotifyERRORTitle",            { fg = c.red,     bold = true })
hl("NotifyERRORBody",             { fg = c.fg,      bg = c.bg_float })
hl("NotifyWARNBorder",            { fg = c.yellow })
hl("NotifyWARNIcon",              { fg = c.yellow })
hl("NotifyWARNTitle",             { fg = c.yellow,  bold = true })
hl("NotifyWARNBody",              { fg = c.fg,      bg = c.bg_float })
hl("NotifyINFOBorder",            { fg = c.blue })
hl("NotifyINFOIcon",              { fg = c.blue })
hl("NotifyINFOTitle",             { fg = c.blue,    bold = true })
hl("NotifyINFOBody",              { fg = c.fg,      bg = c.bg_float })
hl("NotifyDEBUGBorder",           { fg = c.gray })
hl("NotifyDEBUGIcon",             { fg = c.gray })
hl("NotifyDEBUGTitle",            { fg = c.gray })
hl("NotifyDEBUGBody",             { fg = c.fg,      bg = c.bg_float })
hl("NotifyTRACEBorder",           { fg = c.pu2 })
hl("NotifyTRACEIcon",             { fg = c.pu2 })
hl("NotifyTRACETitle",            { fg = c.pu2 })
hl("NotifyTRACEBody",             { fg = c.fg,      bg = c.bg_float })

-- ── nvim-dap + nvim-dap-ui ────────────────────────────────────────────────────
hl("DapBreakpoint",               { fg = c.red })
hl("DapBreakpointCondition",      { fg = c.orange })
hl("DapBreakpointRejected",       { fg = c.fg_mute, italic = true })
hl("DapLogPoint",                 { fg = c.blue })
hl("DapStopped",                  { fg = c.green,   bg = c.green_bg })
hl("DapStoppedLine",              { bg = c.green_bg })
hl("DapUIScope",                  { fg = c.pu4 })
hl("DapUIType",                   { fg = c.blue })
hl("DapUIValue",                  { fg = c.cyan })
hl("DapUIFrameName",              { fg = c.fg })
hl("DapUIThread",                 { fg = c.green })
hl("DapUIWatchesEmpty",           { fg = c.fg_mute, italic = true })
hl("DapUIWatchesError",           { fg = c.red })
hl("DapUIWatchesValue",           { fg = c.cyan })
hl("DapUIBreakpointsCurrentLine", { fg = c.green,   bold = true })
hl("DapUIBreakpointsDisabledLine",{ fg = c.fg_mute })
hl("DapUIBreakpointsInfo",        { fg = c.blue })
hl("DapUIBreakpointsPath",        { fg = c.blue_d })
hl("DapUIFloatBorder",            { link = "FloatBorder" })
hl("DapUIFloatNormal",            { link = "NormalFloat" })

-- ── lazy.nvim ─────────────────────────────────────────────────────────────────
hl("LazyNormal",                  { link = "NormalFloat" })
hl("LazyBorder",                  { link = "FloatBorder" })
hl("LazyTitle",                   { link = "FloatTitle" })
hl("LazyButton",                  { fg = c.fg,      bg = c.bg3 })
hl("LazyButtonActive",            { fg = c.bg0,     bg = c.pu4,      bold = true })
hl("LazyH1",                      { fg = c.pu4,     bold = true })
hl("LazyH2",                      { fg = c.blue,    bold = true })
hl("LazyComment",                 { fg = c.fg_mute, italic = true })
hl("LazyProgressDone",            { fg = c.green })
hl("LazyProgressTodo",            { fg = c.fg_mute })
hl("LazyProp",                    { fg = c.fg_dim })
hl("LazyValue",                   { fg = c.cyan })
hl("LazyCommit",                  { fg = c.green,   bold = true })
hl("LazyCommitType",              { fg = c.pu3 })
hl("LazyCommitScope",             { fg = c.blue })
hl("LazyDimmed",                  { fg = c.fg_mute })
hl("LazySpecial",                 { fg = c.pu4 })
hl("LazyLocal",                   { fg = c.orange })
hl("LazyUrl",                     { fg = c.blue,    underline = true })
hl("LazyReasonImport",            { fg = c.pu4 })
hl("LazyReasonEvent",             { fg = c.yellow })
hl("LazyReasonKeys",              { fg = c.green })
hl("LazyReasonStart",             { fg = c.cyan })
hl("LazyReasonPlugin",            { fg = c.blue })
hl("LazyReasonRuntime",           { fg = c.orange })
hl("LazyReasonSource",            { fg = c.pu3 })
hl("LazyReasonCmd",               { fg = c.red })
hl("LazyReasonFt",                { fg = c.blue_d })
hl("LazyReasonRequire",           { fg = c.magenta })

-- ── oil.nvim ──────────────────────────────────────────────────────────────────
hl("OilNormal",                   { fg = c.fg,      bg = c.bg0 })
hl("OilNormalFloat",              { link = "NormalFloat" })
hl("OilDir",                      { fg = c.blue,    bold = true })
hl("OilDirIcon",                  { fg = c.pu4 })
hl("OilLink",                     { fg = c.cyan })
hl("OilLinkTarget",               { fg = c.cyan,    italic = true })
hl("OilCopy",                     { fg = c.yellow,  bold = true })
hl("OilMove",                     { fg = c.orange,  bold = true })
hl("OilChange",                   { fg = c.yellow })
hl("OilCreate",                   { fg = c.green,   bold = true })
hl("OilDelete",                   { fg = c.red,     bold = true })
hl("OilPermissionNone",           { fg = c.fg_mute })
hl("OilPermissionRead",           { fg = c.yellow })
hl("OilPermissionWrite",          { fg = c.red })
hl("OilPermissionExecute",        { fg = c.green })
hl("OilTypeFile",                 { fg = c.fg_mute })
hl("OilTypeDir",                  { fg = c.blue })
hl("OilTypeLink",                 { fg = c.cyan })
hl("OilTypeSpecial",              { fg = c.magenta })
hl("OilSize",                     { fg = c.fg_mute })
hl("OilMtime",                    { fg = c.fg_mute })
hl("OilHidden",                   { fg = c.fg_mute, italic = true })

-- ── flash.nvim ────────────────────────────────────────────────────────────────
hl("FlashBackdrop",               { fg = c.fg_mute })
hl("FlashMatch",                  { fg = c.bg0,     bg = c.pu3 })
hl("FlashCurrent",                { fg = c.bg0,     bg = c.pu4,      bold = true })
hl("FlashLabel",                  { fg = c.bg0,     bg = c.orange,   bold = true })
hl("FlashPrompt",                 { fg = c.pu4 })
hl("FlashPromptIcon",             { fg = c.pu4 })
hl("FlashCursor",                 { fg = c.bg0,     bg = c.cyan })

-- ── mini.nvim suite ───────────────────────────────────────────────────────────
-- mini.statusline
hl("MiniStatuslineModeNormal",    { fg = c.bg0,     bg = c.pu4,      bold = true })
hl("MiniStatuslineModeInsert",    { fg = c.bg0,     bg = c.green,    bold = true })
hl("MiniStatuslineModeVisual",    { fg = c.bg0,     bg = c.orange,   bold = true })
hl("MiniStatuslineModeReplace",   { fg = c.bg0,     bg = c.red,      bold = true })
hl("MiniStatuslineModeCommand",   { fg = c.bg0,     bg = c.yellow,   bold = true })
hl("MiniStatuslineModeOther",     { fg = c.bg0,     bg = c.cyan,     bold = true })
hl("MiniStatuslineDevinfo",       { fg = c.fg_dim,  bg = c.bg3 })
hl("MiniStatuslineFilename",      { fg = c.fg,      bg = c.bg2 })
hl("MiniStatuslineFileinfo",      { fg = c.fg_dim,  bg = c.bg3 })
hl("MiniStatuslineInactive",      { fg = c.fg_mute, bg = c.bg1 })
-- mini.tabline
hl("MiniTablineCurrent",          { fg = c.fg_hi,   bg = c.bg0,      bold = true })
hl("MiniTablineVisible",          { fg = c.fg_dim,  bg = c.bg1 })
hl("MiniTablineHidden",           { fg = c.fg_mute, bg = c.bg1 })
hl("MiniTablineModifiedCurrent",  { fg = c.orange,  bg = c.bg0,      bold = true })
hl("MiniTablineModifiedVisible",  { fg = c.orange,  bg = c.bg1 })
hl("MiniTablineModifiedHidden",   { fg = c.orange_d,bg = c.bg1 })
hl("MiniTablineFill",             { bg = c.bg0 })
hl("MiniTablineTabpagesection",   { fg = c.bg0,     bg = c.pu4,      bold = true })
-- mini.files
hl("MiniFilesNormal",             { fg = c.fg,      bg = c.bg1 })
hl("MiniFilesTitle",              { fg = c.pu4,     bg = c.bg1,      bold = true })
hl("MiniFilesTitleFocused",       { fg = c.bg0,     bg = c.pu4,      bold = true })
hl("MiniFilesBorder",             { fg = c.border,  bg = c.bg1 })
hl("MiniFilesBorderModified",     { fg = c.orange,  bg = c.bg1 })
hl("MiniFilesDirectory",          { fg = c.blue })
hl("MiniFilesCursorLine",         { bg = c.bg3 })
-- mini.pick
hl("MiniPickNormal",              { link = "NormalFloat" })
hl("MiniPickBorder",              { link = "FloatBorder" })
hl("MiniPickBorderBusy",          { fg = c.orange })
hl("MiniPickBorderText",          { fg = c.pu4 })
hl("MiniPickHeader",              { fg = c.pu4,     bold = true })
hl("MiniPickMatchCurrent",        { bg = c.bg3,     bold = true })
hl("MiniPickMatchMarked",         { fg = c.orange })
hl("MiniPickMatchRanges",         { fg = c.green,   bold = true })
hl("MiniPickPrompt",              { fg = c.pu4 })
-- mini.diff
hl("MiniDiffSignAdd",             { fg = c.green })
hl("MiniDiffSignChange",          { fg = c.yellow })
hl("MiniDiffSignDelete",          { fg = c.red })
hl("MiniDiffOverAdd",             { bg = c.green_bg })
hl("MiniDiffOverChange",          { bg = c.blue_bg })
hl("MiniDiffOverDelete",          { bg = c.red_bg })
hl("MiniDiffOverContext",         { bg = c.bg2 })
-- mini.clue
hl("MiniClueNormal",              { link = "NormalFloat" })
hl("MiniClueBorder",              { link = "FloatBorder" })
hl("MiniClueTitle",               { link = "FloatTitle" })
hl("MiniClueDescGroup",           { fg = c.blue })
hl("MiniClueDescSingle",          { fg = c.fg })
hl("MiniClueNextKey",             { fg = c.pu4,     bold = true })
hl("MiniClueNextKeyWithPostkeys", { fg = c.orange,  bold = true })
hl("MiniClueSeparator",           { fg = c.border })
-- mini.indentscope
hl("MiniIndentscopeSymbol",       { fg = c.pu2 })
hl("MiniIndentscopePrefix",       { nocombine = true })
-- mini.cursorword
hl("MiniCursorword",              { underline = true })
hl("MiniCursorwordCurrent",       { underline = true })
-- mini.notify
hl("MiniNotifyNormal",            { link = "NormalFloat" })
hl("MiniNotifyBorder",            { link = "FloatBorder" })
-- mini.starter
hl("MiniStarterCurrent",          { fg = c.pu4,     bold = true })
hl("MiniStarterFooter",           { fg = c.fg_mute, italic = true })
hl("MiniStarterHeader",           { fg = c.pu4 })
hl("MiniStarterInactive",         { fg = c.fg_mute, italic = true })
hl("MiniStarterItem",             { fg = c.fg })
hl("MiniStarterItemBullet",       { fg = c.border })
hl("MiniStarterItemPrefix",       { fg = c.green,   bold = true })
hl("MiniStarterSection",          { fg = c.blue,    bold = true })
hl("MiniStarterQuery",            { fg = c.pu4 })
-- mini.completion
hl("MiniCompletionActiveParameter", { underline = true, sp = c.orange })
-- mini.surround
hl("MiniSurround",                { fg = c.bg0,     bg = c.orange })
-- mini.jump
hl("MiniJump",                    { fg = c.bg0,     bg = c.orange,   bold = true })
hl("MiniJump2dSpot",              { fg = c.bg0,     bg = c.pu4,      bold = true })
hl("MiniJump2dSpotAhead",         { fg = c.bg0,     bg = c.pu3 })
hl("MiniJump2dSpotUnique",        { fg = c.bg0,     bg = c.orange,   bold = true })
hl("MiniJump2dDim",               { fg = c.fg_mute })
-- mini.trailspace
hl("MiniTrailspace",              { bg = c.red_bg })
-- mini.map
hl("MiniMapNormal",               { fg = c.fg_mute, bg = c.bg1 })
hl("MiniMapSymbolCount",          { fg = c.cyan })
hl("MiniMapSymbolLine",           { fg = c.pu4 })
hl("MiniMapSymbolView",           { fg = c.border })

-- ── render-markdown.nvim ──────────────────────────────────────────────────────
hl("RenderMarkdownH1",            { fg = c.pu4,     bold = true })
hl("RenderMarkdownH2",            { fg = c.blue,    bold = true })
hl("RenderMarkdownH3",            { fg = c.green,   bold = true })
hl("RenderMarkdownH4",            { fg = c.orange,  bold = true })
hl("RenderMarkdownH5",            { fg = c.cyan,    bold = true })
hl("RenderMarkdownH6",            { fg = c.magenta, bold = true })
hl("RenderMarkdownH1Bg",          { bg = "#1C1530" })
hl("RenderMarkdownH2Bg",          { bg = "#0E1B2E" })
hl("RenderMarkdownH3Bg",          { bg = "#0E1E0C" })
hl("RenderMarkdownH4Bg",          { bg = "#231A0D" })
hl("RenderMarkdownH5Bg",          { bg = "#0D1E1E" })
hl("RenderMarkdownH6Bg",          { bg = "#1C0D20" })
hl("RenderMarkdownCode",          { bg = "#131322" })
hl("RenderMarkdownCodeInline",    { fg = c.green,   bg = "#131322" })
hl("RenderMarkdownBullet",        { fg = c.pu3 })
hl("RenderMarkdownQuote",         { fg = c.fg_dim,  italic = true })
hl("RenderMarkdownLink",          { fg = c.blue,    underline = true })
hl("RenderMarkdownWikiLink",      { fg = c.cyan,    underline = true })
hl("RenderMarkdownHtmlComment",   { fg = c.fg_mute, italic = true })
hl("RenderMarkdownChecked",       { fg = c.green })
hl("RenderMarkdownUnchecked",     { fg = c.fg_mute })
hl("RenderMarkdownTodo",          { fg = c.orange,  bold = true })
hl("RenderMarkdownDash",          { fg = c.border })
hl("RenderMarkdownTableHead",     { fg = c.blue,    bold = true })
hl("RenderMarkdownTableRow",      { fg = c.fg })
hl("RenderMarkdownTableFill",     { fg = c.border })

-- ── todo-comments.nvim ────────────────────────────────────────────────────────
hl("TodoBgFIX",                   { fg = c.bg0, bg = c.red,     bold = true })
hl("TodoBgTODO",                  { fg = c.bg0, bg = c.orange,  bold = true })
hl("TodoBgHACK",                  { fg = c.bg0, bg = c.yellow,  bold = true })
hl("TodoBgWARN",                  { fg = c.bg0, bg = c.yellow,  bold = true })
hl("TodoBgPERF",                  { fg = c.bg0, bg = c.magenta, bold = true })
hl("TodoBgNOTE",                  { fg = c.bg0, bg = c.cyan,    bold = true })
hl("TodoBgTEST",                  { fg = c.bg0, bg = c.green,   bold = true })
hl("TodoFgFIX",                   { fg = c.red })
hl("TodoFgTODO",                  { fg = c.orange })
hl("TodoFgHACK",                  { fg = c.yellow })
hl("TodoFgWARN",                  { fg = c.yellow })
hl("TodoFgPERF",                  { fg = c.magenta })
hl("TodoFgNOTE",                  { fg = c.cyan })
hl("TodoFgTEST",                  { fg = c.green })
hl("TodoSignFIX",                 { link = "TodoFgFIX" })
hl("TodoSignTODO",                { link = "TodoFgTODO" })
hl("TodoSignHACK",                { link = "TodoFgHACK" })
hl("TodoSignWARN",                { link = "TodoFgWARN" })
hl("TodoSignPERF",                { link = "TodoFgPERF" })
hl("TodoSignNOTE",                { link = "TodoFgNOTE" })
hl("TodoSignTEST",                { link = "TodoFgTEST" })

-- ── snacks.nvim ───────────────────────────────────────────────────────────────
hl("SnacksNormal",                { link = "NormalFloat" })
hl("SnacksBorder",                { link = "FloatBorder" })
hl("SnacksBackdrop",              { bg = c.bg_hard, fg = c.fg_mute })
hl("SnacksNotifierNormal",        { link = "NormalFloat" })
hl("SnacksNotifierBorderError",   { fg = c.red })
hl("SnacksNotifierBorderWarn",    { fg = c.yellow })
hl("SnacksNotifierBorderInfo",    { fg = c.blue })
hl("SnacksNotifierBorderDebug",   { fg = c.gray })
hl("SnacksNotifierBorderTrace",   { fg = c.pu2 })
hl("SnacksNotifierIconError",     { fg = c.red })
hl("SnacksNotifierIconWarn",      { fg = c.yellow })
hl("SnacksNotifierIconInfo",      { fg = c.blue })
hl("SnacksNotifierIconDebug",     { fg = c.gray })
hl("SnacksNotifierIconTrace",     { fg = c.pu2 })
hl("SnacksNotifierTitleError",    { fg = c.red,     bold = true })
hl("SnacksNotifierTitleWarn",     { fg = c.yellow,  bold = true })
hl("SnacksNotifierTitleInfo",     { fg = c.blue,    bold = true })
hl("SnacksNotifierTitleDebug",    { fg = c.gray })
hl("SnacksNotifierTitleTrace",    { fg = c.pu2 })
hl("SnacksDashboardHeader",       { fg = c.pu4 })
hl("SnacksDashboardDesc",         { fg = c.fg_dim })
hl("SnacksDashboardKey",          { fg = c.pu4,     bold = true })
hl("SnacksDashboardIcon",         { fg = c.pu4 })
hl("SnacksDashboardSpecial",      { fg = c.green })
hl("SnacksDashboardDir",          { fg = c.fg_mute })
hl("SnacksDashboardFile",         { fg = c.blue })
hl("SnacksDashboardFooter",       { fg = c.fg_mute, italic = true })
hl("SnacksDashboardTerminal",     { fg = c.fg })
hl("SnacksInputNormal",           { fg = c.fg,      bg = c.bg3 })
hl("SnacksInputBorder",           { fg = c.pu2,     bg = c.bg3 })
hl("SnacksInputTitle",            { fg = c.pu4,     bold = true })
hl("SnacksPickerNormal",          { link = "NormalFloat" })
hl("SnacksPickerBorder",          { link = "FloatBorder" })
hl("SnacksPickerTitle",           { link = "FloatTitle" })
hl("SnacksPickerMatch",           { fg = c.green,   bold = true })
hl("SnacksPickerSelected",        { fg = c.orange })
hl("SnacksPickerToggle",          { fg = c.pu4 })
hl("SnacksPickerPrompt",          { fg = c.pu4 })
hl("SnacksWords",                 { bg = c.bg3 })
hl("SnacksWordsCurrent",          { bg = c.bg3,     underline = true })
hl("SnacksScratchNormal",         { link = "NormalFloat" })
hl("SnacksScratchBorder",         { link = "FloatBorder" })
hl("SnacksScratchTitle",          { link = "FloatTitle" })
hl("SnacksIndent",                { fg = c.bg3,     nocombine = true })
hl("SnacksIndentScope",           { fg = c.pu2,     nocombine = true })
hl("SnacksZenNormal",             { fg = c.fg,      bg = c.bg0 })
hl("SnacksZenLine",               { bg = c.bg2 })
hl("SnacksProfilerBefore",        { fg = c.blue })
hl("SnacksProfilerAfter",         { fg = c.green })
hl("SnacksProfilerBadgeMs",       { fg = c.bg0,     bg = c.orange,   bold = true })

-- ── headlines.nvim ────────────────────────────────────────────────────────────
hl("Headline1",                   { bg = "#1C1530" })
hl("Headline2",                   { bg = "#0E1B2E" })
hl("Headline3",                   { bg = "#0E1E0C" })
hl("Headline4",                   { bg = "#231A0D" })
hl("Headline5",                   { bg = "#0D1E1E" })
hl("Headline6",                   { bg = "#1C0D20" })
hl("HeadlineCodeblock",           { bg = "#131322" })
hl("HeadlineDash",                { fg = c.border })

-- ── aerial.nvim ───────────────────────────────────────────────────────────────
hl("AerialNormal",                { fg = c.fg,      bg = c.bg1 })
hl("AerialLine",                  { bg = c.bg2,     bold = true })
hl("AerialLineNC",                { bg = c.bg2 })
hl("AerialGuide",                 { fg = c.border })
hl("AerialClass",                 { fg = c.blue })
hl("AerialClassIcon",             { fg = c.blue })
hl("AerialFunction",              { fg = c.pu4 })
hl("AerialFunctionIcon",          { fg = c.pu4 })
hl("AerialMethod",                { fg = c.pu4 })
hl("AerialMethodIcon",            { fg = c.pu4 })
hl("AerialInterface",             { fg = c.blue,    italic = true })
hl("AerialVariable",              { fg = c.fg })

-- ── barbecue.nvim / winbar breadcrumbs ────────────────────────────────────────
hl("BarbecueNormal",              { fg = c.fg_dim,  bg = c.bg1 })
hl("BarbecueDimmed",              { fg = c.fg_mute, bg = c.bg1 })
hl("BarbecueEllipsis",            { fg = c.fg_mute, bg = c.bg1 })
hl("BarbecueSeparator",           { fg = c.border,  bg = c.bg1 })
hl("BarbecueModified",            { fg = c.orange,  bg = c.bg1 })
hl("BarbecueDirname",             { fg = c.blue,    bg = c.bg1 })
hl("BarbecueBasename",            { fg = c.fg_hi,   bg = c.bg1,      bold = true })
hl("BarbecueContext",             { fg = c.fg_dim,  bg = c.bg1 })
hl("BarbecueContextClass",        { fg = c.blue,    bg = c.bg1 })
hl("BarbecueContextFunction",     { fg = c.pu4,     bg = c.bg1 })
hl("BarbecueContextMethod",       { fg = c.pu4,     bg = c.bg1 })
hl("BarbecueContextModule",       { fg = c.blue_d,  bg = c.bg1 })
hl("BarbecueContextNamespace",    { fg = c.blue_d,  bg = c.bg1 })
hl("BarbecueContextProperty",     { fg = c.fg,      bg = c.bg1 })
hl("BarbecueContextVariable",     { fg = c.fg,      bg = c.bg1 })

-- ── dropbar.nvim ──────────────────────────────────────────────────────────────
hl("DropBarNormal",               { link = "BarbecueNormal" })
hl("DropBarCurrentContext",       { fg = c.pu4,     bg = c.bg2,      bold = true })
hl("DropBarMenuNormalFloat",      { link = "NormalFloat" })
hl("DropBarMenuFloatBorder",      { link = "FloatBorder" })
hl("DropBarMenuCurrentContext",   { bg = c.bg3,     bold = true })

-- ── nvim-ufo (folding) ────────────────────────────────────────────────────────
hl("UfoFoldedBg",                 { bg = c.bg2 })
hl("UfoFoldedEllipsis",           { fg = c.pu3 })
hl("UfoCurFoldedLine",            { bg = c.bg3 })
hl("UfoPreviewSbar",              { bg = c.bg3 })
hl("UfoPreviewThumb",             { bg = c.pu1 })

-- ── nvim-scrollbar ────────────────────────────────────────────────────────────
hl("ScrollbarHandle",             { bg = c.bg3 })
hl("ScrollbarCursorHandle",       { bg = c.pu1 })
hl("ScrollbarCursor",             { fg = c.pu4 })
hl("ScrollbarSearchHandle",       { fg = c.yellow, bg = c.bg3 })
hl("ScrollbarSearch",             { fg = c.yellow })
hl("ScrollbarErrorHandle",        { fg = c.red,    bg = c.bg3 })
hl("ScrollbarError",              { fg = c.red })
hl("ScrollbarWarnHandle",         { fg = c.yellow, bg = c.bg3 })
hl("ScrollbarWarn",               { fg = c.yellow })
hl("ScrollbarInfoHandle",         { fg = c.blue,   bg = c.bg3 })
hl("ScrollbarInfo",               { fg = c.blue })
hl("ScrollbarHintHandle",         { fg = c.cyan,   bg = c.bg3 })
hl("ScrollbarHint",               { fg = c.cyan })
hl("ScrollbarMiscHandle",         { fg = c.pu4,    bg = c.bg3 })
hl("ScrollbarMisc",               { fg = c.pu4 })

-- ── satellite.nvim ────────────────────────────────────────────────────────────
hl("SatelliteBar",                { bg = c.bg2 })
hl("SatelliteCursor",             { fg = c.pu4 })
hl("SatellitePosition",           { fg = c.fg_mute })
hl("SatelliteSearch",             { fg = c.yellow })
hl("SatelliteDiagnosticError",    { fg = c.red })
hl("SatelliteDiagnosticWarn",     { fg = c.yellow })
hl("SatelliteDiagnosticInfo",     { fg = c.blue })
hl("SatelliteDiagnosticHint",     { fg = c.cyan })
hl("SatelliteGitSignsAdd",        { fg = c.green })
hl("SatelliteGitSignsChange",     { fg = c.yellow })
hl("SatelliteGitSignsDelete",     { fg = c.red })

-- =============================================================================
-- END
-- =============================================================================

