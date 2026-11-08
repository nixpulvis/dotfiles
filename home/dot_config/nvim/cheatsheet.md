---
title: Neovim cheatsheet
subtitle: The keys in this config, from the basics up
papersize: us-letter
margin:
  x: 2.5cm
  y: 2cm
fontsize: 9pt
mainfont: Fira Sans
codefont: Fira Mono
header-includes: |
  ```{=typst}
  #set table(stroke: 0.4pt + luma(190), inset: (x: 4pt, y: 3pt))
  #show table.cell.where(y: 0): set text(weight: "bold")
  #show table: set par(justify: false)
  #show raw.where(block: false): set text(size: 1.15em)
  #show heading.where(level: 2): set block(above: 2.2em, below: 0.6em)
  ```
# Keep each section (a ## heading and everything up to the next heading) on
# one page: a section that doesn't fit starts on the next page. A part (a #
# heading) starts a new page, together with its first section.
include-before: |
  ```{=typst}
  #show: body => {
    let groups = ()
    for child in body.children {
      let depth = if child.func() == heading { child.depth } else { 0 }
      if depth == 1 {
        groups.push((part: true, open: true, items: (child,)))
      } else if depth == 2 and groups.len() > 0 and groups.last().open {
        groups.at(-1).open = false
        groups.at(-1).items.push(child)
      } else if depth == 2 {
        groups.push((part: false, open: false, items: (child,)))
      } else if groups.len() > 0 {
        groups.at(-1).items.push(child)
      } else if repr(child.func()) not in ("space", "parbreak") {
        groups.push((part: false, open: false, items: (child,)))
      }
    }
    for (i, group) in groups.enumerate() {
      if group.part and i > 0 { pagebreak(weak: true) }
      let above = if group.part { 3.2em } else { 2.2em }
      block(breakable: false, width: 100%, above: above, group.items.join())
    }
  }
  ```
---

<!--
Build the PDF (needs pandoc and typst, both from Homebrew):

    pandoc ~/.config/nvim/cheatsheet.md --pdf-engine=typst -o cheatsheet.pdf

To add a bind, add a row to the table of the section it belongs to:
`| keys | what it does |`. Write keys as they're typed, in backticks, and a
literal | inside a cell as \| (outside backticks). For a new table, copy an
existing header and separator line: a separator longer than 72 characters
makes the table span the page, and its dash counts set the column widths.
-->

# Basics

## Modes, and getting unstuck

Neovim starts in **Normal mode**, where keys are commands, not text.

| Keys | What it does |
|:---------------------------|:------------------------------------------------|
| `i` / `a` | Insert mode before / after the cursor |
| `I` / `A` | Insert mode at the start / end of the line |
| `o` / `O` | Open a new line below / above, in Insert mode |
| `Esc` | Back to Normal mode (press twice when unsure) |
| `v` / `V` / `Ctrl-V` | Visual mode: select characters / lines / a block |
| `:` | Command line, for `:` commands |
| `u` / `Ctrl-R` | Undo / redo |
| `:q!` | Quit without saving (in Insert mode, press `Esc` first) |

## Files, saving and quitting

Normal mode.

| Keys | What it does |
|:---------------------------|:------------------------------------------------|
| `:w` | Save |
| `:q` | Close the window (quits on the last one) |
| `:wq` or `ZZ` | Save and close |
| `:q!` or `ZQ` | Close without saving |
| `:qa` | Quit everything |
| `:e path` | Open a file (Tab completes the path) |
| `:e!` | Throw away changes, reload from disk |
| `Ctrl-\` | File tree (NERDTree) on / off |

## Moving the cursor

Normal and Visual mode. A count repeats any of these.

| Keys | What it does |
|:---------------------------|:------------------------------------------------|
| `h` `j` `k` `l` | Left, down, up, right |
| `w` / `b` / `e` | Next word / back a word / end of word |
| `W` / `B` / `E` | Same, but words are anything between spaces |
| `0` / `^` / `$` | Line start / first non-blank / line end |
| `gg` / `G` / `42G` | First line / last line / line 42 |
| `{` / `}` | Previous / next blank line (paragraph) |
| `%` | Jump to the matching bracket |
| `fx` / `tx` | To / just before the next `x` on the line (any character) |
| `;` / `,` | Repeat that `f`/`t` forward / backward |
| `Ctrl-D` / `Ctrl-U` | Half a page down / up |
| `Ctrl-F` / `Ctrl-B` | A page down / up |
| `zz` / `zt` / `zb` | Scroll so the cursor line is centered / top / bottom |

## Editing text

Normal mode. An *operator* followed by a *motion* acts on the text the motion
covers: `dw` deletes a word, `c$` changes to the end of the line, `y}` copies a
paragraph. Doubling an operator acts on the line: `dd`, `cc`, `yy`.

| Keys | What it does |
|:---------------------------|:------------------------------------------------|
| `d{motion}` | Delete (also copies it) |
| `c{motion}` | Delete and enter Insert mode |
| `y{motion}` | Copy ("yank") |
| `>{motion}` / `<{motion}` | Indent / unindent |
| `gU{motion}` / `gu{motion}` | Uppercase / lowercase |
| `gc{motion}` / `gcc` | Comment or uncomment / the current line |
| `x` / `rx` | Delete the character / replace it with `x` (any character) |
| `D` / `C` / `Y` | Delete / change / copy to the end of the line |
| `p` / `P` | Paste after / before the cursor |
| `J` | Join the next line onto this one |
| `.` | Repeat the last change |
| `Ctrl-A` / `Ctrl-X` | Add / subtract 1 from the number under the cursor |

**Text objects** go where a motion goes and select a whole thing around the
cursor: `i` is inside, `a` includes the surroundings. For example `ciw` changes
the word, `di(` empties the parentheses, `ya"` copies a quoted string with its
quotes.

| Object | Selects |
|:---------------------------|:------------------------------------------------|
| `iw` / `aw` | A word |
| `i(` `i[` `i{` `i<` | Inside brackets (`a(` etc. include them) |
| `i"` `i'` `` i` `` | Inside quotes |
| `ip` / `ap` | A paragraph |
| `it` / `at` | Inside / around an HTML or XML tag |

**Surrounding characters** (vim-surround):

| Keys | What it does |
|:---------------------------|:------------------------------------------------|
| `cs"'` | Change the surrounding `"` to `'` |
| `ds(` | Delete the surrounding parentheses |
| `ysiw"` | Surround the word with `"` (`ys` + any motion or object) |
| `S"` | In Visual mode: surround the selection with `"` |

## Selecting (Visual mode)

Start with `v`, `V` or `Ctrl-V`, move to extend the selection, then press an
operator without a motion: `d`, `c`, `y`, `>`, `gc`, `gU`.

| Keys | What it does |
|:---------------------------|:------------------------------------------------|
| `o` | Jump to the other end of the selection |
| `gv` | Select the last selection again |
| `I` / `A` | With `Ctrl-V`: insert / append on every line of the block |
| `*` / `#` | Search for the selected text forward / backward |

## Searching in a file

Normal mode.

| Keys | What it does |
|:---------------------------|:------------------------------------------------|
| `/text` | Search forward (Enter to go) |
| `?text` | Search backward |
| `n` / `N` | Next / previous match |
| `*` / `#` | Search for the word under the cursor forward / backward |
| `Ctrl-L` | Clear the match highlighting |
| `:%s/old/new/g` | Replace in the whole file (`gc` at the end asks each time) |
| `&` | Repeat the last replace on the current line |

## Windows, tabs and buffers

A *buffer* is an open file, a *window* is a view of one, and a *tab* is a
layout of windows. Normal mode.

| Keys | What it does |
|:---------------------------|:------------------------------------------------|
| `Ctrl-W s` / `Ctrl-W v` | Split the window horizontally / vertically |
| `Ctrl-W h` `j` `k` `l` | Go to the window left, below, above, right |
| `Ctrl-W w` | Go to the next window (also into popups) |
| `Ctrl-W q` / `Ctrl-W o` | Close this window / close all the others |
| `Ctrl-W =` | Make all windows the same size |
| `Ctrl-W T` | Move this window into its own tab |
| `:tabnew` / `:tabclose` | Open / close a tab |
| `gt` / `gT` / `3gt` | Next / previous / third tab |
| `]b` / `[b` | Next / previous buffer in this window |
| `:ls` / `:b 3` | List buffers / show buffer 3 |

## Jumping back and forth

Normal mode. Big moves (a search, `G`, `%`, opening another file) are
remembered, so you can retrace them.

| Keys | What it does |
|:---------------------------|:------------------------------------------------|
| `Ctrl-O` / `Ctrl-I` | Back / forward through recent jumps |
| ``` `` ``` | Back to where the last jump started |
| `` `. `` / `g;` | To the last change / older changes |
| `ma` / `` `a `` | Set mark `a` here / jump back to it (any letter) |

## Finding files and text

| Keys | What it does |
|:---------------------------|:------------------------------------------------|
| `Ctrl-P` | Find a file by name, with a preview, anywhere in the project (from its Git root) |
| `:FzfLua files` | The same, from the working directory |
| `:FzfLua live_grep` | Search the text of every file under the working directory, as you type |
| `:FzfLua grep_cword` | Search those files for the word under the cursor |
| `:FzfLua buffers` / `:FzfLua oldfiles` | Open files / recent files |
| `:Rg text` | Search those files, into the quickfix list |
| `:FzfLua` then Tab | List every picker |

In `files`, `Alt-I` / `Alt-H` include ignored / hidden files. In grep pickers,
`Ctrl-G` switches between searching as you type and filtering the results.

## Git

Normal mode, in files tracked by Git. Changed lines are marked in the left
column.

| Keys | What it does |
|:---------------------------|:------------------------------------------------|
| `]c` / `[c` | Next / previous changed block ("hunk") |
| `\hp` | Preview the hunk's change |
| `\hs` / `\hu` | Stage / undo the hunk |
| `:FzfLua git_status` | Changed files |
| `:FzfLua git_bcommits` | This file's history |
| `:FzfLua git_blame` | Who last changed each line |

## Other toggles and tools

| Keys | What it does |
|:---------------------------|:------------------------------------------------|
| `F5` | Spell checking on / off |
| `:UndotreeToggle` | Browse the full undo history as a tree |
| `:Goyo` | Distraction-free writing mode on / off |
| `Ctrl-H` / `Ctrl-L` | On the `:` line: move left / right |
| `Ctrl-K` / `Ctrl-J` | On the `:` line: previous / next command from history |

## Learning more

| Keys | What it does |
|:---------------------------|:------------------------------------------------|
| `:help w` | Help for any key or command (`:help CTRL-W_v`, `:help :copen`) |
| `:FzfLua helptags` | Search all help topics |
| `:FzfLua keymaps` | Every bind in effect, searchable |
| `:map gd` | What `gd` is bound to here |
| `:checkhealth` | Diagnose problems with Neovim, plugins and servers |

# Code

The first three sections need a language server for the file's language, such
as rust-analyzer for Rust.

## Getting around the code

Normal mode. Lists open in an fzf picker (see "fzf pickers" below) with a
preview.

| Keys | What it does |
|:---------------------------|:------------------------------------------------|
| `gd` or `Ctrl-]` | Go to the definition, even in another file or crate (`gd` shows a picker if there are several) |
| `grt` | Go to the definition of the type |
| `grr` | One list of definitions (`def`), implementations (`impl`) and uses (`ref`) |
| `gri` | Implementations only, in the quickfix list (straight there if there's one) |
| `gO` | Every symbol in this file (functions, types, ...) |
| `K` | Docs and type of the thing under the cursor (`K` again to enter) |
| `]r` / `[r` | Next / previous use of the symbol in this file |
| `Ctrl-T` | Back to where you were before the jump |
| `:FzfLua resume` | Reopen the last list where you left it |

When the cursor rests on a name for a moment, every other use of it in the
file is highlighted. Moving clears it.

**`gd` with and without a language server.** The keys above ask the language
server, which understands the code: `gd` on a function call opens the function,
wherever it's defined. In a file with no language server, or before the server
has started, `gd` is Vim's own text search instead: it jumps to the first place
the word appears in this file, and knows nothing about other files. `gD` is
always that text search, and `Ctrl-]` then only works with a tags file.

## Changing code

| Keys | Mode | What it does |
|:--------------|:---------------|:-----------------------------------------------|
| `gra` | Normal, Visual | Code actions (fixes, imports, "Extract into function" on a selection), with a diff preview |
| `grn` | Normal | Rename the symbol everywhere (type the new name, Enter) |
| `Ctrl-S` | Insert | Show the parameters of the function being called |
| `\th` | Normal | Inlay hints (inferred types, parameter names) on / off |

**Completion** (Insert mode): the menu opens as you type.

| Keys | What it does |
|:---------------------------|:------------------------------------------------|
| `Ctrl-N` / `Ctrl-P` or Down / Up | Next / previous suggestion |
| `Enter` | Accept (the first one if none is selected) |
| `Ctrl-Y` | Accept the selected one |
| `Ctrl-E` | Close the menu |
| `Ctrl-Space` | Open the menu |
| `Ctrl-F` / `Ctrl-B` | Scroll the docs beside the menu |
| `Tab` | SuperTab's word completion (a separate, simpler menu) |

## Errors and warnings

Normal mode. Problems show as `E`/`W` signs in the left column, and the counts
for this file as `E:2  W:3` in the status bar.

| Keys | What it does |
|:-------------------------------------|:--------------------------------------|
| `]d` / `[d` | Next / previous problem |
| `]D` / `[D` | Last / first problem |
| `Ctrl-W d` | Show the full message for the problem under the cursor |
| `:FzfLua diagnostics_document` | Pick from this file's problems |
| `:FzfLua diagnostics_workspace` | Pick from the whole project's |

## fzf pickers

Every list from `gd`, `grr`, `gO`, `gra` and `:FzfLua ...` is an fzf picker:
type to filter, pick with a key. Pressing a key below means typing in the
picker.

| Keys | What it does |
|:---------------------------|:------------------------------------------------|
| `Ctrl-N` / `Ctrl-P` or Down / Up | Move through the list |
| `Enter` | Open the entry (or the marked ones, into quickfix) |
| `Ctrl-S` / `Ctrl-V` / `Ctrl-T` | Open in a split / vertical split / new tab (in lists of places) |
| `Tab` / `Shift-Tab` | Mark the entry and move down / up |
| `Alt-A` | Mark every entry that matches the filter |
| `Alt-Q` | Send the marked entries to the quickfix list |
| `Ctrl-U` | Clear what you typed |
| `Shift-Up` / `Shift-Down` | Scroll the preview |
| `F4` | Hide / show the preview |
| `F1` | Help: every key in this picker |
| `Esc` | Close |
| `Alt-Esc` | Hide it; `:FzfLua resume` brings it back |

**Filtering:** what you type matches fuzzily, so `mkbrd` finds `make_board`.

| Typed | Matches |
|:---------------------------|:------------------------------------------------|
| `foo bar` | Lines matching both |
| `'foo` | Exactly `foo` |
| `^def` / `.rs$` | Lines starting with `def` / ending with `.rs` |
| `!test` | Lines *not* matching `test` |
| `foo` \| `bar` | Lines matching either |
| `pat -- *.rs` | In grep pickers: only search `.rs` files |

## Quickfix and location lists

A *quickfix list* is a list of places (errors, search results, references)
shown in a window at the bottom. A *location list* is the same, but belongs to
one window. Lists come from `Alt-Q` in a picker, `gri`, `:CargoBuild`,
`:CargoTest` and `:Rg`.

| Keys | What it does |
|:---------------------------|:------------------------------------------------|
| `:copen` / `:cclose` | Show / hide the quickfix list (`:lopen` / `:lclose` for location) |
| `]q` / `[q` | Go to the next / previous entry, from any window |
| `]Q` / `[Q` | Last / first entry |
| `]l` / `[l` | Next / previous location list entry |
| `Enter` | In the list: go to the entry |
| `Ctrl-S` / `Ctrl-V` / `Ctrl-T` | In the list: open it in a split / vertical split / new tab |
| `Ctrl-F` | In the list: filter it in an fzf picker |
| `Ctrl-X` | In that picker: remove entries from the list |

## Rust and Cargo

| Command | What it does |
|:---------------------------|:------------------------------------------------|
| `:CargoCheck` | Check the code; errors go into the quickfix list |
| `:CargoBuild` | Build; errors go into the quickfix list |
| `:CargoTest` | Run the tests; compile errors go into the quickfix list |
| `:CargoRun` | Run the program |
| `:RustFmt` | Format the file with rustfmt |

## The status bar

From left to right: the mode, the file name (`+` when unsaved), then on the
right: error and warning counts (`E:2  W:3`), what the language server is busy
with (e.g. `Indexing 34/120`), the line ending, encoding and file type, how
far through the file you are, and `line:column`.

