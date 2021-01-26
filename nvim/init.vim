"###############################################################################
"# File Name    :   init.vim
"# Author   :   Masroor Rasheed
"# Created  :   Sat 18 Apr 2020 21:10:18 BST
"###############################################################################

" Global Varaibles
let vim_plug_just_installed = 0     " Initiate Setup for first time

" Mode Settings for Cursor
" 1 -> blinking block
" 2 -> solid block
" 3 -> blinking underscore
" 4 -> solid underscore
" 5 -> blinking vertical bar
" 6 -> solid vertical block
let &t_SI.="\e[5 q"     "SI = INSERT mode
let &t_SR.="\e[3 q" "SR = REPLACE mode
let &t_EI.="\e[1 q" "EI = NORMAL mode

set nocompatible        " No Backward compatibility

" Install Plug manager if not installed
let vim_plug_path = expand('~/.config/nvim/autoload/plug.vim')
if !filereadable(vim_plug_path)
    echo "Installing Vim-plug..."
    silent !mkdir -p ~/.config/nvim/autoload
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    let vim_plug_just_installed = 1
endif
" Load Vim-Plug if just installed
if vim_plug_just_installed
    :execute 'source '.fnameescape(vim_plug_path)
endif

" Plug Management
" ============================================================================
call plug#begin("~/.config/nvim/plugged")

Plug 'vim-airline/vim-airline'              " Status bar Customization
Plug 'vim-airline/vim-airline-themes'       " Themes for Status bar
Plug 'scrooloose/nerdtree'                  " File Manager
Plug 'neovimhaskell/haskell-vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
" Markdown
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
" Window Management
Plug 'paroxayte/vwm.vim'
" Looks
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'chiel92/vim-autoformat'
Plug 'ryanoasis/vim-devicons'

call plug#end()

if vim_plug_just_installed
    echo "Installing Bundles, please ignore key map error messages"
    :PlugInstall
endif
" ============================================================================
" NERDTree -------------------------------------------------------------------
map <F3> :NERDTreeToggle<CR>

let g:WebDevIconsUnicodeDecorateFolderNodes = 1
let g:DevIconsEnableFoldersOpenClose = 1

highlight! link NERDTreeFlags NERDTreeDir

" Remove expandable arrow
let g:WebDevIconsNerdTreeBeforeGlyphPadding = ""
let g:WebDevIconsUnicodeDecorateFolderNodes = v:true
let NERDTreeDirArrowExpandable = "\u00a0"
let NERDTreeDirArrowCollapsible = "\u00a0"
let NERDTreeNodeDelimiter = "\x07"

" Autorefresh on tree focus
function! NERDTreeRefresh()
    if &filetype == "nerdtree"
        silent exe substitute(mapcheck("R"), "<CR>", "", "")
    endif
endfunction

autocmd BufEnter * call NERDTreeRefresh()

"=============================================================================
" Haskell-vim
let g:haskell_enable_quantification = 1   " to enable highlighting of `forall`
let g:haskell_enable_recursivedo = 1      " to enable highlighting of `mdo` and `rec`
let g:haskell_enable_arrowsyntax = 1      " to enable highlighting of `proc`
let g:haskell_enable_pattern_synonyms = 1 " to enable highlighting of `pattern`
let g:haskell_enable_typeroles = 1        " to enable highlighting of type roles
let g:haskell_enable_static_pointers = 1  " to enable highlighting of `static`
let g:haskell_backpack = 1                " to enable highlighting of backpack keywords

"=============================================================================
" Markdown
let g:vim_markdown_folding_style_pythonic = 1
let g:vim_markdown_folding_level  = 6
let g:vim_markdown_frontmatter = 1


"=============================================================================
" vim-autoformat'
noremap <F3> :Autoformat<CR>
let g:autoformat_autoindent = 1
let g:autoformat_retab = 1
let g:autoformat_remove_trailing_space = 1
let g:formatterpath = ['/opt/miniconda3/bin/black']


" ============================================================================
" COC Settings
" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
            \ pumvisible() ? "\<C-n>" :
            \ <SID>check_back_space() ? "\<TAB>" :
            \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
    inoremap <silent><expr> <c-space> coc#refresh()
else
    inoremap <silent><expr> <c-@> coc#refresh()
endif

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

set signcolumn=yes

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
            \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
    elseif (coc#rpc#ready())
        call CocActionAsync('doHover')
    else
        execute '!' . &keywordprg . " " . expand('<cword>')
    endif
endfunction


" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
    autocmd!
    " Setup formatexpr specified filetype(s).
    autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
    " Update signature help on jump placeholder.
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
    nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
    nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
    inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
    inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
    vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
    vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>


" Python Settings
" ================
let g:loaded_python_provider=0    "Disabling Python 2"
let g:python3_host_prog = '/opt/miniconda3/bin/python3'
let g:python_host_prog = '/usr/bin/python'
let python_highlight_all = 1

" Ruby Settings
" =============
let g:loaded_ruby_provider = 0


" ============================================================================
"



let mapleader=" "
" Syntax highlighting
filetype plugin indent on
" General Set up
set encoding=UTF-8
set path+=**            " Search current directory recursively
set wildmenu            " Display all matches
set wildmode=list:longest   " Autocompletion
set incsearch           " Incremental search
set hlsearch            " Highlight search
set nobackup            " No auto backup
set noswapfile          " No swap
set t_Co=256            " Set if term support 256 colours
syntax on           " Syntax highlighting
set mouse=nicr          " Enabling mouse scrolling
set nu rnu          " Line numbering
set cursorline          " Highlight current line
setlocal spell spelllang=en_gb  " British Dictionary
set spell
set clipboard=unnamedplus
set smartindent
set showmatch
set scrolloff=5         " Keep cursor 3 lines away from screen border
set encoding=utf-8
set laststatus=2

" Text, Tab and indent related
set smarttab
set expandtab           " Ensure that tabs are converted to spaces
set shiftwidth=4
set tabstop=4
set softtabstop=4
set colorcolumn=80

" Latex Suite Specific
set grepprg=grep\ -nH\ $*
let g:tex_flavor="latex"

" Splits and Tabbed Files
"
set splitbelow splitright
" Remap slip Navigations
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
" Make adjusting split sizes a bit more friendly
noremap <silent> <C-Left> :vertical resize +3<CR>
noremap <silent> <C-Right> :vertical resize -3<CR>
noremap <silent> <C-Up> :resize +3<CR>
noremap <silent> <C-Down> :resize -3<CR>
" Change 2 split windows from vertical to horizontal and vice versa
map <Leader>th  <C-w>t<C-w>H
map <Leader>tk  <C-w>t<C-w>K

" Removes pipes | that act as separators on splits
set fillchars+=vert:\

colorscheme gruvbox
" hi Comment ctermfg=LightBlue


" File type specific
" ============================================================================
" Markdown
autocmd BufNewFile,BufRead *.md set filetype=markdown
autocmd BufWritePre *.py :%s/\s\+$//e


"###############################################################################
" Shortcuts
"###############################################################################
" General
"=========
" Auto close brackets and quotation
inoremap " ""<left>
inoremap ' ''<left>
inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>
inoremap {<CR> {<CR>}<ESC>O
inoremap {;<CR> {<CR>};<ESC>O


" Latex
map <leader>p :silent :w<CR>:!latex "%:t:r" && bibtex "%:t:r" && pdflatex % && open -a Preview "%:t:r".pdf<CR>:redraw!<CR>

" Reloading VIMRC Quickly"
" ========================
map <leader>r   :source $MYVIMRC<CR>


" Commenting block of code
" =========================
augroup commenting_blocks_of_code
    autocmd!
    autocmd FileType c,cpp,java,scala   let b:comment_leader = '//'
    autocmd FileType sh,ruby,python     let b:comment_leader = '#'
    autocmd FileType conf,fstab         let b:comment_leader = '#'
    autocmd FileType tex                let b:comment_leader = '%'
    autocmd FileType mail               let b:comment_leader = '>'
    autocmd FileType vim                let b:comment_leader = '"'
    autocmd FileType sql                let b:comment_leader = '--'
augroup END

function! CommentToggle()
    execute ':silent! s/\([^ ]\)/' . b:comment_leader . ' \1/'
    execute ':silent! s/^\( *\)' . b:comment_leader . ' \?' . b:comment_leader . ' \?/\1/'
endfunction
map <leader>c :call CommentToggle()<CR>


" for hex editing
augroup Binary
    au!
    au BufReadPre  *.bin let &bin=1
    au BufReadPost *.bin if &bin | %!xxd
    au BufReadPost *.bin set ft=xxd | endif
    au BufWritePre *.bin if &bin | %!xxd -r
    au BufWritePre *.bin endif
    au BufWritePost *.bin if &bin | %!xxd
    au BufWritePost *.bin set nomod | endif
augroup END

" Python Files
au BufNewFile,BufRead *.py
            \ set expandtab       |" replace tabs with spaces
            \ set autoindent      |" copy indent when starting a new line
            \ set tabstop=4
            \ set softtabstop=4
            \ set shiftwidth=4
            \ set foldmethod=indent
au BufWrite *.py :Autoformat
