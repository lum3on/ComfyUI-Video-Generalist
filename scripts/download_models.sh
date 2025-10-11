#!/bin/bash
set -e

echo "========================================="
echo "WAN 2.2 Model Downloader"
echo "========================================="

# Model storage directory (use RunPod's persistent /workspace if available)
if [ -d "/workspace" ]; then
    MODEL_DIR="/workspace/models"
    echo "✅ Using RunPod persistent storage: /workspace/models"
else
    MODEL_DIR="/comfyui/models"
    echo "⚠️  Using container storage: /comfyui/models"
fi

# Create model directories
mkdir -p \
    "$MODEL_DIR/text_encoders" \
    "$MODEL_DIR/diffusion_models" \
    "$MODEL_DIR/vae" \
    "$MODEL_DIR/loras" \
    "$MODEL_DIR/upscale_models"

# Symlink to ComfyUI models directory if using /workspace
if [ "$MODEL_DIR" != "/comfyui/models" ]; then
    echo "Creating symlinks to ComfyUI models directory..."
    rm -rf /comfyui/models
    ln -sf "$MODEL_DIR" /comfyui/models
fi

# Function to download model if it doesn't exist
download_model() {
    local url=$1
    local output=$2
    local name=$(basename "$output")

    if [ -f "$output" ]; then
        echo "✅ $name already exists, skipping..."
    else
        echo "📥 Downloading $name..."

        # Try aria2c first (faster with multi-connection downloads)
        if command -v aria2c &> /dev/null; then
            echo "   Using aria2c (multi-connection download)..."
            aria2c \
                --console-log-level=warn \
                --summary-interval=5 \
                --max-connection-per-server=16 \
                --split=16 \
                --min-split-size=1M \
                --max-concurrent-downloads=1 \
                --continue=true \
                --allow-overwrite=true \
                --auto-file-renaming=false \
                --out="$output" \
                "$url" || {
                    echo "   ⚠️  aria2c failed, falling back to wget..."
                    wget --progress=dot:giga --show-progress -O "$output" "$url"
                }
        else
            # Fallback to wget with improved progress display
            echo "   Using wget (single-connection download)..."
            wget --progress=dot:giga --show-progress -O "$output" "$url"
        fi

        echo "✅ Downloaded $name"
    fi
}

echo ""
echo "========================================="
echo "Downloading WAN 2.2 Models (~25GB)"
echo "========================================="
echo ""
echo "Download method: $(command -v aria2c &> /dev/null && echo 'aria2c (fast, multi-connection)' || echo 'wget (standard)')"
echo ""

# Diffusion Models (14B fp16 models - ~27GB each)
echo "📦 Diffusion Models (High Noise)..."
download_model \
    "https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/diffusion_models/wan2.2_t2v_high_noise_14B_fp16.safetensors" \
    "$MODEL_DIR/diffusion_models/wan2.2_t2v_high_noise_14B_fp16.safetensors"

echo "📦 Diffusion Models (Low Noise)..."
download_model \
    "https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/diffusion_models/wan2.2_t2v_low_noise_14B_fp16.safetensors" \
    "$MODEL_DIR/diffusion_models/wan2.2_t2v_low_noise_14B_fp16.safetensors"

# Text Encoders (UMT5 models)
echo "📦 Text Encoders (UMT5 FP16)..."
download_model \
    "https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/text_encoders/umt5_xxl_fp16.safetensors" \
    "$MODEL_DIR/text_encoders/umt5_xxl_fp16.safetensors"

echo "📦 Text Encoders (UMT5 FP8)..."
download_model \
    "https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/text_encoders/umt5_xxl_fp8_e4m3fn_scaled.safetensors" \
    "$MODEL_DIR/text_encoders/umt5_xxl_fp8_e4m3fn_scaled.safetensors"

# VAE
echo "📦 VAE..."
download_model \
    "https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/vae/wan_2.1_vae.safetensors" \
    "$MODEL_DIR/vae/wan_2.1_vae.safetensors"

# LoRAs
echo "📦 LoRAs (Instareal High)..."
download_model \
    "https://huggingface.co/yo9otatara/model/resolve/main/Instareal_high.safetensors" \
    "$MODEL_DIR/loras/Instareal_high.safetensors"

echo "📦 LoRAs (Instareal Low)..."
download_model \
    "https://huggingface.co/yo9otatara/model/resolve/main/Instareal_low.safetensors" \
    "$MODEL_DIR/loras/Instareal_low.safetensors"

echo "📦 LoRAs (Lightx2v)..."
download_model \
    "https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/Lightx2v/lightx2v_T2V_14B_cfg_step_distill_v2_lora_rank256_bf16.safetensors" \
    "$MODEL_DIR/loras/lightx2v_T2V_14B_cfg_step_distill_v2_lora_rank256_bf16.safetensors"

# Upscale Models
echo "📦 Upscale Models (4xNomosUniDAT)..."
download_model \
    "https://huggingface.co/yo9otatara/model/resolve/main/4xNomosUniDAT_otf.pth" \
    "$MODEL_DIR/upscale_models/4xNomosUniDAT_otf.pth"

echo "📦 Upscale Models (4x-ClearRealityV1)..."
download_model \
    "https://huggingface.co/yo9otatara/model/resolve/main/4x-ClearRealityV1.pth" \
    "$MODEL_DIR/upscale_models/4x-ClearRealityV1.pth"

echo "📦 Upscale Models (1xSkinContrast)..."
download_model \
    "https://huggingface.co/yo9otatara/model/resolve/main/1xSkinContrast-High-SuperUltraCompact.pth" \
    "$MODEL_DIR/upscale_models/1xSkinContrast-High-SuperUltraCompact.pth"

echo "📦 Upscale Models (1xDeJPG)..."
download_model \
    "https://huggingface.co/yo9otatara/model/resolve/main/1xDeJPG_realplksr_otf.safetensors" \
    "$MODEL_DIR/upscale_models/1xDeJPG_realplksr_otf.safetensors"

echo "📦 Upscale Models (4x-UltraSharpV2)..."
download_model \
    "https://huggingface.co/yo9otatara/model/resolve/main/4x-UltraSharpV2_Lite.pth" \
    "$MODEL_DIR/upscale_models/4x-UltraSharpV2_Lite.pth"

echo ""
echo "========================================="
echo "✅ All models downloaded successfully!"
echo "========================================="
echo ""
echo "Model directory: $MODEL_DIR"
echo "Total models: $(find "$MODEL_DIR" -type f | wc -l)"
echo ""

