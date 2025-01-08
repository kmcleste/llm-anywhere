# LLM Anywhere

## Requirements

- python >= 3.11
- uv
- tmux
- CUDA-capable gpu

## Getting Started

### Install Dependencies

```zsh
uv sync --frozen
```

### Update zshrc

Add the following lines to your zshrc:

```zsh
llm_serve() {
  make -C /path-to-repo/llm-anywhere serve MODEL="${1:-QWEN}"
}
alias llm_stop='(make -C /path-to-repo/llm-anywhere stop)'
alias llm_attach='(make -C /path-to-repo/llm-anywhere attach)'
```

Source your shell or open a new terminal.

```zsh
source ~/.zshrc
```

## Usage

In the [Makefile](Makefile), you will see various model configs. Either use mine or add your own.
You simply need to follow the existing convention of:

```zsh
MODEL_NAME_CONFIG := MODEL CONFIG HERE
```

This will allow you to call the make commands from anywhere using:

```zsh
# Serve the default model (qwen2.5-coder-14b-instruct-awq)
llm_serve

# Serve gemma
llm_serve GEMMA

# Serve your custom model
llm_serve YOUR_CUSTOM_MODEL_NAME

# Open the detached tmux session
llm_attach

# Stop the API
llm_stop
```

If you attached the tmux session and need to close the window without shutting down the service, use `Ctrl+b` then `d`.

Now you can start an llm anywhere. 😊
