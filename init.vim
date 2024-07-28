" My VIM settings

set nocompatible           " Do not preserve compatibility with Vi. Vim defaults rather than vi ones. Keep at top.
set modifiable             " buffer contents can be modified
set autoread               " detect when a file has been modified externally
filetype plugin indent on  " Enable filetype-specific settings.
syntax on                  " Enable syntax highlighting.
set backspace=2            " Make the backspace behave as most applications.
set autoindent             " Use current indent for new lines.
set smartindent
set display=lastline       " Show as much of the line as will fit.
set wildmenu               " Better tab completion in the commandline.
set wildmode=list:longest  " List all matches and complete to the longest match.
set showcmd                " Show (partial) command in bottom-right.
set smarttab               " Backspace removes 'shiftwidth' worth of spaces.
set wrap                   " Wrap long lines.
set ruler                  " Show the ruler in the statusline.
set textwidth=80           " Wrap at n characters.
set hlsearch    " Enable highlighted search pattern
set background=dark      " Set the background color scheme to dark
set ignorecase   " Ignore case of searches
set incsearch   " Highlight dynamically as pattern is typed
set showmode   " Show the current mode
set showmatch   " Show the matching part of {} [] () 
set laststatus=2   " Set the status bar
set hidden   " stops vim asking to save the file when switching buffer.
set scrolloff=15   " scroll page when cursor is 8 lines from top/bottom
set sidescrolloff=8   " scroll page when cursor is 8 spaces from left/right
set splitbelow   " split go below
set splitright   " vertical split to the right

" ----------------------------------------------------------------------------------------------------

" Show invisibles
set listchars=tab:▸\ ,nbsp:␣,trail:•,precedes:«,extends:»
highlight NonText guifg=#4a4a59
highlight SpecialKey guifg=#4a4a59

" Set hybrid relative number
"set number relativenumber
":set nu rnu

" turn hybrid line numbers off
":set nonumber norelativenumber
":set nonu nornu

" Keyboard Shortcuts and Keymapping
nnoremap <F5> :set number! relativenumber!<CR> " Press F5 to get hybrid relative numbering on and off
nnoremap <F6> :set number! <CR> " Press F6 to get Absolute numbering on and off
" ---------------------------------------------------------------------------------------

autocmd InsertEnter * set paste  " Automatically set paste mode when entering insert mode
autocmd InsertLeave * set nopaste        " Optionally, reset paste mode when leaving insert mode
autocmd BufWritePre *.py :%s/\+$//e" Remove Trailing white spaces from Python and Fortran files. 
autocmd BufWritePre *.f90 :%s/\+$//e
autocmd BufWritePre *.f95 :%s/\+$//e
autocmd BufWritePre *.for :%s/\+$//e
"
" ----------------------------------------------------------------------------------------------------
"
" Statusline functions and commands
"
set laststatus=2" Set the status bar 
set noshowmode" Disable showmode - i.e. Don't show mode texts like --INSERT-- in current statusline.

" Sets the gui font only in guivims not in terminal modes.
set guifont=MesloLGL\ Nerd\ Font\ Propo:h17

" Define the icons for specific file types

function! GetFileTypeIcon()
    let l:filetype = &filetype
    if l:filetype == 'python'
        return ''
    elseif l:filetype == 'cpp'
        return ''
    elseif l:filetype == 'fortran'
        return '󱈚'
    elseif l:filetype == 'markdown'
        return ''
    elseif l:filetype == 'sh'
        return ''
    elseif l:filetype == 'zsh'
        return ''
    elseif l:filetype == 'tex'
        return ''
    elseif l:filetype == 'vim'
        return ''
    elseif l:filetype == 'conf'
        return ''
    elseif l:filetype == 'in'
        return ''
    elseif l:filetype == 'dat'
        return ''
    elseif l:filetype == 'txt'
        return '󰯂'
    else
        return '󰈙'
    endif
endfunction

let g:currentmode={
       \ 'n'  : 'NORMAL ',
       \ 'v'  : 'VISUAL ',
       \ 'V'  : 'V·Line ',
       \ 'Vb' : 'V·Block ',
       \ 'i'  : 'INSERT ',
       \ 'R'  : 'Replace ',
       \ 'r'  : 'Replace ',
       \ 'vr' : 'V·Replace ',
       \ 'f'  : 'Finder ',
       \ 'c'  : 'Command ',
       \ 't'  : 'Terminal ',
       \ 's'  : 'Select ',
       \ '!'  : 'Shell '
       \}
 
" ----------------------------------------------------------------------------------------------------
" Define Color highlight groups for mode boxes

" Get the colours from here for terminal emulation - https://ss64.com/bash/syntax-colors.html
" You can convert the Xterm colours to HEX colours online. 

" highlight StslineNormalColor  ctermbg=240 ctermfg=15 guibg=#0000ff guifg=#000000 " Brown bg cream text
highlight StslineNormalColor ctermbg=172 ctermfg=0 guibg=#000000 guifg=#afafaf
highlight StslineInsertColor  ctermbg=2 ctermfg=0 guibg=#00ff00 guifg=#000000  "
highlight StslineReplaceColor ctermbg=1 ctermfg=15 guibg=#ff0000 guifg=#ffffff "
highlight StslineVisualColor  ctermbg=3 ctermfg=0 guibg=#ffff00 guifg=#000000  "
highlight StslineCommandColor ctermbg=4 ctermfg=15 guibg=#0000ff guifg=#ffffff " 
highlight StslineTerminalColor ctermbg=240 ctermfg=15 guibg=#0000ff guifg=#000000

highlight OrangeFileIcon      ctermbg=236 ctermfg=177 guibg=#FFD700 guifg=#000000     
highlight StatusPercent       ctermbg=0 ctermfg=15 guibg=#000000 guifg=#ffffff  
highlight StatusBuffer        ctermbg=236 ctermfg=220 guibg=#1E1E1E guifg=#FFCC00 
highlight StatusLocation      ctermbg=4 ctermfg=0 guibg=#0000ff guifg=#000000  
highlight StatusModified      ctermbg=0 ctermfg=5 guibg=#000000 guifg=#ff00ff
" highlight StatusFilePath      ctermbg=172 ctermfg=0 guibg=#000000 guifg=#afafaf   " Bright orange bg with black text
highlight StatusFilePath      ctermbg=236 ctermfg=167 guibg=#2D2D2D guifg=#E06C75  
highlight StatusGitColour     ctermbg=28 ctermfg=0 guibg=#2BBB4F guifg=#080808
highlight StatusTabs      ctermbg=236 ctermfg=150 guibg=#282C34 guifg=#98C379

" Colours for tab bar
highlight TabLineFill     ctermbg=236   ctermfg=167  guibg=#000000 guifg=#ffffff
highlight TabLine         ctermbg=236   ctermfg=8   guibg=#000000 guifg=#808080
highlight TabLineSel      ctermbg=236   ctermfg=167  guibg=#000000 guifg=#ffffff
highlight TabLineModified ctermbg=236   ctermfg=1   guibg=#000000 guifg=#ff0000

" ctermbg - cterm displays only on terminal
" ctermfg - foreground colors 
" cterm=bold gives you bold letters 

" Define the function to update the statusline
function! UpdateStatusline()
  let l:mode = mode()
  let l:mode_symbol = ''  " Displays symbol for all modes
  let l:mode_text = get(g:currentmode, l:mode, 'NORMAL')
  
  if l:mode ==# 'i'
    let l:color = 'StslineInsertColor'
  elseif l:mode ==# 'R' || l:mode ==# 'r' || l:mode ==# "\<C-v>"
    let l:color = 'StslineReplaceColor'
  elseif l:mode ==# 'v' || l:mode ==# 'V'
    let l:color = 'StslineVisualColor'
  elseif l:mode ==# 't'
    let l:color = 'StslineCommandColor'
  elseif l:mode ==# 'c' || l:mode ==# '!'
    let l:color = 'StslineCommandColor'
  elseif l:mode ==# 's'
    let l:color = 'StslineTerminalColor'
  elseif l:mode ==# 't'
    let l:color = 'StslineCommandColor'
  else
    let l:color = 'StslineNormalColor'
  endif

" ----------------------------------------------------------------------------------------------------

" Function to Display the names of the open buffers

  let l:buffer_list = getbufinfo({'bufloaded': 1})
  let l:buffer_names = []
  for l:buf in l:buffer_list
    let l:buffer_name = buf.name != '' ? fnamemodify(buf.name, ':t') : '[No Name]'
    call add(l:buffer_names, l:buf.bufnr . ':' . l:buffer_name)
  endfor

" Function to get the tab information
function! GetTabsInfo()
  let l:tabs = ''
  for i in range(1, tabpagenr('$'))
    let l:tabnr = i
    let l:tabname = fnamemodify(bufname(tabpagebuflist(i)[tabpagewinnr(i) - 1]), ':t')
    let l:modified = getbufvar(tabpagebuflist(i)[tabpagewinnr(i) - 1], '&modified')
    let l:tabstatus = l:modified ? '%#TabLineModified#*' : '%#TabLine#'
    if i == tabpagenr()
      let l:tabstatus = '%#TabLineSel#'
    endif
    let l:tabs .= l:tabstatus . '  ' . l:tabnr . ':' . l:tabname . ' '
  endfor
  return l:tabs
endfunction

set tabline=%!GetTabsInfo()
let l:tab_count = tabpagenr('$')

" Construct the status line

  let &statusline = '%#' . l:color . '#'" Apply box colour
  let &statusline .= ' ' . l:mode_symbol . ' '          " Mode symbol
  let &statusline .= ' ' . l:mode_text . ''" Mode text with space before and after
  let &statusline .= '%#StatusBuffer# Buffers ﬘: ' . join(l:buffer_names, ', ') " Displays the number of buffers open in vim
  let &statusline .= '%#StatusTabs# Tabs 󰝜 : ' . l:tab_count . ' '
  let &statusline .= '%{&readonly ? "ReadOnly " : ""}'        " Add readonly indicator 
" let &statusline .= '%#StatusGitColour# %{b:gitbranch}'" My zsh displays the git status, uncomment if you want.
  let &statusline .= '%#StatusFilePath#  %F %m %{&modified ? " " : ""}'
  let &statusline .= '%='
  let &statusline .= '%#OrangeFileIcon#  %{GetFileTypeIcon()} '
  let &statusline .= '%#OrangeFileIcon#%{&filetype ==# "" ? "No Type" : &filetype}  '
  let &statusline .= '%#StatusTabs#  %p%%  '  
  let &statusline .= '%#StatusTabs#  %-5.( %l/%L, %c%V%) '

endfunction

" Update the status line when changing modes
augroup Statusline
  autocmd!
  autocmd InsertEnter,InsertLeave,WinEnter,BufEnter,CmdlineEnter,CmdlineLeave,CursorHold,CursorHoldI,TextChanged,TextChangedI,ModeChanged * call UpdateStatusline()
augroup END

" Initial status line update
call UpdateStatusline()

" ----------------------------------------------------------------------------------------------------

" Function to get the git status for the display in statusline
" This Function is under comment because my ZSH displays what I need. Uncomment this if you need this. Also uncomment one line above, it is also mentioned there

"function! StatuslineGitBranch()
"  let b:gitbranch=""
"  if &modifiable
"    try
"      let l:dir=expand('%:p:h')
"      let l:gitrevparse = system("git -C ".l:dir." rev-parse --abbrev-ref HEAD")
"      if !v:shell_error
"let b:gitbranch="( ".substitute(l:gitrevparse, '\n', '', 'g').") "
"      endif
"    catch
"    endtry
"  endif
"endfunction
"
"augroup GetGitBranch
"  autocmd!
"  autocmd VimEnter,WinEnter,BufEnter * call StatuslineGitBranch()
"augroup END

" Function to check the spelling checking
"function! SpellToggle()
"    if &spell
"      setlocal spell! spelllang&
"    else
"      setlocal spell spelllang=en_us
"    endif
"endfunction
