# 🚀 Micro Linux Development Environment

A powerful, lightweight development environment originally inspired by Termux on Android, now evolved into a versatile toolset for any Linux environment. Perfect for both mobile and desktop development workflows.

## 🌟 Overview

Micro Linux transforms your terminal into a complete development environment with carefully selected tools optimized for productivity. Originally designed for Termux on Android, this project has grown to support all major Linux distributions.

> **Note:** This is an ongoing project. New features and tools will be added regularly.

## 📦 Installed Tools

### Core Development Tools
- **Vim** - Feature-rich text editor with custom plugins and configuration
- **Go** - Latest version of the Go programming language
- **Git + Lazygit** - Version control with intuitive terminal UI
- **FZF** - Fuzzy finder for files, command history and more

### System Utilities
- **Net-tools** - Essential networking utilities  
- **Tree** - Directory visualization tool

## 🔥 Key Features

### 📝 Vim Supercharged
Your Vim installation comes pre-configured with:

- **File Navigation**
  - NERDTree file explorer (toggle with `Ctrl+n`)
  - Fuzzy file finding with `Ctrl+p`
  - Buffer management with `:Buffers`

- **Code Enhancement**
  - Syntax highlighting for major languages
  - Go development support with auto-imports
  - Git integration (see changes in the gutter)
  - Auto-pairs for brackets and quotes
  - Code commenting shortcuts

- **Visual Improvements**
  - Gruvbox color scheme (easy on the eyes)
  - Airline status bar
  - Line numbering and highlighting

### 🔍 Terminal Enhancements
- **History search** - Press `Ctrl+r` for fuzzy search through command history
- **Smart aliases** - Common commands simplified
- **Go environment** - Properly configured Go development path

## 💡 Usage Guide

### Vim Essentials

| Command/Shortcut | Action |
|------------------|--------|
| `Ctrl+n` | Toggle NERDTree file browser |
| `Ctrl+p` | Fuzzy find files in project |
| `:Buffers` | List and select open buffers |
| `Ctrl+j/k/h/l` | Navigate between splits |
| `gc` | Comment/uncomment selected lines |
| `:GFiles` | Fuzzy find Git-tracked files |
| `:History` | Browse command history |

#### Vim Go Development
- `:GoRun` - Run current Go file
- `:GoBuild` - Build current Go package
- `:GoTest` - Run tests for current package
- `:GoImports` - (Automatic) Format and organize imports

### Terminal Commands & Aliases

| Alias | Command | Description |
|-------|---------|-------------|
| `ll` | `ls -alF` | Detailed listing with file types |
| `la` | `ls -A` | List all files including hidden |
| `..` | `cd ..` | Go up one directory |
| `...` | `cd ../..` | Go up two directories |
| `gs` | `git status` | Check Git status |
| `lg` | `lazygit` | Launch interactive Git UI |
| `dc` | `docker-compose` | Docker Compose shorthand |

### Go Development
```bash
# Build and run a Go application
go build -o myapp main.go
./myapp

# Install a Go package
go get github.com/username/repo

# Run tests
go test ./...
```

## 🛠️ Customization

### Extending Vim
Edit your `~/.vimrc` file to add new plugins or customize settings:

```vim
" Add a new plugin
Plug 'username/new-plugin'

" Change color scheme
colorscheme nord

" Modify key mappings
nnoremap <leader>s :w<CR>
```

Run `:PlugInstall` after adding new plugins.


## 📱 Termux-Specific Notes

This project was originally inspired by Termux on Android. When using in Termux:

- Some features may require additional permissions on Android
- For best results, use with a Bluetooth keyboard
- Consider installing [Termux:Styling](https://f-droid.org/en/packages/com.termux.styling/) for better visual customization
- Use the volume keys for special keys not available on soft keyboards

To install on Termux:
```bash
pkg update && pkg upgrade
pkg install git
git clone https://github.com/sohaib1khan/Micro_Linux.git
cd Micro_Linux
chmod +x setup_microlinux.sh
./setup_microlinux.sh
```

## 📚 Additional Resources

- [Vim Cheat Sheet](https://vim.rtorr.com/)
- [Go Documentation](https://golang.org/doc/)
- [Lazygit Tutorial](https://github.com/jesseduffield/lazygit#tutorial)
- [FZF Examples](https://github.com/junegunn/fzf/wiki/examples)
- [Termux Wiki](https://wiki.termux.com/wiki/Main_Page)

---