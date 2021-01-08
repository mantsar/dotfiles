" ======================= GENERAL ======================================== {{{1

if exists('g:neovide')
	let g:neovide_fullscreen=v:false
	let g:neovide_transparency=0.95
	let g:neovide_cursor_vfx_mode = "ripple"
	" set guifont=FiraCode-Bold:h15
	set guifont=iosevka-bold:h17
	" set guifont=UbuntuMono-B:h20
	function! Toggle_neovide_fullscreen()
		if g:neovide_fullscreen
			let g:neovide_fullscreen = v:false
		else
			let g:neovide_fullscreen = v:true
		endif
	endfunction
	nnoremap <up> :let g:neovide_transparency=g:neovide_transparency+0.1<cr>
	nnoremap <down> :let g:neovide_transparency=g:neovide_transparency-0.1<cr>
endif

" ~~~~~~~~~~~~~~~~~~~~~~~ options ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ {{{2
" ui
set number "Line numbers are good
set relativenumber "Show numbers relative to current line
set mouse=a "Enable mouse usage for all modes (for primary selection to work: hold shift and drag)
set clipboard+=unnamedplus "Yank command always copies to clipboard
set splitbelow "Open split windows below by default
set splitright "Open vsplit windows to the right by default
set list listchars=tab:\|\ ,trail:· "Convert hidden chars to visible symbols
set wrap "Wrap display when textwidth is reached
set formatoptions-=cro " Turn off autcommenting
" set textwidth=0 wrapmargin=0 "turn off auto-wrapping (plugins overwrites it)
" search/substition/completion/case
set inccommand=split "Show substitute changes immediately in separate split
set ignorecase "Case insensitive search
set smartcase "Case sensitive search if there is at least one uppercase letter
set infercase "Inferring case when auto completing
set shortmess+=c "Disable completion menu messages in command line
set complete+=kspell "Enable dict completion when spelling is on
" indentation
set tabstop=2 softtabstop=2 shiftwidth=2
set shiftround "Use multiple of shiftwidth when indenting with '<' and '>'
set noexpandtab "Don't use spaces when inserting a <Tab>.
set smartindent "Do smart autoindenting when starting a new line.
" folding
set foldlevel=99 "Show unfolded document on startup
set foldmethod=marker
set foldcolumn=3
" misc
set history=5000 "Store lots of :cmdline history
set hidden "Hide buffers in background
set scrolloff=5
set iskeyword+=- "Treat dash separated words as a word text object
" set shellcmdflag=-ic "Load shell config
" }}}2

" ~~~~~~~~~~~~~~~~~~~~~~~~~ variables ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ {{{2
let g:mapleader = "\<Space>" "Map leader key to space
" }}}2

" ~~~~~~~~~~~~~~~~~~~~~~~ mappings ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ {{{2
nnoremap <M-w> :wa<cr>
nnoremap <M-q> :qa<cr>
nnoremap <M-d> mmyyp`mj
" Additional bindings to leave insert mode
inoremap jw <esc>
inoremap wj <esc>
inoremap jk <esc>
inoremap kj <esc>
" Keep selection after indentation
xnoremap < <gv
xnoremap > >gv
" <Up> and <Down> filters with prefix. e.g. :help<Up>.
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
" Leave terminal mode with ESC
tnoremap <esc> <C-\><C-n>
tnoremap <C-v><esc> <esc>
" Use <C-r>{register} in terminal insert mode
tnoremap <expr> <C-r> '<C-\><C-N>"'.nr2char(getchar()).'pi'
" Permanent "very magic" mode
" http://vim.wikia.com/wiki/Simplifying_regular_expressions_using_magic_and_no-magic
nnoremap / /\v
xnoremap / /\v
onoremap / /\v
nnoremap ? ?\v
xnoremap ? ?\v
onoremap ? ?\v
cnoremap %s %s/\v
cnoremap g/ g/\v
cnoremap g! g!/\v
cnoremap gn g/\v/normal<left><left><left><left><left><left><left>
nnoremap <c-_> /\V
xnoremap <c-_> /\V
onoremap <c-_> /\V
nnoremap <M-r> :%s/\v//g<left><left><left>
xnoremap <M-r> :s/\v//g<left><left><left>
nnoremap <silent> <C-l> :<C-u>nohlsearch<cr>
" Fixes random freezing
inoremap <f1> <nop>
inoremap <f2> <nop>
inoremap <f3> <nop>
inoremap <f4> <nop>
inoremap <f5> <nop>
inoremap <f6> <nop>
inoremap <f7> <nop>
inoremap <f8> <nop>
inoremap <f9> <nop>
inoremap <f10> <nop>
inoremap <f11> <nop>
inoremap <f12> <nop>
" Better nav for omnicomplete
inoremap <expr> <c-j> ("\<C-n>")
inoremap <expr> <c-k> ("\<C-p>")
nnoremap <silent> <M-n> :e ./notes.txt<cr>
" }}}2

" ~~~~~~~~~~~~~~~~~~~~~~~ autocommands ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ {{{2
augroup general
	au!
	"Mapping for exiting help window with just q
	au BufEnter *.txt if &buftype == 'help' | noremap <buffer> q :q<cr> | endif
	"Open help window vertically
	au BufEnter *.txt if &buftype == 'help' | wincmd L | endif
	" Turn off annoying auto commenting on autocmd, because it keeps reseting
	" autocmd FileType vim,conf set formatoptions-=cro " Does not work...
augroup END

augroup vimrc
	autocmd!
	" Automatically reload changed config file (init.vim or .vimrc)
	autocmd bufwritepost init.vim source $MYVIMRC
augroup END

augroup shmode
	autocmd!
	autocmd FileType sh nnoremap <leader>lf :!shellcheck %<cr>
	autocmd FileType sh nnoremap <silent> K <cmd>lua vim.lsp.buf.hover()<cr>
augroup END

augroup spellmode
	autocmd!
	autocmd FileType gitcommit setlocal spell "Enable spelling by default
augroup END

augroup pymode
	autocmd!
	autocmd FileType python setlocal expandtab tabstop=4 softtabstop=4 shiftwidth=4
	autocmd FileType python nnoremap <silent> K <cmd>lua vim.lsp.buf.hover()<cr>
augroup END

augroup luamode
	autocmd!
	autocmd FileType lua setlocal tabstop=4 softtabstop=4 shiftwidth=4
augroup END
" }}}2

" ~~~~~~~~~~~~~~~~~~~~~~~ functions ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ {{{2

command! -nargs=1 StartAsync call jobstart(<f-args>)

function! Get_visual_selection()
	" Why is this not a built-in Vim script function?!
	let [line_start, column_start] = getpos("'<")[1:2]
	let [line_end, column_end] = getpos("'>")[1:2]
	let lines = getline(line_start, line_end)
	if len(lines) == 0
		return ''
	endif
	let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
	let lines[0] = lines[0][column_start - 1:]
	return join(lines, "\n")
endfunction
" }}}2
" }}}1

" ======================= PACKAGES ======================================= {{{1

packadd minpac
call minpac#init()
call minpac#add('k-takata/minpac', {'type': 'opt'}) "Manage minpac for updates
command! PackUpdate call minpac#update() "Install or update plugins
command! PackClean call minpac#clean() "Uninstall unused plugins
command! PackStatus call minpac#status() "See plugins status

" ~~~~~~~~~~~~~~~~~~~~~~~~~ ui ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ {{{2
" Colorscheme
set termguicolors
call minpac#add('owickstrom/vim-colors-paramount')
call minpac#add('liuchengxu/space-vim-dark')
call minpac#add('endel/vim-github-colorscheme')
call minpac#add('bluz71/vim-moonfly-colors')
function! Toggle_colorcheme()
		if g:colorscheme == 1
			set colorcolumn=999
			set nocursorline
			set nocursorcolumn
			augroup ui
				autocmd!
			augroup END
			" colorscheme moonfly
			colorscheme paramount
			hi QuickScopePrimary guifg=NONE gui=underline guisp=#5FD7A7 ctermfg=NONE cterm=underline
			let g:colorscheme = 2
		elseif g:colorscheme == 2
			colorscheme github
			hi Comment gui=italic
			hi Comment guifg=#5c6370 ctermfg=59
			hi QuickScopePrimary guifg=NONE gui=underline guisp=#5FD7A7 ctermfg=NONE cterm=underline 
			set colorcolumn=80 "Nicer code -> better code
			set cursorline "Highlight current line
			let g:colorscheme = 0
		else
			set colorcolumn=80 "Nicer code -> better code
			set cursorline "Highlight current line
			set cursorcolumn "Highlight current column
			" Only show cursor lines in selected window
			augroup ui
				autocmd!
				au WinLeave * set nocursorline nocursorcolumn colorcolumn=""
				au WinEnter * set cursorline cursorcolumn colorcolumn=80
			augroup END
			colorscheme space-vim-dark
			hi Comment guifg=#5c6370 ctermfg=59
			hi QuickScopePrimary guifg=NONE gui=underline guisp=#5FD7A7 ctermfg=NONE cterm=underline 
			let g:colorscheme = 1
		endif
		au VimEnter * hi QuickScopePrimary guifg=NONE gui=underline guisp=#5FD7A7 ctermfg=NONE cterm=underline 
		" au VimEnter * hi Sneak guifg=black guibg=#5FD7A7 ctermfg=black ctermbg=10
		" au VimEnter * hi SneakScope guifg=black guibg=#5FD7A7 ctermfg=black ctermbg=10
endfunction
let g:colorscheme = 1
call Toggle_colorcheme()
nnoremap <leader>oc :call Toggle_colorcheme()<cr>

call minpac#add('machakann/vim-highlightedyank')
call minpac#add('itchyny/lightline.vim')
" remove -- INSERT --
set noshowmode 
" \ 'colorscheme': 'Tomorrow_Night',
let g:lightline = {
			\ 'colorscheme': 'moonfly',
			\ 'active': {
			\   'left': [ [ 'mode', 'paste' ],
			\             [ 'readonly', 'filename', 'modified', 'scnvim' ] ]
			\ },
			\ 'component_function': {
			\   'scnvim': 'scnvim#statusline#server_status'
			\ },
			\ }
let g:lightline.mode_map = {
			\ 'n' : 'n',
			\ 'i' : 'i',
			\ 'R' : 'r',
			\ 'v' : 'v',
			\ 'V' : 'vl',
			\ "\<C-v>": 'vb',
			\ 'c' : 'c',
			\ 's' : 's',
			\ 'S' : 'sl',
			\ "\<C-s>": 'sb',
			\ 't': 't',
			\ }
call minpac#add('mboughaba/i3config.vim')
" }}}2
" ~~~~~~~~~~~~~~~~~~~~~~~~~ mappings ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ {{{2
call minpac#add("liuchengxu/vim-which-key")
packadd! vim-which-key "Add to runtimepath during init
set timeoutlen=1000 "Delay to show which-key pop up
let g:which_key_map =  {} "Define prefix dictionary
call which_key#register('<Space>', "g:which_key_map") "Register prefix dict
nnoremap <silent> <leader> :<c-u>WhichKey '<space>'<cr>
xnoremap <silent> <leader> :<c-u>WhichKeyVisual '<space>'<cr>
" Don't use neovim's floating win, because it's ugly and not transparent
let g:which_key_use_floating_win = 0 
" Buffers
nnoremap <leader>bn :bnext<cr>
nnoremap <leader>bp :bprevious<cr>
"Alternate between buffers same as <C-^>
nnoremap <leader><tab> :e #<cr>
nnoremap <leader>bd :bdelete<cr>
nnoremap <leader>bD :bdelete!<cr>
let g:which_key_map.b = {
			\ 'name' : '+buffer' ,
			\ 'd' : 'delete-buffer',
			\ 'D' : 'delete-buffer-unsaved!',
			\ 'n' : 'next-buffer',
			\ 'p' : 'previous-buffer',
			\ 'b' : 'fzf-switch-buffer'
			\ }
let g:which_key_map['<Tab>'] = "alternate-buffer"
" Files
nnoremap <leader>fed :e $MYVIMRC<cr>
let g:which_key_map.f = {
			\ 'name' : '+file' ,
			\ 'f' :'fzf-find-file',
			\ 'e' : {
			\ 'name' : '+edit',
			\ 's' : 'snippets-file',
			\ 'd' : '(n)vim-dotfile'
			\ }, 
			\ }
" Tabs
nnoremap <leader>td :tabclose<cr>
nnoremap <leader>tn :tabnext<cr>
nnoremap <leader>tp :tabprevious<cr>
nnoremap <leader>tL :tabm +1<cr>
nnoremap <leader>tH :tabm -1<cr>
nnoremap <silent> <M-1> 1gt
nnoremap <silent> <M-2> 2gt
nnoremap <silent> <M-3> 3gt
nnoremap <silent> <M-4> 4gt
" Go to last active tab
au TabLeave * let g:lasttab = tabpagenr()
nnoremap <silent> <M-tab> :exe "tabn ".g:lasttab<cr>
vnoremap <silent> <M-tab> :exe "tabn ".g:lasttab<cr>
let g:which_key_map.t = {
			\ 'name' : '+tab' ,
			\ 'd' : 'close-tab',
			\ 'n' : 'next-tab',
			\ 'p' : 'prev-tab',
			\ }
" Windows
nnoremap <leader>wj <C-w>j
nnoremap <leader>wk <C-w>k
nnoremap <leader>wh <C-w>h
nnoremap <leader>wl <C-w>l
nnoremap <leader>ww :wincmd w<cr>
" Opening windows
nnoremap <leader>ws <C-w>s
nnoremap <leader>wv <C-w>v
" Delete window
nnoremap <leader>wd <C-w>c
" Delete all others windows
nnoremap <leader>wm <C-w>o
" Moving windows
nnoremap <leader>wJ <C-w>J
nnoremap <leader>wK <C-w>K
nnoremap <leader>wH <C-w>H
nnoremap <leader>wL <C-w>L
" Resizing
nnoremap <leader>w= <c-w>=
" Maximize horizontally
nnoremap <leader>w_ <c-w>_
" Maximize vertically
nnoremap <leader>w\| <c-w>\|
" Maximaze v and h
nnoremap <leader>w0 <c-w>\| \| <c-w>_
let g:which_key_map['w'] = {
			\ 'name' : '+windows' ,
			\ 'w' : 'alternate-window',
			\ 'd' : 'delete-window',
			\ 'h' : 'window-left',
			\ 'j' : 'window-below',
			\ 'l' : 'window-right',
			\ 'k' : 'window-up',
			\ 'H' : 'move-window-left',
			\ 'J' : 'move-window-below',
			\ 'L' : 'move-window-right',
			\ 'K' : 'move-window-up',
			\ '=' : 'balance-window',
			\ 'm' : 'maximize-window',
			\ 's' : 'split-window-below',
			\ 'v' : 'split-window-right',
			\ '_' : 'maximize-horizontally',
			\ '|' : 'maximize-vertically',
			\ '0' : 'maximize-both-axis',
			\ }
" Quickfix
nnoremap <leader>qn :cnext<cr>
nnoremap <leader>qp :cprevious<cr>
nnoremap <leader>qj :cnext<cr>
nnoremap <leader>qk :cprevious<cr>
nnoremap <leader>q0 :cfirst<cr>
nnoremap <leader>q$ :clast<cr>
nnoremap <silent> <leader>qq :cclose<cr>
" Folding
nnoremap <leader>z zMzv
" Dictionary
nnoremap <leader>d= z=
let g:which_key_map.d = {
			\ 'name' : '+dict' ,
			\ '=' : 'corrections',
			\ }
" Help
let g:which_key_map.h = {
			\ 'name' : '+help' ,
			\ 'h' : 'fzf-help-tags',
			\ }
" Toggles/Options
nnoremap <leader>ol :set list!<cr>
nnoremap <leader>os :setlocal spell! spelllang=en_us<cr>
let g:which_key_map.o = {
			\ 'name' : '+options' ,
			\ 's' : 'toggle-spelling',
			\ 't' : 'toggle-list-chars',
			\ }
" Vim
" Helpers to execute vim code for rapid testing
" https://github.com/saaguero/vim-utils/blob/master/plugin/utils.vim
" source vimscript operator
function! SourceVimscript(type)
	let sel_save = &selection
	let &selection = "inclusive"
	let reg_save = @"
	if a:type == 'line'
		silent execute "normal! '[V']y"
	elseif a:type == 'char'
		silent execute "normal! `[v`]y"
	elseif a:type == "visual"
		silent execute "normal! gvy"
	elseif a:type == "currentline"
		silent execute "normal! yy"
	endif
	let @" = substitute(@", '\n\s*\\', '', 'g')
	" source the content
	@"
	let &selection = sel_save
	let @" = reg_save
endfunction
nnoremap <silent> gs :set opfunc=SourceVimscript<CR>g@
nnoremap <silent> <leader>vv :call SourceVimscript("currentline")<CR>
nnoremap <silent> <M-v> :call SourceVimscript("currentline")<CR>
xnoremap <silent> gs :set opfunc=SourceVimscript<CR>g@
xnoremap <silent> <leader>vv :<C-U>call SourceVimscript("visual")<CR>
xnoremap <silent> <M-v> :<C-U>call SourceVimscript("visual")<CR>
nnoremap <leader>vs :source $MYVIMRC<cr>
let g:which_key_map.v = {
			\ 'name' : '+vim' ,
			\ 'v' : 'execute-vimscript-line-or-visual',
			\ 's' : 'source-vimscript'
			\ }
" Text editing and moving {{{2
call minpac#add('tpope/vim-commentary') "Comment stuff out
map <M-c> mmgcc`m
map <M-g> mmgccyypgcc`mj
call minpac#add('tpope/vim-surround') "Quoting/parenthesizing made simple
" Improvement upon vim-surround. Adds function text-object to act upon.
" https://gist.github.com/romgrk/35186f3b5a71a7d89b2229b6f73e4f32
nnoremap dsf  :call surroundfunc#DSurroundFunc()<cr>
nnoremap csf  :call surroundfunc#CSurroundFunc()<cr>
call minpac#add('tpope/vim-rsi') "Some Emacs bindings for insert and cmdline mode
call minpac#add('tpope/vim-unimpaired')
nmap <leader>j mm]<space>`m
nmap <leader>k mm[<space>`m
" Bubble single lines
nmap <C-k> [e
nmap <C-j> ]e
" Bubble multiple lines
xmap <C-k> [egv
xmap <C-j> ]egv
call minpac#add('tpope/vim-repeat')
call minpac#add('tommcdo/vim-exchange') "Easy text exchange operator for Vim
call minpac#add('thinca/vim-visualstar') "Makes * and # work on visual mode too.
call minpac#add('cohama/lexima.vim') "Auto close
inoremap <M-[> [
inoremap <M-9> (
inoremap <M-'> '
inoremap <M-"> "
inoremap <M-{> {
inoremap <M-,> <
inoremap <M-`> `
"Replace text with the contents of a register
call minpac#add('vim-scripts/ReplaceWithRegister') 
call minpac#add('FooSoft/vim-argwrap')
nnoremap <silent> <M-a> :ArgWrap<cr>
call minpac#add('justinmk/vim-sneak') "Jump to any location specified by two characters
let g:sneak#label = 1
let g:sneak#s_next = 1 "Move to next match by hitting `s` (or `S`) again
" Case sensitivity is determined by 'ignorecase' and 'smartcase'
let g:sneak#use_ic_scs = 1
" One-character Sneak similar to clever-F plugin.
map , <Plug>Sneak_,
map f <Plug>Sneak_f
map F <Plug>Sneak_F
map t <Plug>Sneak_t
map T <Plug>Sneak_T
call minpac#add('unblevable/quick-scope') "Lightning fast left-right movement in Vim
let g:qs_second_highlight = 0
call minpac#add('kana/vim-textobj-user') "Required by plugins below
call minpac#add('kana/vim-textobj-line') "Text objects for the current line
call minpac#add('kana/vim-textobj-indent') "ai/ii / aI/iI
call minpac#add('somini/vim-textobj-fold')
call minpac#add('Julian/vim-textobj-brace') "aj / ij
call minpac#add('beloglazov/vim-textobj-quotes') "aq / iq
call minpac#add('sgur/vim-textobj-parameter') "aa / ia
let g:vim_textobj_parameter_mapping = 'a'
call minpac#add('thinca/vim-textobj-between')
nmap cx4 cxif$
nmap d4 dif$x
nmap c4 cif$<space><space><left>
nmap cx3 cxif#
nmap d3 dif#x
nmap c3 cif#<space><space><left>
omap i, if,
omap a, af,
xmap i, if,
xmap a, af,
 "Provides a text object Snake and underscore cases
call minpac#add('Julian/vim-textobj-variable-segment')
" }}}2

" IDE like {{{2
call minpac#add('tpope/vim-fugitive') "Git integration
augroup fugitive_au
	au!
	" Stop warning
	au FileType git nnoremap <buffer> q <c-w>q
	au BufEnter * let g:fugitive_git_executable = 'git_fugitive ' . expand('%:p:h') . '/.git'
augroup END
nnoremap <leader>gs :Git status<cr>
nnoremap <leader>g5 :Git add %<cr>
nnoremap <leader>ga :Git add<space>
nnoremap <leader>gc :Git commit<cr>
nnoremap <leader>gp :Git push<cr>
nnoremap <leader>gP :Git pull<cr>
nnoremap <leader>gd :Git diff<cr>
nnoremap <leader>gl :Git log<cr>
call minpac#add('Shougo/deoplete.nvim') "Asynchronous completion
let g:deoplete#enable_at_startup = 1
call minpac#add('deoplete-plugins/deoplete-tag') "Source for ctags
call minpac#add('deathlyfrantic/deoplete-spell') "Requires :set spell
call minpac#add('deoplete-plugins/deoplete-dictionary')
call minpac#add('Shougo/deoplete-lsp')
call minpac#add("SirVer/ultisnips")
let g:UltiSnipsEditSplit="horizontal"
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
nnoremap <silent> <leader>fes :UltiSnipsEdit<cr>
nnoremap <silent> <M-9> :UltiSnipsEdit<cr>
au TabLeave * call UltiSnips#LeavingBuffer() "Fixes freezing when changing tabs
call minpac#add('kassio/neoterm')
let g:neoterm_autoscroll = 1 "scroll to the end of its buffer after running any
let g:neoterm_default_mod = "vertical"
" let g:neoterm_size = "10"
let g:neoterm_repl_enable_ipython_paste_magic = 1
" Send the commands to the neoterm buffer linked to the current tab instead of the last active neoterm.
let g:neoterm_term_per_tab=1
nmap gx <Plug>(neoterm-repl-send)
" Send selected contents in visual mode.
xmap gx <Plug>(neoterm-repl-send)
nmap gxx <Plug>(neoterm-repl-send-line)
augroup neoterm_au
	autocmd!
	autocmd FileType r,rmd,haskell,python nnoremap <buffer> <M-j> :TREPLSendLine<cr>
	autocmd FileType r,rmd,haskell,python inoremap <buffer> <M-j> <C-o>:TREPLSendLine<cr>
	autocmd FileType r,rmd,haskell,python nnoremap <buffer> <M-e> mmvip:TREPLSendSelection<cr>`m
	autocmd FileType r,rmd,haskell,python xnoremap <buffer> <M-e> :TREPLSendSelection<cr>
	autocmd FileType r,rmd,haskell,python inoremap <buffer> <M-e> <C-o>vip:TREPLSendSelection<cr>`m
	autocmd FileType r,rmd,haskell,python nnoremap <buffer> <M-o> mmvip:TREPLSendSelection`m<cr>
	autocmd FileType r,rmd,haskell,python xnoremap <buffer> <M-o> :TREPLSendSelection<cr>
	autocmd FileType r,rmd,haskell,python nnoremap <buffer> <M-p> mmvip:TREPLSendSelection<cr>`m
	autocmd FileType r,rmd,haskell,python xnoremap <buffer> <M-p> :TREPLSendSelection<cr>
	autocmd FileType r,rmd,haskell,python nnoremap <buffer> <M-l> :Tclear<cr>
	autocmd FileType r,rmd,haskell nnoremap <buffer> <M-u> :Ttoggle<cr>
	autocmd FileType r,rmd,haskell nnoremap <buffer> <M-k> :Tkill<cr>
augroup END

call minpac#add('kevinhwang91/rnvimr') " Ranger integration
nnoremap <silent> <leader>r :RnvimrToggle<cr>
" Make Ranger to be hidden after picking a file
let g:rnvimr_enable_picker = 1
let g:rnvimr_presets = [ {'width': 0.800, 'height': 0.800},
			\ {'width': 0.950, 'height': 0.950},
			\ {'width': 0.700, 'height': 0.700} ]
call minpac#add('junegunn/fzf', { 'do': './install --bin'}) "Intall fzf only for vim
call minpac#add('junegunn/fzf.vim') "Bundle of fzf-based commands and mappings
" Define way to open fzf line
let g:fzf_action = {
			\ 'ctrl-t': 'tab split',
			\ 'ctrl-s': 'split',
			\ 'ctrl-v': 'vsplit' }
" Make commands with preview window
command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

" Using floating windows of Neovim to start fzf
" https://github.com/junegunn/fzf/blob/master/README-VIM.md#fzfrun
if has('nvim')
  let $FZF_DEFAULT_OPTS .= ' --border --margin=0,2'
  function! FloatingFZF()
    let width = float2nr(&columns * 0.9)
    let height = float2nr(&lines * 0.6)
    let opts = { 'relative': 'editor',
               \ 'row': (&lines - height) / 2,
               \ 'col': (&columns - width) / 2,
               \ 'width': width,
               \ 'height': height }
    let win = nvim_open_win(nvim_create_buf(v:false, v:true), v:true, opts)
    call setwinvar(win, '&winhighlight', 'NormalFloat:Normal')
  endfunction
  let g:fzf_layout = { 'window': 'call FloatingFZF()' }
endif
"Files (similar to :FZF)
nnoremap <leader>ff :Files<cr> 
nnoremap <leader>bb :Buffers<cr>
nnoremap <M-b> :Buffers<cr>
nnoremap <leader>; :History:<cr>
nnoremap <leader>/ :History:<cr>
" Search lines in loaded buffers
nnoremap <leader>sl :Lines<cr>
nnoremap <M-8> :execute "Lines '" . expand("<cword>")<cr>
inoremap <M-8> <esc>:execute "Lines '" . expand("<cword>")<cr>
xnoremap <M-8> <esc>:execute "Lines '" . expand("<cword>")<cr>
" Search lines in the current buffer
nnoremap <C-s> :BLines<cr>
inoremap <C-s> <esc>:BLines<cr>
xnoremap <C-s> <esc>:BLines<cr>
" Vim help tags
nnoremap <leader>hh :Helptags<cr>
nnoremap <leader>sg :Rg<space>
nnoremap <leader>s8 :execute 'Rg ' . expand('<cword>')<cr>
command! -bang -nargs=* GGrep
  \ call fzf#vim#grep(
  \   'git grep --line-number -- '.shellescape(<q-args>), 0,
  \   fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}), <bang>0)
nnoremap <leader>gg :GGrep<space>
nnoremap <M-`> :Marks<cr>
call minpac#add('liuchengxu/vista.vim')
let g:vista_default_executive = 'lspconfig'
let g:vista#renderer#enable_icon = 1
let g:vista_echo_cursor_strategy = 'echo'
autocmd FileType vista,vista_kind nnoremap <buffer> <silent> / :<c-u>call vista#finder#fzf#Run()<cr>
nnoremap <silent> <M-space> :Vista!!<cr>
" }}}2

" Markdown {{{2
augroup mdmode
	autocmd!
	autocmd FileType markdown setlocal expandtab tabstop=2 softtabstop=2 shiftwidth=2
augroup END
" }}}2

call minpac#add('dkarter/bullets.vim')
" Bullets.vim
let g:bullets_enabled_file_types = ['markdown']
let g:bullets_enable_in_empty_buffers = 0
call minpac#add('iamcco/markdown-preview.nvim', {'do': 'packloadall! | call mkdp#util#install()'})
" specify browser to open preview page
" default: ''
let g:mkdp_browser = 'qutebrowser'
nmap <M-e> <Plug>MarkdownPreview
nmap <M-k> <Plug>MarkdownPreviewStop
nmap <M-u> <Plug>MarkdownPreviewToggle
" }}}2

" LSP (langage server protocol) {{{2
call minpac#add('neovim/nvim-lspconfig')

lua <<EOF
vim.cmd('packadd nvim-lspconfig')  -- If installed as a Vim "package".
require'lspconfig'.r_language_server.setup{}
require'lspconfig'.bashls.setup{}
EOF

nnoremap <leader>ld <cmd>lua vim.lsp.buf.definition()<cr>
nnoremap <C-h> <cmd>lua vim.lsp.buf.hover()<cr>
nnoremap <leader>lF <cmd>lua vim.lsp.buf.formatting()<cr>
vnoremap <leader>lf :lua vim.lsp.buf.range_formatting()<cr>
nnoremap <leader>lr <cmd>lua vim.lsp.buf.references()<CR>

" diagnostic-nvim
nnoremap <silent> <C-p> :lua vim.lsp.diagnostic.goto_prev()<cr>
nnoremap <silent> <C-n> :lua vim.lsp.diagnostic.goto_next()<cr>

lua << EOF
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    -- This will disable virtual text, like doing:
    -- let g:diagnostic_enable_virtual_text = 0
    virtual_text = false,
    -- This is similar to:
    -- let g:diagnostic_show_sign = 1
    -- To configure sign display,
    --  see: ":help vim.lsp.diagnostic.set_signs()"
    signs = true,
    -- This is similar to:
    -- "let g:diagnostic_insert_delay = 1"
    update_in_insert = false,
  }
)
EOF

" }}}2

" R language {{{2
function! R_init()
	:vertical Tnew
	:T R
	" :Tclear
endfunction

let r_indent_align_args = 0

augroup rmode
	autocmd!
	autocmd FileType r,rmd setlocal expandtab tabstop=2 softtabstop=2 shiftwidth=2 "Use spaces for tabs
	autocmd FileType r,rmd nnoremap <silent> K <cmd>lua vim.lsp.buf.hover()<cr>
	autocmd FileType r,rmd inoremap <buffer> <M--> <-
	autocmd FileType r,rmd inoremap <buffer> <M-=> %>%
	autocmd FileType r,rmd inoremap <buffer> <M-+> %T>%
	autocmd FileType r,rmd nnoremap <buffer> <M-cr> :call R_init()<cr>
	autocmd FileType r,rmd inoremap <buffer> <M-cr> <cr><cr><up><tab>
	autocmd FileType rmd nnoremap <buffer> <F1> :!source ~/.zshrc && knit %<cr>
	autocmd FileType r,rmd nnoremap <buffer> <M-y> :T shinytest::recordTest()<cr>
	autocmd FileType r,rmd nnoremap <buffer> <M-t> :T shinytest::testApp()<cr>
augroup END
" }}}2

" Music {{{2
call minpac#add('davidgranstrom/scnvim')
let g:scnvim_no_mappings = 1
" default is half the terminal size for vertical and a third for horizontal
let g:scnvim_postwin_size = 60
" automatically open post window on a SuperCollider error
let g:scnvim_postwin_auto_toggle = 0
" set this variable if you don't want the "echo args" feature
let g:scnvim_echo_args = 0
" set this variable to browse SuperCollider documentation in nvim (requires `pandoc`)
let g:scnvim_scdoc = 0
let g:scnvim_statusline_interval = 10

function! Toggle_scnvim_scdoc()
	if g:scnvim_scdoc
		let g:scnvim_scdoc = 0
	else
		let g:scnvim_scdoc = 1
	endif
	echo g:scnvim_scdoc
endfunction

function! Pattern_summary()
	execute 'call scnvim#sclang#send("~pattern_summary.value(' . Get_visual_selection() . ')")'
endfunction

function! Scale_summary(item)
	execute 'call scnvim#sclang#send("~scale_summary.value(Scale.' . a:item . ')")'
endfunction

function! Sample_fetch(item)
	execute 'call scnvim#sclang#send("~read_dirt_samples1.value(' . '\"' . a:item . '\"' . ')")'
endfunction

function! All_init()
	" call Foxdot_init()
	" sleep 1
	call Tidal_init()
	call Improviz_init()
	" call Espgrid_init()
endfunction

augroup sc_au
	autocmd!
	" init
	autocmd FileType supercollider,tidal,python ColorizerAttachToBuffer
	autocmd FileType supercollider setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
	autocmd FileType supercollider set dictionary+=~/sp/dict/colors.txt
	autocmd FileType supercollider setlocal dictionary+=~/sp/dict/samples.txt
	autocmd FileType supercollider setlocal dictionary+=~/sp/dict/sc/synths.txt
	autocmd FileType supercollider setlocal dictionary+=~/sp/dict/sc/controls.txt
	autocmd FileType supercollider nnoremap <silent> <buffer> <M-s> :e ./snips.scd<cr>
	autocmd VimEnter *.scd normal G
	" autocmd VimEnter *.scd Limelight!!
	" autocmd VimEnter *.scd RainbowParentheses!!
	autocmd VimEnter *.scd SCNvimStart
	autocmd VimEnter *.scd SCNvimStatusLine
	autocmd VimEnter *.scd :badd ~/.config/SuperCollider/startup.scd
	autocmd VimEnter *.scd :badd ~/.config/SuperCollider/synthdef/synth_def.scd
	autocmd VimEnter *.scd :badd ~/.config/SuperCollider/synthdef/Main.sc
	autocmd VimEnter *.scd :badd ~/sp/dict/sc/synths.txt
	autocmd VimEnter *.scd :badd ~/sp/dict/sc/controls.txt
	autocmd VimEnter *.scd :badd ~/sp/a/bitwig.txt
	"mappings
	autocmd FileType supercollider inoremap <buffer> <M-cr> <cr><cr><up><tab>
	autocmd VimEnter *.scd nmap <M-e> <Plug>(scnvim-send-block)
	autocmd VimEnter *.scd imap <M-e> <C-o><Plug>(scnvim-send-block)
	autocmd VimEnter *.scd xmap <M-e> <Plug>(scnvim-send-selection)
	autocmd VimEnter *.scd nmap <M-j> <Plug>(scnvim-send-line)
	autocmd VimEnter *.scd imap <M-j> <C-o><Plug>(scnvim-send-line)
	autocmd VimEnter *.scd nmap <M-k> <Plug>(scnvim-hard-stop)
	autocmd VimEnter *.scd imap <M-k> <C-o><Plug>(scnvim-hard-stop)
	autocmd VimEnter *.scd nmap <M-u> <Plug>(scnvim-postwindow-toggle)
	autocmd VimEnter *.scd imap <M-u> <C-o><Plug>(scnvim-postwindow-toggle)
	autocmd VimEnter *.scd nmap <M-l> <Plug>(scnvim-postwindow-clear)
	autocmd VimEnter *.scd imap <M-l> <C-o><Plug>(scnvim-postwindow-clear)
	autocmd VimEnter *.scd nmap <M-h> :SCNvimHelp<space>
	autocmd VimEnter *.scd nmap <M-o> vip<Plug>(scnvim-send-selection)
	autocmd VimEnter *.scd imap <M-o> <C-o>vip<Plug>(scnvim-send-selection)
	autocmd VimEnter *.scd nmap <M-p> mmvip<Plug>(scnvim-send-selection)`m
	autocmd VimEnter *.scd nmap <M-i> viz<Plug>(scnvim-send-selection)
	autocmd VimEnter *.scd imap <M-i> <C-o>viz<Plug>(scnvim-send-selection)
	autocmd VimEnter *.scd nmap <M-i> <C-o>viz<Plug>(scnvim-send-selection)
	autocmd VimEnter *.scd nmap <M-0> :call scnvim#sclang#send("~toggle_mute.value()")<cr>
	autocmd VimEnter *.scd nmap <silent> <M-=> :call scnvim#sclang#send("s.volume.volume = s.volume.volume + 5; s.volume.volume")<cr>
	autocmd VimEnter *.scd nmap <silent> <M--> :call scnvim#sclang#send("s.volume.volume = s.volume.volume - 5; s.volume.volume")<cr>
	autocmd VimEnter *.scd nnoremap <M-m> :call scnvim#sclang#send("NdefMixer(s, 24)")<cr>
	autocmd VimEnter *.scd nnoremap <M-,> :call scnvim#sclang#send("Pdef.gui(24)")<cr>
	autocmd VimEnter *.scd nnoremap <M-t> :call scnvim#sclang#send("~global_tempo.value()")<left><left><left>
	autocmd VimEnter *.scd xnoremap <leader><leader>n :call Pattern_summary()<cr>
	autocmd VimEnter *.scd nmap <leader><leader>n mm?P<cr>v%:call Pattern_summary()<cr><C-l>`m
	autocmd VimEnter *.scd nnoremap <leader><leader>1 :call fzf#run({ 'source':  'cat ~/sp/dict/sc/scales.txt', 'sink': function('Scale_summary') })<cr>
	autocmd VimEnter *.scd nnoremap <leader><leader>2 :call fzf#run({ 'source':  'cat ~/sp/dict/samples.txt', 'sink': function('Sample_fetch') })<cr>
	" Show samples dir tree
	autocmd VimEnter *.scd nnoremap <leader><leader>3 :!tree ~/sp/Dirt-Samples/<cword>
	autocmd VimEnter *.scd nnoremap <leader><leader>h :call Toggle_scnvim_scdoc()<cr>
	autocmd VimEnter *.scd nnoremap <leader><leader>s :call scnvim#sclang#send("s.scope")<cr>
	autocmd VimEnter *.scd nnoremap <leader><leader>f :call scnvim#sclang#send("FreqScope.new(1200)")<cr>
	autocmd VimEnter *.scd nnoremap <leader><leader>t :call scnvim#sclang#send("s.plotTree")<cr>
	autocmd VimEnter *.scd nnoremap <silent> <leader><leader>] :SCNvimRecompile<cr>
	autocmd VimEnter *.scd nnoremap <silent> <leader><leader>T :SCNvimTags<cr>
	" midi/tidal/foxdot/imroviz
	autocmd VimEnter *.scd nnoremap <leader><leader>m :call scnvim#sclang#send("~midi_start.()")<cr>
	autocmd VimEnter *.scd nnoremap <leader><leader>b :call scnvim#sclang#send("~bitwig_start.()")<cr>
	autocmd VimEnter *.scd nnoremap <leader><leader>v :call Improviz_init()<cr>
	autocmd VimEnter *.scd nnoremap <leader><leader>c :call Tidal_init()<cr>
	autocmd VimEnter *.scd nnoremap <leader><leader>p :call Foxdot_init()<cr>
	autocmd VimEnter *.scd nnoremap <leader><leader>e :call Espgrid_init()<cr>
	autocmd VimEnter *.scd nnoremap <leader><leader>F :call Faust_init()<cr>

	autocmd VimEnter *.scd nnoremap <leader><leader>d :call scnvim#sclang#send('(Platform.userConfigDir +/+ "SC-808/SC-808.scd").load')<cr>
	autocmd VimEnter *.scd nnoremap <leader><leader>a :StartAsync ardour6 ardour_a<cr>
	autocmd VimEnter *.scd nnoremap <leader><leader>r :StartAsync carla<cr>
	autocmd VimEnter *.scd nnoremap <leader><leader>A :call Hydra_init()<cr>
	autocmd VimEnter *.scd nnoremap <leader><leader>i :call All_init()<cr>
	" Ardour
	autocmd VimEnter *.scd nnoremap <leader>ae :call scnvim#sclang#send("a.play")<cr>
	autocmd VimEnter *.scd nnoremap <leader>ak :call scnvim#sclang#send("a.stop")<cr>
	autocmd VimEnter *.scd nnoremap <leader>aa :call scnvim#sclang#send("a.start")<cr>
	autocmd VimEnter *.scd nnoremap <leader>ae :call scnvim#sclang#send("a.end")<cr>
	autocmd VimEnter *.scd nnoremap <leader>ar :call scnvim#sclang#send("a.rec_enable_toggle")<cr>
augroup END

" Haskell
call minpac#add('mantsar/vim-haskell-indent')

function! Haskell_init()
	:vertical Tnew
	:T ghci
	" :Tclear
endfunction

augroup hs_au
	autocmd!
	autocmd FileType haskell setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab
	autocmd FileType haskell nnoremap <buffer> <M-cr> :call Haskell_init()<cr>
	autocmd BufNewFile,BufRead *.ghci setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab
augroup END

" Tidal
call minpac#add('tidalcycles/vim-tidal')
let g:tidal_activated = 0

function! Tidal_init()
	let g:tidal_activated = 1
	execute "tabe " . expand("%:r") . ".tidal"
	call scnvim#sclang#send("~superdirt_start.value()")
	:TidalHush
	:wincmd j
	" :wincmd L
	" :resize 8
	:wincmd k
	:normal G
endfunction

let g:tidal_no_mappings = 1
let g:tidal_target = "terminal"

xnoremap <M-8> <esc>:execute "Lines '" . expand("<cword>")<cr>

function Is_comment()
    let hg = join(map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")'))
    return hg =~? 'comment' ? 1 : 0
endfunction

function Hard_stop_tidal()
	nnoremap <buffer> <M-C-k> :call scnvim#hard_stop() <bar> TidalHush<cr>
endfunction

augroup tidal_au
	autocmd!
	autocmd FileType tidal setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
	autocmd FileType tidal setlocal commentstring=--\%s
	autocmd FileType tidal setlocal formatoptions-=j "Do not concatenate # on J
	autocmd FileType tidal :badd ~/.config/SuperCollider/synthdef/default-synths-extra.scd
	autocmd FileType tidal :badd ~/.config/SuperCollider/synthdef/effects-extra.scd
	autocmd FileType tidal :badd ~/sp/tidal/Tidal.ghci
	autocmd FileType tidal setlocal dictionary+=~/sp/dict/samples.txt
	autocmd FileType tidal setlocal dictionary+=~/sp/dict/tidal/functions.txt
	autocmd FileType tidal setlocal dictionary+=~/sp/dict/tidal/controls.txt
	autocmd FileType tidal setlocal dictionary+=~/sp/dict/tidal/chords.txt
	autocmd FileType tidal setlocal dictionary+=~/sp/dict/tidal/arpeggiators.txt
	autocmd FileType tidal setlocal dictionary+=~/sp/dict/tidal/synths.txt
	autocmd FileType tidal :badd ~/sp/dict/tidal/synths.txt
	autocmd FileType tidal :badd ~/sp/dict/tidal/controls.txt
	autocmd FileType tidal inoremap <buffer> <M-cr> <cr>$<space>
	autocmd FileType tidal inoremap <buffer> <M-m> <cr>#<space>
	autocmd FileType tidal nnoremap <silent> <buffer> K :execute "StartAsync qutebrowser 'https://tidalcycles.org/index.php?search=" . expand("<cword>") . "'"<cr>
	autocmd FileType tidal nnoremap <buffer> <leader><leader>1 :TidalSend1 numberNoteMap<cr>
	autocmd FileType tidal nnoremap <silent> <buffer> <expr> <M-a> Is_comment() ? '' : 'v$:s/\%V\(\$\\|#\)/\r\1<cr>lmmk$x`m'
	autocmd FileType tidal nnoremap <silent> <buffer> <M-s> :e ./snips.tidal<cr>
	" Always autoscroll
	autocmd FileType tidal nmap <M-u> <Plug>(scnvim-postwindow-toggle):call scnvim#sclang#send("nil")<cr>
	autocmd FileType tidal imap <M-u> <C-o><Plug>(scnvim-postwindow-toggle):call scnvim#sclang#send("nil")<cr>
	autocmd FileType tidal xmap <buffer> <M-e> <Plug>TidalRegionSend
	autocmd FileType tidal xmap <buffer> <M-p> <Plug>TidalRegionSend
	autocmd FileType tidal xmap <buffer> <M-o> <Plug>TidalRegionSend
	autocmd FileType tidal nmap <buffer> <M-j> <Plug>TidalLineSend
	autocmd FileType tidal imap <buffer> <M-j> <C-o><Plug>TidalLineSend
	autocmd FileType tidal nmap <buffer> <M-e> <Plug>TidalParagraphSend
	autocmd FileType tidal imap <buffer> <M-e> <esc><Plug>TidalParagraphSend<esc>i<right>
	autocmd FileType tidal nmap <buffer> <M-p> <Plug>TidalParagraphSend
	autocmd FileType tidal nmap <buffer> <M-o> <Plug>TidalParagraphSend
	autocmd FileType tidal imap <buffer> <M-o> <esc><Plug>TidalParagraphSend<esc>i<right>
	autocmd FileType tidal nnoremap <buffer> <M-k> mm:TidalHush<cr>`m
	autocmd FileType tidal :call Hard_stop_tidal()
	autocmd FileType tidal nnoremap <buffer> <M-t> :TidalSend1 setcps<space>
	au FileType tidal call lexima#add_rule({'char': '<', 'input_after': '>', 'filetype': 'tidal'})
	au FileType tidal call lexima#add_rule({'char': '<Space>', 'at': '<\%#>', 'input_after': '<Space>', 'filetype': 'tidal'})
	au FileType tidal call lexima#add_rule({'char': '>', 'at': '\%#>', 'leave': 1, 'filetype': 'tidal'})
	au FileType tidal call lexima#add_rule({'char': '<BS>', 'at': '<\%#>', 'delete': 1, 'filetype': 'tidal'})
	au FileType tidal call lexima#add_rule({'char': '<CR>', 'at': '<\%#>', 'input_after': '<CR>', 'filetype': 'tidal'})
	au FileType tidal call lexima#add_rule({'char': '<CR>', 'at': '\<\%#$', 'input_after': '<CR>]', 'except': '\C\v^(\s*)\S.*%#\n%(%(\s*|\1\s.+)\n)*\1\]', 'filetype': 'tidal'})
	autocmd FileType tidal nnoremap <buffer> <f1> {:TidalPlay 1<cr>
	autocmd FileType tidal nnoremap <buffer> <f2> {:TidalPlay 2<cr>
	autocmd FileType tidal nnoremap <buffer> <f3> {:TidalPlay 3<cr>
	autocmd FileType tidal nnoremap <buffer> <f4> {:TidalPlay 4<cr>
	autocmd FileType tidal nnoremap <buffer> <f5> {:TidalPlay 5<cr>
	autocmd FileType tidal nnoremap <buffer> <f6> {:TidalPlay 6<cr>
	autocmd FileType tidal nnoremap <buffer> <f7> {:TidalPlay 7<cr>
	autocmd FileType tidal nnoremap <buffer> <f8> {:TidalPlay 8<cr>
	autocmd FileType tidal nnoremap <buffer> <f9> {:TidalPlay 9<cr>
	autocmd FileType tidal nnoremap <buffer> <f10> {:TidalPlay 10<cr>
	autocmd FileType tidal nnoremap <buffer> <f11> {:TidalPlay 11<cr>
	autocmd FileType tidal nnoremap <buffer> <f12> {:TidalPlay 12<cr>
	autocmd FileType tidal nnoremap <leader><f1> :TidalSilence 1<cr>
	autocmd FileType tidal nnoremap <leader><f2> :TidalSilence 2<cr>
	autocmd FileType tidal nnoremap <leader><f3> :TidalSilence 3<cr>
	autocmd FileType tidal nnoremap <leader><f4> :TidalSilence 4<cr>
	autocmd FileType tidal nnoremap <leader><f5> :TidalSilence 5<cr>
	autocmd FileType tidal nnoremap <leader><f6> :TidalSilence 6<cr>
	autocmd FileType tidal nnoremap <leader><f7> :TidalSilence 7<cr>
	autocmd FileType tidal nnoremap <leader><f8> :TidalSilence 8<cr>
	autocmd FileType tidal nnoremap <leader><f9> :TidalSilence 9<cr>
	autocmd FileType tidal nnoremap <leader><f10> :TidalSilence 10<cr>
	autocmd FileType tidal nnoremap <leader><f11> :TidalSilence 11<cr>
	autocmd FileType tidal nnoremap <leader><f12> :TidalSilence 12<cr>
	autocmd VimEnter *.scd nnoremap <leader>1 :call scnvim#sclang#send("~toggle_dirt_orbit_bus.(~d1, ~b1)")<cr>
	autocmd VimEnter *.scd nnoremap <leader>2 :call scnvim#sclang#send("~toggle_dirt_orbit_bus.(~d2, ~b2)")<cr>
	autocmd VimEnter *.scd nnoremap <leader>3 :call scnvim#sclang#send("~toggle_dirt_orbit_bus.(~d3, ~b3)")<cr>
	autocmd VimEnter *.scd nnoremap <leader>4 :call scnvim#sclang#send("~toggle_dirt_orbit_bus.(~d4, ~b4)")<cr>
	autocmd VimEnter *.scd nnoremap <leader>5 :call scnvim#sclang#send("~toggle_dirt_orbit_bus.(~d5, ~b5)")<cr>
	autocmd VimEnter *.scd nnoremap <leader>6 :call scnvim#sclang#send("~toggle_dirt_orbit_bus.(~d6, ~b6)")<cr>
	autocmd VimEnter *.scd nnoremap <leader>7 :call scnvim#sclang#send("~toggle_dirt_orbit_bus.(~d7, ~b7)")<cr>
	autocmd VimEnter *.scd nnoremap <leader>8 :call scnvim#sclang#send("~toggle_dirt_orbit_bus.(~d8, ~b8)")<cr>
	autocmd VimEnter *.scd nnoremap <leader>9 :call scnvim#sclang#send("~toggle_dirt_orbit_bus.(~d9, ~b9)")<cr>
	autocmd VimEnter *.scd nnoremap <leader>10 :call scnvim#sclang#send("~toggle_dirt_orbit_bus.(~d10, ~b10)")<cr>
	autocmd VimEnter *.scd nnoremap <leader>11 :call scnvim#sclang#send("~toggle_dirt_orbit_bus.(~d11, ~b11)")<cr>
	autocmd VimEnter *.scd nnoremap <leader>12 :call scnvim#sclang#send("~toggle_dirt_orbit_bus.(~d12, ~b12)")<cr>
augroup END

" FoxDot
let g:foxdot_activated = 0

function! Foxdot_init()
	let g:foxdot_activated = 1
	execute "tabe " . expand("%:r") . ".py"
	call scnvim#sclang#send("~foxdot_start.value()")
	:T ipython --no-autoindent -i ~/sp/foxdot/foxdot_cli.py
	" :exe "tabn ".g:lasttab
	:ColorizerAttachToBuffer
	:wincmd k
	:normal G
endfunction

function Hard_stop_foxdot()
	nnoremap <buffer> <M-C-k> :call scnvim#hard_stop() <bar> T Clock.clear()<cr>
endfunction

augroup foxdot_au
	autocmd!
	autocmd FileType python :badd ~/sp/dict/foxdot/synths.txt
	autocmd FileType python setlocal dictionary+=~/sp/dict/foxdot/synths.txt
	autocmd FileType python nmap <buffer> <M-t>  :T Clock.bpm=60*
	autocmd FileType python nmap <buffer> <M-k>  :T Clock.clear()<cr>
	autocmd FileType python imap <buffer> <M-k>  <C-o>:T Clock.clear()<cr>
	autocmd FileType python nnoremap <silent> <buffer> <M-s> :e ./snips.py<cr>
	autocmd FileType python :call Hard_stop_foxdot()
	autocmd FileType python nnoremap <buffer> <leader><leader>1 :T print(Scale.default)<cr>
	" autocmd FileType python nmap <buffer> <M-x>  :T d.stop<left><left><left><left><left>
	" autocmd FileType python imap <buffer> <M-x>  <C-o>:T Clock.clear()<cr><left><left><left><left><left>
	" autocmd FileType python nnoremap <buffer> <M-u> :Ttoggle<cr>
augroup END

" Improviz
call minpac#add('rumblesan/improviz-vim')

function! Improviz_init()
	execute "tabe " . expand("%:r") . ".pz"
	:ColorizerAttachToBuffer
	call scnvim#sclang#send("~improviz_start.value()")
	:T cd /home/mantas/sp/tmp/improviz && stack exec improviz
	" :StartAsync sh -c 'cd .. && improviz'
	" :StartAsync sh -c 'cd /home/mantas/sp/tmp/improviz && stack exec improviz'
	sleep 2
	:StartAsync i3-msg '[instance="Improviz"]' move position 1100 100
	:StartAsync i3-msg '[instance="Improviz"]' focus mode_toggle
	:ImprovizToggleText
	:normal G
endfunction

function! Improviz_toggle()
	:StartAsync i3-msg '[instance="Improviz"]' scratchpad show
	sleep 1ms
	:StartAsync i3-msg '[instance="Improviz"]' focus mode_toggle
endfunction

augroup improviz_au
	autocmd!
	autocmd FileType improviz :badd ~/sp/dict/improviz/all.txt
	autocmd FileType improviz setlocal dictionary+=~/sp/dict/improviz/all.txt
	autocmd FileType improviz nnoremap <silent> <buffer> <M-e> :ImprovizSend<cr>
	autocmd FileType improviz nnoremap <silent> <buffer> <M-j> :ImprovizSend<cr>
	autocmd FileType improviz nnoremap <silent> <buffer> <M-p> :ImprovizSend<cr>
	autocmd FileType improviz nnoremap <silent> <buffer> <M-l> :ImprovizToggleText<cr>
	autocmd FileType improviz nnoremap <buffer> <M-u> :call Improviz_toggle()<cr>
	autocmd FileType improviz nnoremap <silent> <buffer> <M-s> :e ./snips.pz<cr>
	autocmd Syntax improviz match improvizComment "\v//.*$"
	autocmd FileType improviz setlocal commentstring=//\ %s
augroup END

" Espgrid
function! Espgrid_init()
	:StartAsync espgridd
	sleep 3
	call scnvim#sclang#send("~activate_espgrid.value()")
	if g:tidal_activated
		:TidalSend1 espgrid tidal
	endif
	if g:foxdot_activated
		:T Clock.sync_to_espgrid(host="localhost", port=5510)
	endif
endfunction

" Hydra
function! Hydra_init()
	execute "StartAsync atom " . expand("%:r") . ".js"
endfunction

" Faust
call minpac#add('gmoe/vim-faust')

function! Faust_init()
	execute "tabe " . expand("%:r") . ".dsp"
	:normal G
endfunction

augroup faust_au
	autocmd!
	" autocmd FileType faust :execute "StartAsync FaustLive " . expand("%:p")
	autocmd FileType faust nnoremap <silent> <buffer> <M-e> :execute "StartAsync pgrep FaustLive \|\| FaustLive " . expand("%:p")<cr>
	autocmd FileType faust nnoremap <silent> <buffer> <M-k> :StartAsync killall FaustLive<cr>
	autocmd FileType faust nnoremap <silent> <buffer> <M-j> :execute "! ../f2s " . expand("%:t")<cr>
	autocmd FileType faust nnoremap <silent> <buffer> <M-s> :e ./snips.dsp<cr>
augroup END
" }}}2

" Misc {{{2
" call minpac#add('dm1try/golden_size', {'type': 'opt'})
" packadd! golden_size
" " Disable automatic resizing for specific windows
" lua << EOF
" local function ignore_by_buftype(types)
"   local buftype = vim.api.nvim_buf_get_option(0, 'buftype')
"   for _, type in pairs(types) do
"     if type == buftype then
"       return 1
"     end
"   end
" end
" local golden_size = require("golden_size")
" -- set the callbacks, preserve the defaults
" golden_size.set_ignore_callbacks({
"   { ignore_by_buftype, {'quickfix', 'terminal', 'nofile'} },
"   { golden_size.ignore_float_windows }, -- default one, ignore float windows
"   { golden_size.ignore_by_window_flag }, -- default one, ignore windows with w:ignore_gold_size=1
" })
" EOF
call minpac#add('dstein64/nvim-scrollview')
let g:scrollview_excluded_filetypes = ['scnvim'] "set ft?
let g:scrollview_active_only = 1
call minpac#add('dstein64/vim-win')
map <leader>W <plug>WinWin
let g:win_resize_height = 4
let g:win_resize_width = 5
call minpac#add('junegunn/limelight.vim')
nnoremap <leader>ol :Limelight!!<cr>
nmap gl <Plug>(Limelight)
xmap gl <Plug>(Limelight)
call minpac#add('junegunn/goyo.vim')
nnoremap <leader>og :Goyo<cr>
" Navi integration
au BufEnter,BufNew *.cheat au TextChanged,TextChangedI <buffer> write
" Toggle
call minpac#add('junegunn/rainbow_parentheses.vim')
let g:rainbow#max_level = 16
let g:rainbow#pairs = [['(', ')'], ['[', ']'], ['{', '}'], ['<', '>'], ['"', '"']]
nnoremap <leader>or :RainbowParentheses!!<cr>
let g:rainbow#blacklist = ["#a790d5", "#F1F1F1", "#FFFFFF", "#A8A8A8", "#C6C6C6", "#EEEEEE"]
call minpac#add('norcalli/nvim-colorizer.lua')
nnoremap <leader>ov :ColorizerToggle<cr>
let g:rcl = 1
function! Toggle_rcl()
	if g:rcl == 1
		RainbowParentheses
		Limelight
		ColorizerAttachToBuffer
		let g:rcl = 0
	else
		RainbowParentheses!
		Limelight!
		ColorizerDetachFromBuffer
		let g:rcl = 1
	endif
endfunction
nnoremap <leader>o<leader> :call Toggle_rcl()<cr>
" }}}2
