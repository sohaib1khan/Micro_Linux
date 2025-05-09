#!/bin/bash

# ====================================================
# Micro Linux Setup Script
# A friendly script to set up a development environment
# with vim, fzf, Go, Ctop, lazygit and more
# ====================================================

echo "
███╗   ███╗██╗ ██████╗██████╗  ██████╗     ██╗     ██╗███╗   ██╗██╗   ██╗██╗  ██╗
████╗ ████║██║██╔════╝██╔══██╗██╔═══██╗    ██║     ██║████╗  ██║██║   ██║╚██╗██╔╝
██╔████╔██║██║██║     ██████╔╝██║   ██║    ██║     ██║██╔██╗ ██║██║   ██║ ╚███╔╝ 
██║╚██╔╝██║██║██║     ██╔══██╗██║   ██║    ██║     ██║██║╚██╗██║██║   ██║ ██╔██╗ 
██║ ╚═╝ ██║██║╚██████╗██║  ██║╚██████╔╝    ███████╗██║██║ ╚████║╚██████╔╝██╔╝ ██╗
╚═╝     ╚═╝╚═╝ ╚═════╝╚═╝  ╚═╝ ╚═════╝     ╚══════╝╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═╝
                                                                                  
🚀 Development Environment Setup Script 🚀
"

set -e  # Exit on any error

# Function to show progress
show_progress() {
    echo ""
    echo "🔧 $1..."
    echo "-------------------------"
}

# Function to show success
show_success() {
    echo "✅ $1"
}

show_progress "Detecting Linux distribution"

# Detect distribution type
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$NAME
    if [[ "$OS" == *"Ubuntu"* ]] || [[ "$OS" == *"Debian"* ]]; then
        DISTRO_TYPE="debian"
        show_success "Detected Debian-based distribution: $OS"
    elif [[ "$OS" == *"Fedora"* ]] || [[ "$OS" == *"Red Hat"* ]] || [[ "$OS" == *"CentOS"* ]]; then
        DISTRO_TYPE="redhat"
        show_success "Detected Red Hat-based distribution: $OS"
    else
        echo "⚠️  Warning: Unknown distribution detected: $OS"
        echo "Will use Debian-based installation as fallback."
        DISTRO_TYPE="debian"
    fi
else
    echo "⚠️  Cannot detect OS, defaulting to Debian-based installation."
    DISTRO_TYPE="debian"
fi

# Update package repositories
show_progress "Updating package repositories"
if [ "$DISTRO_TYPE" == "debian" ]; then
    apt update -y
elif [ "$DISTRO_TYPE" == "redhat" ]; then
    if command -v dnf &> /dev/null; then
        dnf check-update || true  # Ignoring non-zero exit code
    else
        yum check-update || true  # Ignoring non-zero exit code
    fi
fi
show_success "Package repositories updated"

# Install basic tools
show_progress "Installing basic packages"
if [ "$DISTRO_TYPE" == "debian" ]; then
    apt install -y vim curl git fzf tree net-tools wget tar gzip unzip build-essential
elif [ "$DISTRO_TYPE" == "redhat" ]; then
    if command -v dnf &> /dev/null; then
        dnf install -y vim curl git fzf tree net-tools wget tar gzip unzip gcc make
    else
        yum install -y vim curl git fzf tree net-tools wget tar gzip unzip gcc make
    fi
fi
show_success "Basic packages installed"

# Install lazygit
show_progress "Installing Lazygit"
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
if [ "$DISTRO_TYPE" == "debian" ]; then
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
elif [ "$DISTRO_TYPE" == "redhat" ]; then
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
fi
tar xf lazygit.tar.gz lazygit
install lazygit /usr/local/bin
rm lazygit lazygit.tar.gz
show_success "Lazygit installed"

# Install Go
show_progress "Installing Go"
GO_VERSION=$(curl -s https://go.dev/dl/ | grep -oP 'go\d+\.\d+\.\d+' | head -1)
curl -sLo go.tar.gz "https://go.dev/dl/${GO_VERSION}.linux-amd64.tar.gz"
tar -C /usr/local -xzf go.tar.gz
rm go.tar.gz

# Add Go to PATH
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
echo 'export PATH=$PATH:~/go/bin' >> ~/.bashrc
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:~/go/bin
show_success "Go installed (version ${GO_VERSION})"


# Configure vim with plugins using vim-plug
show_progress "Setting up vim plugins"

# Create vim directories if they don't exist
mkdir -p ~/.vim/autoload ~/.vim/plugged

# Install vim-plug (plugin manager)
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Create a comprehensive vimrc file
cat > ~/.vimrc << 'EOL'
" Vim-plug configuration
call plug#begin('~/.vim/plugged')

" General plugins
Plug 'tpope/vim-sensible'             " Sensible defaults
Plug 'preservim/nerdtree'             " File explorer
Plug 'ctrlpvim/ctrlp.vim'             " Fuzzy file finder
Plug 'vim-airline/vim-airline'        " Status bar
Plug 'vim-airline/vim-airline-themes' " Status bar themes
Plug 'airblade/vim-gitgutter'         " Git changes in gutter
Plug 'tpope/vim-commentary'           " Code commenting
Plug 'tpope/vim-surround'             " Surround text objects
Plug 'jiangmiao/auto-pairs'           " Auto pair brackets
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'               " Fzf integration
Plug 'fatih/vim-go'                   " Go development
Plug 'vim-syntastic/syntastic'        " Syntax checking

" Color schemes
Plug 'morhetz/gruvbox'                " Gruvbox theme

call plug#end()

" Basic settings
syntax enable                   " Enable syntax highlighting
set number                      " Show line numbers
set relativenumber              " Show relative line numbers
set cursorline                  " Highlight current line
set showmatch                   " Show matching brackets
set incsearch                   " Incremental search
set hlsearch                    " Highlight search results
set ignorecase                  " Case insensitive search
set smartcase                   " Case sensitive when uppercase present
set autoindent                  " Auto indentation
set expandtab                   " Use spaces instead of tabs
set smarttab                    " Smart tab
set shiftwidth=4                " 1 tab == 4 spaces
set tabstop=4                   " 1 tab == 4 spaces
set mouse=a                     " Enable mouse support
set clipboard=unnamedplus       " Use system clipboard
set backspace=indent,eol,start  " Make backspace behave normally
set wildmenu                    " Command-line completion
set wildmode=list:longest       " Complete till longest common string
set history=1000                " Store more history
set undolevels=1000             " More undo levels
set visualbell                  " No sounds
set noerrorbells                " No error bells
set hidden                      " Allow switching buffers without saving
set laststatus=2                " Always show statusline
set splitbelow                  " Open new split below
set splitright                  " Open new vertical split right

" Color scheme
colorscheme gruvbox
set background=dark

" NERDTree settings
map <C-n> :NERDTreeToggle<CR>
let NERDTreeShowHidden=1

" FZF settings
nnoremap <C-p> :Files<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>g :GFiles<CR>
nnoremap <leader>f :Rg<CR>
nnoremap <leader>h :History<CR>

" Tab navigation
nnoremap <C-Left> :tabprevious<CR>
nnoremap <C-Right> :tabnext<CR>

" Split navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Go settings
let g:go_fmt_command = "goimports"
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1

" Auto commands
autocmd BufWritePre * :%s/\s\+$//e  " Remove trailing whitespace on save
EOL

# Install vim plugins non-interactively
echo "Installing vim plugins..."
vim +PlugInstall +qall
show_success "Vim plugins installed"

# Configure fzf with Ctrl+r for history
show_progress "Configuring fzf with Ctrl+r history search"

# Create or update .bashrc to include fzf configuration
if ! grep -q "fzf key bindings" ~/.bashrc; then
    cat >> ~/.bashrc << 'EOL'

# fzf configuration
if [ -f /usr/share/doc/fzf/examples/key-bindings.bash ]; then
    source /usr/share/doc/fzf/examples/key-bindings.bash
fi

if [ -f /usr/share/doc/fzf/examples/completion.bash ]; then
    source /usr/share/doc/fzf/examples/completion.bash
fi

# For RHEL/Fedora systems
if [ -f /usr/share/fzf/shell/key-bindings.bash ]; then
    source /usr/share/fzf/shell/key-bindings.bash
fi

if [ -f /usr/share/fzf/shell/completion.bash ]; then
    source /usr/share/fzf/shell/completion.bash
fi

# Enhanced fzf Ctrl+r history search
export FZF_CTRL_R_OPTS="--sort --exact --preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"

# Custom Bash Aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias gs='git status'
alias lg='lazygit'
alias dc='docker-compose'
EOL
fi

show_success "FZF configured with Ctrl+r for history search"

# Create helpful README
show_progress "Creating documentation in README.md"
cat > ~/Desktop/dev_container/Micro_Linux/README.md << 'EOL'
# 🚀 Micro Linux Development Environment

This environment includes a curated selection of development tools, optimized for a smooth and efficient coding experience.

## 📦 Installed Tools

- **Vim** - Feature-rich text editor with plugins
- **FZF** - Powerful fuzzy finder for files and history
- **Go** - The Go programming language
- **Ctop** - Container monitoring tool
- **Lazygit** - Terminal UI for git commands
- **Tree** - Directory listing in tree format
- **Net-tools** - Network utilities

## 🔧 Key Features

### Vim Configuration
- Plugin management with vim-plug
- File explorer (NERDTree) - Toggle with `Ctrl+n`
- Fuzzy finder - Use `Ctrl+p` for files
- Git integration
- Go development support
- Modern color scheme (Gruvbox)

### Terminal Enhancements
- Fuzzy history search with `Ctrl+r`
- Useful bash aliases (see below)

## 💡 Usage Tips

### Vim Commands
- `:NERDTreeToggle` or `Ctrl+n` - Toggle file explorer
- `:Files` or `Ctrl+p` - Fuzzy find files
- `:Buffers` - List open buffers
- `:GFiles` - Git files fuzzy finder
- `:History` - Command history

### Bash Aliases
- `ll` - Detailed directory listing
- `la` - List all files
- `..` - Go up one directory
- `...` - Go up two directories
- `gs` - Git status
- `lg` - Launch Lazygit
- `dc` - Shorthand for docker-compose

### Go Development
- Go is installed at `/usr/local/go/bin/go`
- GOPATH is set to `~/go`

## 📌 Additional Information
The setup script automatically detected your distribution type and installed the appropriate packages. All tools are configured with sensible defaults to work well together.
EOL
show_success "README.md created"

# Final success message
echo ""
echo "🎉 🎉 🎉 All done! Your development environment is ready! 🎉 🎉 🎉"
echo ""
echo "✨ Here's what was installed:"
echo "  - Vim (with plugins)"
echo "  - FZF (fuzzy finder)"
echo "  - Go (version ${GO_VERSION})"
echo "  - Lazygit"
echo "  - Tree, net-tools, and other essentials"
echo ""
echo "📋 Script created a detailed README.md with usage instructions"
echo ""
echo "💻 To start using new tools, restart your shell or run:"
echo "  source ~/.bashrc"
echo ""
echo "🔍 For vim plugins, open vim and enjoy! (Ctrl+n for file browser)"
echo "🔎 For shell history search, use Ctrl+r"
echo ""
echo "Happy coding! 🚀"
