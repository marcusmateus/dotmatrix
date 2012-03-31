runtime! autoload/pathogen.vim
if exists('g:loaded_pathogen')
  call pathogen#runtime_prepend_subdirectories(expand('~/.vimbundles'))
endif

syntax on
filetype plugin indent on

augroup vimrc
  autocmd!
  autocmd GuiEnter * set guifont=Monaco:h16 guioptions-=T columns=120 lines=70 number
augroup END

" Setup consistent path for swp files
if has("win32") || has("win64")
  set directory=$TMP
else
  let swp_dir = '/tmp/vimswp'
  if !isdirectory(swp_dir)
    call mkdir(swp_dir, 'p')
  endif
  set directory=/tmp/vimswp
end

if filereadable(expand('~/.vimrc.local'))
  source ~/.vimrc.local
endif

" Setup path for vim backups
" if has("win32") || has("win64")
"   "set backupdir=/path/to/dir
" else
"   set backupdir=
" end
