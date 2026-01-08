# ComfyUI Video Generalist

![Docker Build](https://github.com/lum3on/ComfyUI-Video-Generalist/actions/workflows/docker-build.yml/badge.svg)

RunPod template for video generation with ComfyUI, WAN 2.2, LTX-2, and more.

## Quick Start

**Image:** `ghcr.io/lum3on/comfyui-video-generalist:latest`

| Port | Service |
|------|---------|
| 8188 | ComfyUI |
| 8189 | JupyterLab |

## Environment Variables

| Variable | Required | Description |
|----------|----------|-------------|
| `HF_TOKEN` | **Yes** | Hugging Face token |
| `DOWNLOAD_ALL` | No | Download all models (default: true) |
| `DOWNLOAD_WAN_CORE` | No | WAN 2.2 models (~60GB) |
| `DOWNLOAD_VACE` | No | VACE modules (~30GB) |
| `DOWNLOAD_LIGHTX` | No | LTX-2 models (~50GB) |
| `DOWNLOAD_CLIP` | No | CLIP/VAE (~12GB) |
| `DOWNLOAD_LORAS` | No | LoRAs (~3GB) |
| `DOWNLOAD_UPSCALE` | No | Upscale models (~5GB) |
| `GPU_TYPE` | No | auto, H100, H200, 4090, 5090 |

**Tip:** Set `DOWNLOAD_ALL=false` then enable specific models to save space.

## Features

- CUDA 12.8 + PyTorch 2.7+
- ComfyUI + Manager
- WAN 2.2 Video Wrapper
- LTX-2 Support
- SageAttention
- JupyterLab

## Links

- [GitHub](https://github.com/lum3on/ComfyUI-Video-Generalist)
- [Models](https://huggingface.co/Kijai/WanVideo_comfy)
- [WAN Video Wrapper](https://github.com/kijai/ComfyUI-WanVideoWrapper)
