#!/bin/bash
set -e

echo "Starting entrypoint script..."

# Run ROCm SMI
rocm-smi

# Print environment variables
echo "Environment variables:"
env

# Show current directory and contents
echo "Current directory:"
pwd
echo "Directory contents:"
ls -la


# Attempt to launch Stable Diffusion WebUI
echo "Launching Stable Diffusion WebUI..."
python launch.py $COMMANDLINE_ARGS || {
    echo "Launch failed. Exit code: $?"
    if [ -f /sdtemp/webui.log ]; then
        echo "Contents of webui.log:"
        cat /sdtemp/webui.log
    else
        echo "webui.log not found"
    fi
    exit 1
}
python -c "import torch; print(f'PyTorch version: {torch.__version__}'); print(f'CUDA available: {torch.cuda.is_available()}'); print(f'ROCm available: {torch.version.hip if hasattr(torch.version, \"hip\") else \"N/A\"}'); print(f'Current device: {torch.cuda.current_device() if torch.cuda.is_available() else \"CPU\"}');"


# Keep the container running
tail -f /dev/null