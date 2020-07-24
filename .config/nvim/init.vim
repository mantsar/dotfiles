" ======================= GENERAL ============================================= {{{1

" GUI Neovide
if exists('g:neovide')
	let g:neovide_fullscreen=v:false
	let g:neovide_transparency=0.9
	let g:neovide_cursor_vfx_mode = "ripple"
	set guifont=FiraCode-Bold:h18
	function! Toggle_neovide_fullscreen()
		if g:neovide_fullscreen
			let g:neovide_fullscreen = v:false
		else
			let g:neovide_fullscreen = v:true
		endif
	endfunction
	nnoremap <f9> :let g:neovide_transparency=g:neovide_transparency-0.1<cr>
	inoremap <f9> <C-o>:let g:neovide_transparency=g:neovide_transparency-0.1<cr>
	nnoremap <f10> :let g:neovide_transparency=g:neovide_transparency+0.1<cr>
	inoremap <f10> <C-o>:let g:neovide_transparency=g:neovide_transparency+0.1<cr>
	nnoremap <f11> :call Toggle_neovide_fullscreen()<cr>
	inoremap <f11> <C-o>:call Toggle_neovide_fullscreen()<cr>
	nnoremap <f12> :call Toggle_neovide_fullscreen()<cr>
	inoremap <f12> <C-o>:call Toggle_neovide_fullscreen()<cr>
endif

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

" ~~~~~~~~~~~~~~~~~~~~~~~ options ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ {{{2
" UI
set number "Line numbers are good
set relativenumber "Show numbers relative to current line
set mouse=a "Enable mouse usage for all modes
" set wrap "Wrap when textwidth is reached
set clipboard+=unnamedplus "Yank command always copies to clipboard
" set showmatch "Show matching parenthesis when inserted
" set matchtime=20 "2 blinks on show match
set splitbelow "Open split windows below by default
set splitright "Open vsplit windows to the right by default
set list listchars=tab:\|\ ,trail:· "Convert hidden chars to visible symbols
" Search/Substition/Completion/Case
set inccommand=split "Show substitute changes immediately in separate split
set ignorecase "Case insensitive search
set smartcase "Case sensitive search if there is at least one uppercase letter
set infercase "Inferring case when auto completing
set shortmess+=c "Disable completion menu messages in command line
set complete+=kspell "Enable dict completion when spelling is on
" Indentation
set tabstop=2 softtabstop=2 shiftwidth=2
set shiftround "Use multiple of shiftwidth when indenting with '<' and '>'
set noexpandtab "Don't use spaces when inserting a <Tab>.
set smartindent "Do smart autoindenting when starting a new line.
" Text/Moving
" set tildeop " Enable ~ operator
" Folding
" set nofoldenable "Always show unfolded document on startup
set foldlevel=99
" Misc
set history=5000 "Store lots of :cmdline history
set hidden "Hide buffers in background
set scrolloff=5
set foldmethod=marker

" ~~~~~~~~~~~~~~~~~~~~~~~~~ variables ~~~~~~~~~~~~~~~~~~~~~~~ {{{2
let g:mapleader = "\<Space>" "Map leader key to space

" ~~~~~~~~~~~~~~~~~~~~~~~~~ ui ~~~~~~~~~~~~~~~~~~~~~~~ {{{2

" ~~~~~~~~~~~~~~~~~~~~~~~ mappings ~~~~~~~~~~~~~~~~~~~~~~~ {{{2
nnoremap <M-w> :wa<cr>
nnoremap <M-q> :qa<cr>
map <M-c> mmgcc`m
map <M-g> mmgccyypgcc`mj
nnoremap <M-d> mmyyp`mj
nnoremap <C-=> m`o<esc>``
nnoremap <C--> m`O<esc>``
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
nnoremap <c-_> /\V
xnoremap <c-_> /\V
onoremap <c-_> /\V
nnoremap <c-?> ?\v
cnoremap %S %s/\V
cnoremap G/ g/\V
nnoremap <silent> <C-l> :<C-u>nohlsearch<cr>
nnoremap <M-r> :%s/\v//g<left><left><left>
xnoremap <M-r> :s/\v//g<left><left><left>
" From autoloaded functions
" Improvement upon vim-surround. Adds function text-object to act upon.
" https://gist.github.com/romgrk/35186f3b5a71a7d89b2229b6f73e4f32
nnoremap dsf  :call surroundfunc#DSurroundFunc()<cr>
nnoremap csf  :call surroundfunc#CSurroundFunc()<cr>

" ~~~~~~~~~~~~~~~~~~~~~~~ autocommands ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ {{{2
augroup general
	autocmd!
	"Mapping for exiting help window with just q
	autocmd BufEnter *.txt if &buftype == 'help' | noremap <buffer> q :q<cr> | endif
	"Mapping for exiting quickfix window with just q
	" autocmd BufWinEnter quickfix | noremap <buffer> q :q<cr>
	"Open help window vertically
	autocmd BufEnter *.txt if &buftype == 'help' | wincmd L | endif
	" Turn off annoying auto commenting
	autocmd BufEnter * setlocal formatoptions-=r formatoptions-=o
	" Automatically enter insert mode when terminal is selected.
	" autocmd BufEnter * if &buftype == 'terminal' | :startinsert | endif
	autocmd VimResized * wincmd =
augroup END

augroup vimrc
	autocmd!
	" Marker folding for vimrc
	autocmd BufWritePre,BufRead $MYVIMRC setlocal foldcolumn=3 foldmethod=marker
	" Automatically reload changed config file (init.vim or .vimrc)
	autocmd bufwritepost init.vim source $MYVIMRC
augroup END

augroup spellmode
	autocmd!
	autocmd FileType gitcommit setlocal spell "Enable spelling by default
augroup END

augroup rmode
	autocmd!
	" autocmd FileType r setlocal expandtab "Use spaces for tabs
	autocmd FileType r setlocal inoremap <M-=> <-
	autocmd FileType r setlocal inoremap <M--> %>%
augroup END

augroup pymode
	autocmd!
	autocmd FileType python setlocal tabstop=4 softtabstop=4 shiftwidth=4
augroup END

augroup luamode
	autocmd!
	autocmd FileType lua setlocal tabstop=4 softtabstop=4 shiftwidth=4
augroup END

" ~~~~~~~~~~~~~~~~~~~~~~~ functions ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ {{{2

command! -nargs=1 StartAsync
         \ call jobstart(<f-args>)
" \       execute('echom "command finished with exit status '.d.'"', '')

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

" ======================= PACKAGES ============================================ {{{1

packadd minpac
call minpac#init()
call minpac#add('k-takata/minpac', {'type': 'opt'}) "Manage minpac for updates
command! PackUpdate call minpac#update() "Install or update plugins
command! PackClean call minpac#clean() "Uninstall unused plugins
command! PackStatus call minpac#status() "See plugins status
" Manually loaded plugins in /pack/*/opt/
" Auto loaded plugins in /pack/*/start/
"
" ~~~~~~~~~~~~~~~~~~~~~~~~~ ui ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ {{{2
" Colorscheme
call minpac#add('liuchengxu/space-vim-dark')
set termguicolors
let g:colorscheme = 0
if g:colorscheme
	au VimEnter * hi Comment guifg=#5c6370 ctermfg=59
	autocmd VimEnter * hi Sneak guifg=black guibg='#afff5f' ctermfg=black
else
	autocmd VimEnter * hi Sneak guifg=black guibg='#5FD7A7' ctermfg=black
endif
function! Toggle_colorcheme()
		if g:colorscheme
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
			hi Comment cterm=italic gui=italic
			hi Sneak guifg=black guibg='#afff5f' ctermfg=black
			let g:colorscheme = 0
		else
			set colorcolumn=999
			set nocursorline
			set nocursorcolumn
			augroup ui
				autocmd!
			augroup END
			colorscheme paramount
			hi Sneak guifg=black guibg='#afff5f' ctermbg=red ctermfg=black
			hi Sneak guifg=black guibg='#5FD7A7' ctermfg=black
			let g:colorscheme = 1
		endif
endfunction
call minpac#add('owickstrom/vim-colors-paramount')
call Toggle_colorcheme()
call minpac#add('machakann/vim-highlightedyank')
call minpac#add('itchyny/lightline.vim')
set noshowmode
let g:lightline = {
      \ 'colorscheme': 'Tomorrow_Night',
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
" ~~~~~~~~~~~~~~~~~~~~~~~~~ general ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ {{{2
call minpac#add("liuchengxu/vim-which-key")
packadd! vim-which-key "Add to runtimepath during init
set timeoutlen=1000 "Delay to show which-key pop up
call which_key#register('<Space>', "g:which_key_map") "Register prefix dict
let g:which_key_map =  {} "Define prefix dictionary
nnoremap <silent> <leader> :<c-u>WhichKey '<space>'<cr>
vnoremap <silent> <leader> :<c-u>WhichKeyVisual '<space>'<cr>
" Don't use neovim's floating win, because it's ugly and not transparent
let g:which_key_use_floating_win = 0 
" Buffers
nnoremap <Leader>bn :bnext<cr>
nnoremap <Leader>bp :bprevious<cr>
"Alternate between buffers same as <C-^>
nnoremap <Leader><Tab> :e #<cr>
nnoremap <Leader>bd :bdelete<cr>
nnoremap <Leader>bD :bdelete!<cr>
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
nnoremap <Leader>td :tabclose<cr>
nnoremap <Leader>tn :tabnext<cr>
nnoremap <Leader>tp :tabprevious<cr>
" 1tabnext<cr>
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
" Moving between windows
nnoremap <Leader>wj <C-w>j
nnoremap <Leader>wk <C-w>k
nnoremap <Leader>wh <C-w>h
nnoremap <Leader>wl <C-w>l
nnoremap <Leader>ww :call wincmd w<cr>
" Opening windows
nnoremap <Leader>ws <C-w>s
nnoremap <Leader>wv <C-w>v
" Delete window
nnoremap <Leader>wd <C-w>c
" Delete all others windows
nnoremap <Leader>wm <C-w>o
" Moving windows
nnoremap <Leader>wJ <C-w>J
nnoremap <Leader>wK <C-w>K
nnoremap <Leader>wH <C-w>H
nnoremap <Leader>wL <C-w>L
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
nnoremap <leader>oc :call Toggle_colorcheme()<cr>
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
xnoremap <silent> gs :set opfunc=SourceVimscript<CR>g@
xnoremap <silent> <leader>vv :<C-U>call SourceVimscript("visual")<CR>
nnoremap <leader>vs :source $MYVIMRC<cr>
let g:which_key_map.v = {
			\ 'name' : '+vim' ,
			\ 'v' : 'execute-vimscript-line-or-visual',
			\ 's' : 'source-vimscript'
			\ }
" Text editing and moving {{{2
call minpac#add('tpope/vim-commentary') "Comment stuff out
call minpac#add('tpope/vim-surround') "Quoting/parenthesizing made simple
call minpac#add('tpope/vim-rsi') "Some Emacs bindings for insert and cmdline mode
call minpac#add('tpope/vim-abolish') "Using only for coercion functionality
call minpac#add('tpope/vim-unimpaired')
" Bubble single lines
nmap <C-k> [e
nmap <C-j> ]e
" Bubble multiple lines
xmap <C-k> [egv
xmap <C-j> ]egv
call minpac#add('tommcdo/vim-exchange') "Easy text exchange operator for Vim
call minpac#add('thinca/vim-visualstar') "Makes * and # work on visual mode too.
call minpac#add('vim-scripts/ReplaceWithRegister') "Replace text with the contents of a register
call minpac#add('wellle/targets.vim') "Vim plugin that provides additional text objects. Argument text-object etc...
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
augroup quick
	autocmd!
	" Only higlight with colored underline
	autocmd VimEnter * highlight QuickScopePrimary guifg='NONE' gui=underline ctermfg=NONE cterm=underline guisp='#afff5f'
augroup END
call minpac#add('mantsar/vim-closer')
call minpac#add('kana/vim-textobj-user') " Create your own text objects. Required by plugins below
call minpac#add('kana/vim-textobj-line') "Text objects for the current line
call minpac#add('kana/vim-textobj-indent') "Text objects for indented blocks of lines
call minpac#add('somini/vim-textobj-fold')
call minpac#add('Julian/vim-textobj-variable-segment') "Provides a single text object (on iv and av) for Snake and underscore cases

" IDE like {{{2

call minpac#add('Shougo/deoplete.nvim') "Dark powered asynchronous completion framework for neovim/Vim8
let g:deoplete#enable_at_startup = 1
call minpac#add('deoplete-plugins/deoplete-tag') "deoplete source for ctags
call minpac#add('deathlyfrantic/deoplete-spell') "Deoplete source for spelling check. Requires :set spell
call minpac#add('deoplete-plugins/deoplete-dictionary')
call minpac#add("SirVer/ultisnips")
" Directs are searched. No entry in this list must be 'snippets'.
let g:UltiSnipsEditSplit="horizontal"
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
nnoremap <silent> <leader>fes :UltiSnipsEdit<cr>
nnoremap <silent> <M-9> :UltiSnipsEdit<cr>
" Fixes freezing when changing tabs
au TabLeave * call UltiSnips#LeavingBuffer()
call minpac#add('kassio/neoterm')
let g:neoterm_autoscroll = 1 "scroll to the end of its buffer after running any
" let neoterm_default_mod = "vertical"
let g:neoterm_repl_enable_ipython_paste_magic = 1
" Send the commands to the neoterm buffer linked to the current tab instead of the last active neoterm.
let g:neoterm_term_per_tab=1
" let g:neoterm_autoinsert=1
nmap gx <Plug>(neoterm-repl-send)
" Send selected contents in visual mode.
xmap gx <Plug>(neoterm-repl-send)
nmap gxx <Plug>(neoterm-repl-send-line)
nnoremap <M-cr> :Tnew<cr>
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
nnoremap <M-space> :Buffers<cr>
nnoremap <leader>; :History:<cr>
nnoremap <leader>/ :History:<cr>
" Search lines in loaded buffers
nnoremap <leader>sl :Lines<cr>
" Search lines in the current buffer
nnoremap <C-s> :BLines<cr>
inoremap <C-s> <Esc>:BLines<cr>
xnoremap <C-s> <Esc>:BLines<cr>
" Vim help tags
nnoremap <leader>hh :Helptags<cr>

" call minpac#add('sbdchd/neoformat')
" let g:neoformat_enabled_haskell = ['brittany']
" let g:neoformat_haskell_ormolu = { 'exe': 'ormolu', 'args': [] }
" let g:neoformat_enabled_haskell = ['ormolu']

" Misc {{{2
call minpac#add('junegunn/goyo.vim')
let g:goyo_width = 140
let g:goyo_height = 120
nnoremap <leader>og :Goyo<cr>
call minpac#add('junegunn/limelight.vim')
nnoremap <leader>ol :Limelight!!<cr>
nmap gl <Plug>(Limelight)
xmap gl <Plug>(Limelight)
autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight!

" Music {{{2

call minpac#add('davidgranstrom/scnvim')
let g:scnvim_no_mappings = 1
" default is half the terminal size for vertical and a third for horizontal
let g:scnvim_postwin_size = 70
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
	call Foxdot_init() 
	sleep 1
	call Tidal_init() 
	call Espgrid_init()
endfunction

augroup sc_au
	autocmd!
	" init
	autocmd FileType supercollider setlocal dictionary+=./fzf/samples.txt
	autocmd VimEnter *.scd normal G
	autocmd VimEnter *.scd SCNvimStart
	autocmd VimEnter *.scd SCNvimStatusLine
	autocmd VimEnter *.scd :badd ~/.config/SuperCollider/startup.scd
	autocmd VimEnter *.scd :badd ~/.config/SuperCollider/synth_def.scd
	"mappings
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
	autocmd VimEnter *.scd nmap <M-p> vip<Plug>(scnvim-send-selection)
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
	autocmd VimEnter *.scd nnoremap <leader><leader>1 :call fzf#run({ 'source':  'cat ./fzf/scales.txt', 'sink': function('Scale_summary') })<cr>
	autocmd VimEnter *.scd nnoremap <leader><leader>2 :call fzf#run({ 'source':  'cat ./fzf/samples.txt', 'sink': function('Sample_fetch') })<cr>
	autocmd VimEnter *.scd nnoremap <leader><leader>h :call Toggle_scnvim_scdoc()<cr>
	autocmd VimEnter *.scd nnoremap <leader><leader>s :call scnvim#sclang#send("s.scope")<cr>
	autocmd VimEnter *.scd nnoremap <leader><leader>f :call scnvim#sclang#send("FreqScope.new(1200)")<cr>
	autocmd VimEnter *.scd nnoremap <leader><leader>t :call scnvim#sclang#send("s.plotTree")<cr>
	autocmd VimEnter *.scd nnoremap <silent> <leader><leader>] :SCNvimRecompile<cr>
	autocmd VimEnter *.scd nnoremap <silent> <leader><leader>T :SCNvimTags<cr>
	" tidal/foxdot/imroviz
	autocmd VimEnter *.scd nnoremap <leader><leader>v :call Improviz_init()<cr>
	autocmd VimEnter *.scd nnoremap <leader><leader>c :call Tidal_init()<cr>
	autocmd VimEnter *.scd nnoremap <leader><leader>p :call Foxdot_init()<cr>
	autocmd VimEnter *.scd nnoremap <leader><leader>e :call Espgrid_init()<cr>
	autocmd VimEnter *.scd nnoremap <leader><leader>a :call Hydra_init()<cr>
	autocmd VimEnter *.scd nmap <f1> :call All_init()<cr>
augroup END

" Tidal
call minpac#add('itchyny/vim-haskell-indent')
augroup hs_au
	autocmd!
	autocmd FileType haskell setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab
augroup END

call minpac#add('tidalcycles/vim-tidal')

let g:tidal_activated = 0

function! Tidal_init()
	let g:tidal_activated = 1
	execute "tabe " . expand("%:r") . ".tidal"
	call scnvim#sclang#send("~superdirt_start.value()")
	:TidalHush
	:wincmd j
	:wincmd L
	:vertical resize 70
	:wincmd h
endfunction

let g:tidal_no_mappings = 1
let g:tidal_target = "terminal"

augroup tidal_au
	autocmd!
	autocmd FileType tidal setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
	" for corrent indentation : cp
	" ~/.config/nvim/pack/minpac/start/vim-haskell-indent/indent/haskell.vim 
	" ~/.config/nvim/indent/tidal.vim
	autocmd FileType tidal setlocal commentstring=--\ %s
	autocmd FileType tidal setlocal dictionary+=./fzf/samples.txt
	autocmd FileType tidal setlocal dictionary+=./tidal/all_functions.txt
	autocmd FileType tidal setlocal dictionary+=./tidal/chords.txt
	autocmd FileType tidal setlocal dictionary+=./tidal/arpeggiators.txt
	autocmd FileType tidal nnoremap <silent> <buffer> <M-a> v$:s/\%V\(\$\\|#\)/\r\1<cr>l
	autocmd FileType tidal nmap <silent> <buffer> cx4 cxi$
	autocmd FileType tidal nmap <silent> <buffer> d4 da$
	autocmd FileType tidal nmap <silent> <buffer> c4 ci$<space><space><left>
	autocmd FileType tidal nmap <silent> <buffer> cx3 cxi#
	autocmd FileType tidal nmap <silent> <buffer> d3 da#
	autocmd FileType tidal nmap <silent> <buffer> c3 ci#<space><space><left>
	autocmd FileType tidal xmap <buffer> <M-e>  <Plug>TidalRegionSend
	autocmd FileType tidal xmap <buffer> <M-p>  <Plug>TidalRegionSend
	autocmd FileType tidal xmap <buffer> <M-o>  <Plug>TidalRegionSend
	autocmd FileType tidal nmap <buffer> <M-j>  <Plug>TidalLineSend
	autocmd FileType tidal imap <buffer> <M-j>  <C-o><Plug>TidalLineSend
	autocmd FileType tidal nmap <buffer> <M-e>  <Plug>TidalParagraphSend
	autocmd FileType tidal nmap <buffer> <M-p>  <Plug>TidalParagraphSend
	autocmd FileType tidal nmap <buffer> <M-o>  <Plug>TidalParagraphSend
	autocmd FileType tidal imap <buffer> <M-e>  <C-o><Plug>TidalParagraphSend
	autocmd FileType tidal imap <buffer> <M-o>  <C-o><Plug>TidalParagraphSend
	autocmd FileType tidal nmap <buffer> <M-k>  :TidalHush<cr>
	autocmd FileType tidal imap <buffer> <M-k>  <C-o>:TidalHush<cr>
	autocmd FileType tidal nmap <buffer> <M-s>  :TidalSilence<space>
	autocmd FileType tidal imap <buffer> <M-s>  <C-o>:TidalSilence<space>
	autocmd FileType tidal nnoremap <buffer> <M-t> :TidalSend1 setcps<space>
augroup END

" FoxDot

let g:foxdot_activated = 0

function! Foxdot_init()
	let g:foxdot_activated = 1
	call scnvim#sclang#send("~foxdot_start.value()")
	execute "tabe " . expand("%:r") . ".py"
	:T ipython --no-autoindent -i foxdot/foxdot_cli.py
endfunction

augroup foxdot_au
	autocmd!
	autocmd FileType python nmap <buffer> <M-k>  :T Clock.clear()<cr>
	autocmd FileType python imap <buffer> <M-k>  <C-o>:T Clock.clear()<cr>
	autocmd FileType python nmap <buffer> <M-s>  :T d.stop<left><left><left><left><left>
	autocmd FileType python imap <buffer> <M-s>  <C-o>:T Clock.clear()<cr><left><left><left><left><left>
	autocmd FileType python nnoremap <buffer> <M-j> :TREPLSendLine<cr>
	autocmd FileType python inoremap <buffer> <M-j> <C-o>:TREPLSendLine<cr>
	autocmd FileType python xnoremap <buffer> <M-e> :TREPLSendSelection<cr>
	autocmd FileType python xnoremap <buffer> <M-o> :TREPLSendSelection<cr>
	autocmd FileType python xnoremap <buffer> <M-p> :TREPLSendSelection<cr>
	autocmd FileType python nnoremap <buffer> <M-o> vip:TREPLSendSelection<cr>
	autocmd FileType python inoremap <buffer> <M-o> <C-o>vip:TREPLSendSelection<cr>
	autocmd FileType python inoremap <buffer> <M-i> <C-o>vip:TREPLSendSelection<cr>
	autocmd FileType python inoremap <buffer> <M-e> <C-o>vip:TREPLSendSelection<cr>
	autocmd FileType python nnoremap <buffer> <M-p> vip:TREPLSendSelection<cr>
	autocmd FileType python nnoremap <buffer> <M-e> vip:TREPLSendSelection<cr>
	autocmd FileType python nnoremap <buffer> <M-l> :Tclear<cr>
	autocmd FileType python nnoremap <buffer> <M-u> :Ttoggle<cr>
augroup END

" Improviz
call minpac#add('rumblesan/improviz-vim')

function! Improviz_init()
	" execute "badd " . expand("%:r") . ".pz"
	execute "tabe " . expand("%:r") . ".pz"
	:StartAsync improviz
	sleep 4
	:StartAsync i3-msg '[instance="Improviz"]' move position 710 150
	:StartAsync i3-msg '[instance="Improviz"]' focus mode_toggle
	:ImprovizToggleText
endfunction

function! Improviz_toggle()
	:StartAsync i3-msg '[instance="Improviz"]' scratchpad show 
	sleep 1ms
	:StartAsync i3-msg '[instance="Improviz"]' focus mode_toggle
endfunction

augroup improviz_au
	autocmd!
	autocmd FileType improviz setlocal commentstring=//\ %s
	autocmd FileType improviz nnoremap <silent> <buffer> <M-e> :ImprovizSend<cr>
	autocmd FileType improviz nnoremap <silent> <buffer> <M-l> :ImprovizToggleText<cr>
	autocmd FileType improviz nnoremap <buffer> <M-u> :call Improviz_toggle()<cr>
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
