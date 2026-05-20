Step A: Install NVIDIA Container Toolkit
You need this so Docker can "talk" to the GPU.

# Add the package repositories
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg
curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
  sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
  sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

# Install toolkit
sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit

# Restart Docker
sudo systemctl restart docker

# stop ollama, it may compete GPU VRAM
sudo systemctl stop ollama

docker run --gpus all \
    -v ~/.cache/huggingface:/root/.cache/huggingface \
    --ipc=host \
    -p 8086:8086 \
    vllm/vllm-openai:latest \
    --model Qwen/Qwen2.5-Coder-32B-Instruct-AWQ \
    --gpu-memory-utilization 0.85 \
    --max-model-len 8192 \
    --served-model-name qwen3-coder

# tested
Status: Downloaded newer image for vllm/vllm-openai:latest
WARNING 05-15 09:06:22 [argparse_utils.py:257] With `vllm serve`, you should provide the model as a positional argument or in a config file instead of via the `--model` option. The `--model` option will be removed in a future version.
(APIServer pid=1) INFO 05-15 09:06:22 [utils.py:306] 
(APIServer pid=1) INFO 05-15 09:06:22 [utils.py:306]        █     █     █▄   ▄█
(APIServer pid=1) INFO 05-15 09:06:22 [utils.py:306]  ▄▄ ▄█ █     █     █ ▀▄▀ █  version 0.21.0
(APIServer pid=1) INFO 05-15 09:06:22 [utils.py:306]   █▄█▀ █     █     █     █  model   Qwen/Qwen2.5-Coder-32B-Instruct-AWQ
(APIServer pid=1) INFO 05-15 09:06:22 [utils.py:306]    ▀▀  ▀▀▀▀▀ ▀▀▀▀▀ ▀     ▀
(APIServer pid=1) INFO 05-15 09:06:22 [utils.py:306] 


r1vn@r1vn-MS-7E70:/mnt/vm-storage/backups$ sudo docker ps
CONTAINER ID   IMAGE                              COMMAND                  CREATED         STATUS          PORTS                                         NAMES
c8e1ccc6a550   vllm/vllm-openai:latest            "vllm serve --model …"   2 minutes ago   Up 2 minutes    0.0.0.0:8086->8086/tcp, [::]:8086->8086/tcp   nervous_pare
51433677d155   ai-platform-atlassian-mcp          "mcp-atlassian --tra…"   7 days ago      Up 28 minutes   0.0.0.0:8040->8040/tcp, [::]:8040->8040/tcp   aiplatform-atlassian-mcp
2cd26a605bd0   ai-platform-google-workspace-mcp   "workspace-mcp --tra…"   7 days ago      Up 28 minutes   0.0.0.0:8030->8030/tcp, [::]:8030->8030/tcp   aiplatform-google-workspace-mcp
