SESSION_NAME = vllm
QWEN_CONFIG := Qwen/Qwen2.5-Coder-14B-Instruct-AWQ --dtype auto --max-model-len 8192 --max-num-seqs 2
GEMMA_CONFIG := hugging-quants/gemma-2-9b-it-AWQ-INT4 --dtype auto
LLAMA31_CONFIG := hugging-quants/Meta-Llama-3.1-8B-Instruct-AWQ-INT4 --dtype auto --max-model-len 16835

MODEL ?= QWEN

serve:
	@echo "Serving $(MODEL)..." && \
	tmux new-session -A -d -s $(SESSION_NAME) 'uv run vllm serve $($(MODEL)_CONFIG)' && \
	until curl -s -f http://127.0.0.1:8000/health > /dev/null 2>&1; do \
	echo "Waiting for service to start..."; \
		sleep 5; \
	done && \
	echo "[READY]"

stop:
	@echo "Stopping service..."
	@if tmux has-session -t $(SESSION_NAME) 2>/dev/null; then \
		tmux send-keys -t $(SESSION_NAME) C-c; \
		echo "Waiting for service to shut down..."; \
		while curl -s -f http://127.0.0.1:8000/health > /dev/null 2>&1; do \
		echo "Service is still running..."; \
			sleep 2; \
		done; \
		tmux kill-session -t $(SESSION_NAME); \
		echo "[STOPPED]"; \
	else \
		echo "No active session found"; \
	fi

attach:
	@if tmux has-session -t $(SESSION_NAME) 2>/dev/null; then \
		tmux attach -t $(SESSION_NAME); \
	else \
		echo "No session named $(SESSION_NAME) exists"; \
	fi

