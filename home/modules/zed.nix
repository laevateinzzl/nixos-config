{ config, pkgs, lib, ... }:

{
  home.packages = [ pkgs.zed-editor ];

  # Zed编辑器配置
  home.file.".config/zed/settings.json".text = ''
  {
    "theme": "Catppuccin Mocha",
    "ui_font_size": 14,
    "buffer_font_size": 14,
    "ui_font_family": "JetBrainsMono Nerd Font",
    "buffer_font_family": "JetBrainsMono Nerd Font",
    "buffer_line_height": {
      "custom": 1.4
    },
    "show_file_icons": true,
    "show_tab_icons": true,
    "show_completion_icons": true,
    "always_show_tab_bar": true,
    "project_panel": {
      "folder_icons": true,
      "show_scrollbars": true,
      "auto_reveal_entries": true,
      "indent_size": 4,
      "indent_guides": {
        "enabled": true
      }
    },
    "tabs": {
      "git_status": true
    },
    "inlay_hints": {
      "enabled": true,
      "show_type_hints": true,
      "show_parameter_hints": true,
      "show_other_hints": true
    },
    "autosave": "on_focus_change",
    "auto_update": true,
    "format_on_save": "on",
    "remove_trailing_whitespace_on_save": true,
    "ensure_final_newline_on_save": true,
    "hover_popover_font_size": 14,
    "menu_border_radius": 6,
    "project_panel_button": true,
    "show_git_status": true,
    "git_gutter": "tracked_files",
    "git": {
      "git_gutter": "tracked_files",
      "inline_blame": {
        "enabled": true,
        "delay_ms": 500
      }
    },
    "tab_bar": {
      "show": true,
      "show_dividers": true,
      "activate_on_close": "next_tab"
    },
    "scrollbar": {
      "show": "auto",
      "clicks": "scroll"
    },
    "toolbar": {
      "show": true,
      "breadcrumbs": true
    },
    "auto_indent": true,
    "auto_pairs": true,
    "auto_surround": true,
    "brace_matching": "close_braces",
    "strip_trailing_whitespace": true,
    "vertical_scroll_margin": 3,
    "horizontal_scroll_margin": 6,
    "scrollbar_sensitivity": 1,
    "preview_tabs": true,
    "soft_wrap": "editor_width",
    "preferred_line_length": 80,
    "word_wrap": true,
    "wrapping": "preferr_line_length",
    "diff_base_head": "HEAD",
    "diff_base_ignore_whitespace": false,
    "diff_word_diff": false,
    "telemetry": {
      "metrics": false,
      "diagnostics": false
    },
    "journal": {
      "hour_format": "H24"
    },
    "hour_format": "H24",
    "language": {
      "C++": {
        "format_on_save": "on",
        "formatter": "clang-format"
      },
      "Python": {
        "format_on_save": "on",
        "formatter": "black",
        "linter": "ruff"
      },
      "JavaScript": {
        "format_on_save": "on",
        "formatter": "prettier",
        "linter": "eslint"
      },
      "TypeScript": {
        "format_on_save": "on",
        "formatter": "prettier",
        "linter": "eslint"
      },
      "JSON": {
        "format_on_save": "on",
        "formatter": "prettier"
      },
      "Rust": {
        "format_on_save": "on",
        "formatter": "rustfmt"
      },
      "Nix": {
        "format_on_save": "on",
        "formatter": "nixfmt"
      },
      "Go": {
        "format_on_save": "on",
        "formatter": "gofmt",
        "linter": "golangci-lint"
      }
    },
    "lsp": {
      "rust-analyzer": {
        "initialization_options": {
          "checkOnSave": {
            "command": "clippy"
          },
          "cargo": {
            "features": "all"
          },
          "procMacro": {
            "enable": true
          }
        }
      },
      "pyright": {
        "initialization_options": {
          "pythonPath": "/run/current-system/sw/bin/python3"
        }
      },
      "nil": {
        "initialization_options": {
          "nil": {
            "formatting": {
              "command": ["alejandra"]
            },
            "nix": {
              "flake": {
                "autoArchive": true
              }
            }
          }
        }
      }
    },
    "languages": {
      "C++": {
        "tab_size": 4,
        "hard_tabs": false
      },
      "Python": {
        "tab_size": 4,
        "hard_tabs": false
      },
      "JavaScript": {
        "tab_size": 2,
        "hard_tabs": false
      },
      "TypeScript": {
        "tab_size": 2,
        "hard_tabs": false
      },
      "JSON": {
        "tab_size": 2,
        "hard_tabs": false
      },
      "Rust": {
        "tab_size": 4,
        "hard_tabs": false
      },
      "Nix": {
        "tab_size": 2,
        "hard_tabs": false
      },
      "Go": {
        "tab_size": 4,
        "hard_tabs": false
      },
      "YAML": {
        "tab_size": 2,
        "hard_tabs": false
      },
      "TOML": {
        "tab_size": 2,
        "hard_tabs": false
      },
      "Markdown": {
        "tab_size": 2,
        "hard_tabs": false
      }
    },
    "keymap": [
      {
        "context": "Editor",
        "bindings": {
          "ctrl+s": "workspace::Save",
          "ctrl+shift+s": "workspace::SaveAs",
          "ctrl+z": "editor::Undo",
          "ctrl+shift+z": "editor::Redo",
          "ctrl+x": "editor::Cut",
          "ctrl+c": "editor::Copy",
          "ctrl+v": "editor::Paste",
          "ctrl+a": "editor::SelectAll",
          "ctrl+f": "project_panel::ToggleFocus",
          "ctrl+shift+f": "project_search::ToggleFocus",
          "ctrl+p": "file_finder::Toggle",
          "ctrl+shift+p": "command_palette::Toggle",
          "ctrl+g": "go_to_line::Toggle",
          "ctrl+\\": "pane::SplitHorizontal",
          "ctrl+shift+\\": "pane::SplitVertical",
          "ctrl+w": "pane::CloseActiveItem",
          "ctrl+1": "pane::ActivateItem1",
          "ctrl+2": "pane::ActivateItem2",
          "ctrl+3": "pane::ActivateItem3",
          "ctrl+4": "pane::ActivateItem4",
          "ctrl+5": "pane::ActivateItem5",
          "ctrl+6": "pane::ActivateItem6",
          "ctrl+7": "pane::ActivateItem7",
          "ctrl+8": "pane::ActivateItem8",
          "ctrl+9": "pane::ActivateItem9",
          "ctrl+0": "pane::ActivateLastItem",
          "ctrl+tab": "pane::ActivateNextItem",
          "ctrl+shift+tab": "pane::ActivatePrevItem",
          "ctrl+shift+n": "project_panel::NewFile",
          "ctrl+shift+o": "project_panel::Open",
          "ctrl+shift+a": "project_panel::ToggleAll",
          "ctrl+shift+r": "project_panel::Rename",
          "ctrl+shift+d": "project_panel::Duplicate",
          "ctrl+shift+m": "project_panel::Move",
          "ctrl+shift+c": "project_panel::CopyPath",
          "ctrl+shift+l": "project_panel::RevealInFileManager",
          "ctrl+shift+i": "project_panel::NewDirectory",
          "ctrl+shift+d": "project_panel::Delete",
          "ctrl+shift+f": "project_search::ToggleFocus",
          "ctrl+shift+c": "project_panel::CopyPath",
          "ctrl+shift+r": "project_panel::Rename",
          "ctrl+shift+m": "project_panel::Move",
          "ctrl+shift+d": "project_panel::Duplicate",
          "ctrl+shift+a": "project_panel::ToggleAll",
          "ctrl+shift+l": "project_panel::RevealInFileManager",
          "ctrl+shift+i": "project_panel::NewDirectory",
          "ctrl+shift+o": "project_panel::Open",
          "ctrl+shift+n": "project_panel::NewFile",
          "ctrl+shift+f": "project_search::ToggleFocus",
          "ctrl+shift+p": "command_palette::Toggle",
          "ctrl+shift+z": "editor::Redo",
          "ctrl+shift+s": "workspace::SaveAs",
          "ctrl+shift+w": "pane::CloseActiveItem",
          "ctrl+shift+tab": "pane::ActivatePrevItem",
          "ctrl+shift+\\": "pane::SplitVertical",
          "ctrl+shift+n": "project_panel::NewFile",
          "ctrl+shift+o": "project_panel::Open",
          "ctrl+shift+f": "project_search::ToggleFocus",
          "ctrl+shift+p": "command_palette::Toggle",
          "ctrl+shift+z": "editor::Redo",
          "ctrl+shift+s": "workspace::SaveAs",
          "ctrl+shift+w": "pane::CloseActiveItem",
          "ctrl+shift+tab": "pane::ActivatePrevItem",
          "ctrl+shift+\\": "pane::SplitVertical"
        }
      },
      {
        "context": "Terminal",
        "bindings": {
          "ctrl+c": "terminal::Kill",
          "ctrl+shift+c": "terminal::Copy",
          "ctrl+shift+v": "terminal::Paste",
          "ctrl+w": "pane::CloseActiveItem",
          "ctrl+tab": "pane::ActivateNextItem",
          "ctrl+shift+tab": "pane::ActivatePrevItem"
        }
      },
      {
        "context": "ProjectPanel",
        "bindings": {
          "enter": "project_panel::Rename",
          "delete": "project_panel::Delete",
          "space": "project_panel::ToggleSelection",
          "a": "project_panel::NewFile",
          "shift+a": "project_panel::NewDirectory",
          "c": "project_panel::CopyPath",
          "r": "project_panel::Rename",
          "d": "project_panel::Duplicate",
          "m": "project_panel::Move",
          "i": "project_panel::NewDirectory",
          "o": "project_panel::Open",
          "space": "project_panel::ToggleSelection",
          "delete": "project_panel::Delete",
          "enter": "project_panel::Rename"
        }
      }
    ],
    "assistant": {
      "enabled": true,
      "version": "1",
      "provider": "openai",
      "openai_api_key": null
    },
    "ssh": {
      "agent": true
    },
    "terminal": {
      "alternate_scroll": true,
      "blinking": "terminal_blink",
      "copy_on_select": false,
      "dock": "bottom",
      "detect_venv": {
        "on": {
          "activate_in_inactive_terminal": true
        }
      },
      "env": {
        "TERM": "xterm-256color",
        "COLORTERM": "truecolor"
      },
      "font_family": "JetBrainsMono Nerd Font",
      "font_size": 14,
      "line_height": "comfortable",
      "option_as_meta": false,
      "shell": {
        "program": "/run/current-system/sw/bin/zsh",
        "args": []
      },
      "working_directory": "current_project_directory"
    }
  }
  '';

  # Catppuccin主题
  home.file.".config/zed/themes/catppuccin-mocha.json".text = ''
  {
    "name": "Catppuccin Mocha",
    "author": "Catppuccin",
    "semantic_tokens": true,
    "text": "#cdd6f4",
    "background": "#1e1e2e",
    "cursor": "#f5e0dc",
    "cursor_inactive": "#6c7086",
    "selection": "#45475a",
    "selection_border": "#89b4fa",
    "invisible": "#6c7086",
    "comment": {
      "color": "#6c7086",
      "style": "italic"
    },
    "comment_documentation": {
      "color": "#6c7086",
      "style": "italic"
    },
    "string": "#a6e3a1",
    "string_regex": "#f9e2af",
    "string_escape": "#f38ba8",
    "constant": {
      "color": "#fab387"
    },
    "constant_numeric": "#fab387",
    "constant_numeric_float": "#fab387",
    "constant_character": "#a6e3a1",
    "constant_character_escape": "#f38ba8",
    "constant_language": {
      "color": "#cba6f7",
      "style": "bold"
    },
    "constant_regex": "#f9e2af",
    "keyword": {
      "color": "#cba6f7",
      "style": "bold"
    },
    "keyword_control": {
      "color": "#cba6f7",
      "style": "bold"
    },
    "keyword_operator": {
      "color": "#89dceb",
      "style": "bold"
    },
    "keyword_function": {
      "color": "#cba6f7",
      "style": "bold"
    },
    "keyword_return": {
      "color": "#cba6f7",
      "style": "bold"
    },
    "label": {
      "color": "#f9e2af",
      "style": "italic"
    },
    "operator": {
      "color": "#89dceb"
    },
    "function": {
      "color": "#89b4fa"
    },
    "function_method": {
      "color": "#89b4fa"
    },
    "function_builtin": {
      "color": "#cba6f7"
    },
    "function_macro": {
      "color": "#89b4fa"
    },
    "variable": {
      "color": "#f2cdcd"
    },
    "variable_builtin": {
      "color": "#f38ba8"
    },
    "variable_parameter": {
      "color": "#f2cdcd"
    },
    "variable_other_member": "#f2cdcd",
    "type": {
      "color": "#f9e2af"
    },
    "type_builtin": {
      "color": "#f9e2af"
    },
    "type_enum_variant": {
      "color": "#f9e2af"
    },
    "module": "#f38ba8",
    "module_path": "#f38ba8",
    "attribute": {
      "color": "#f9e2af"
    },
    "attribute_builtin": {
      "color": "#f9e2af",
      "style": "bold"
    },
    "constructor": "#89b4fa",
    "special": "#cba6f7",
    "markup": {
      "heading": {
        "color": "#f9e2af",
        "style": "bold"
      },
      "list": "#f2cdcd",
      "raw": "#a6e3a1",
      "quote": "#89b4fa",
      "link": {
        "color": "#89b4fa",
        "style": "underline"
      },
      "link_text": "#f9e2af",
      "link_url": {
        "color": "#89dceb",
        "style": "underline"
      },
      "emphasis": {
        "color": "#f2cdcd",
        "style": "italic"
      },
      "strong": {
        "color": "#f2cdcd",
        "style": "bold"
      },
      "strikethrough": {
        "color": "#f2cdcd",
        "style": "strikethrough"
      },
      "inserted": {
        "color": "#a6e3a1"
      },
      "deleted": {
        "color": "#f38ba8"
      },
      "changed": {
        "color": "#f9e2af"
      }
    },
    "diff": {
      "addition": "#a6e3a1",
      "deletion": "#f38ba8",
      "modification": "#f9e2af"
    },
    "diagnostic": {
      "error": {
        "color": "#f38ba8",
        "style": "underline"
      },
      "warning": {
        "color": "#f9e2af",
        "style": "underline"
      },
      "info": {
        "color": "#89dceb",
        "style": "underline"
      },
      "hint": {
        "color": "#a6e3a1",
        "style": "underline"
      }
    },
    "ui": {
      "text": "#cdd6f4",
      "text_placeholder": "#6c7086",
      "text_muted": "#6c7086",
      "text_selected": "#cdd6f4",
      "text_accent": "#89b4fa",
      "text_inverse": "#1e1e2e",
      "separator": {
        "color": "#6c7086"
      },
      "background": "#1e1e2e",
      "background_secondary": "#181825",
      "background_tertiary": "#11111b",
      "background_selected": "#45475a",
      "background_hover": "#313244",
      "background_active": "#45475a",
      "background_inactive": "#1e1e2e",
      "foreground": "#cdd6f4",
      "foreground_selected": "#cdd6f4",
      "foreground_inactive": "#6c7086",
      "foreground_active": "#cdd6f4",
      "border": {
        "color": "#585b70"
      },
      "border_active": {
        "color": "#89b4fa"
      },
      "border_selected": {
        "color": "#cba6f7"
      },
      "border_focus": {
        "color": "#89b4fa"
      },
      "border_muted": {
        "color": "#45475a"
      },
      "border_transparent": "transparent",
      "accent": "#89b4fa",
      "accent_active": "#cba6f7",
      "accent_selected": "#f9e2af",
      "accent_hover": "#a6e3a1",
      "accent_warning": "#f9e2af",
      "accent_error": "#f38ba8",
      "accent_info": "#89dceb",
      "accent_success": "#a6e3a1",
      "accent_muted": "#6c7086",
      "status_bar": {
        "text": "#cdd6f4",
        "background": "#181825",
        "background_hover": "#313244"
      },
      "tab": {
        "text": "#cdd6f4",
        "text_active": "#cdd6f4",
        "text_inactive": "#6c7086",
        "text_selected": "#cdd6f4",
        "background": "#1e1e2e",
        "background_active": "#45475a",
        "background_inactive": "#1e1e2e",
        "background_selected": "#45475a",
        "border": "#585b70",
        "border_active": "#89b4fa",
        "border_selected": "#cba6f7"
      },
      "panel": {
        "text": "#cdd6f4",
        "background": "#181825",
        "background_hover": "#313244"
      },
      "scrollbar": {
        "track": "#45475a",
        "thumb": "#6c7086",
        "thumb_hover": "#a6adc8"
      },
      "button": {
        "text": "#cdd6f4",
        "text_hover": "#1e1e2e",
        "background": "#45475a",
        "background_hover": "#89b4fa"
      },
      "input": {
        "text": "#cdd6f4",
        "placeholder": "#6c7086",
        "background": "#313244",
        "background_selected": "#45475a",
        "border": "#585b70",
        "border_selected": "#89b4fa"
      },
      "list": {
        "text": "#cdd6f4",
        "text_selected": "#cdd6f4",
        "background": "#1e1e2e",
        "background_selected": "#45475a",
        "hover": "#313244"
      },
      "tree": {
        "text": "#cdd6f4",
        "text_selected": "#cdd6f4",
        "background": "#1e1e2e",
        "background_selected": "#45475a",
        "hover": "#313244"
      },
      "menu": {
        "text": "#cdd6f4",
        "text_selected": "#cdd6f4",
        "background": "#1e1e2e",
        "background_selected": "#45475a",
        "hover": "#313244"
      },
      "tooltip": {
        "text": "#cdd6f4",
        "background": "#313244",
        "border": "#585b70"
      }
    }
  }
  '';

  # Zed扩展配置
  home.file.".config/zed/extensions.json".text = ''
  {
    "extensions": [
      "catppuccin",
      "nix",
      "rust",
      "python",
      "typescript",
      "javascript",
      "go",
      "dockerfile",
      "yaml",
      "toml",
      "json",
      "markdown",
      "git",
      "github",
      "gitlab",
      "discord-presence",
      "exercism",
      "copilot",
      "tabnine",
      "wakatime"
    ]
  }
  '';
}