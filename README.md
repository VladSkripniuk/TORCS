# **TORCS 1.3.7**
Dockerfile to create image with [TORCS 1.3.7](https://github.com/fmirus/torcs-1.3.7) with SCR patch and an additional patch to send the current game image to python application.

## Installation

[Download](http://www.nvidia.com/Download/index.aspx) NVIDIA driver (if you already have one, download the same version, it will be installed inside Docker)

```wget http://us.download.nvidia.com/XFree86/Linux-x86_64/375.66/NVIDIA-Linux-x86_64-375.66.run```

Build Docker image (that takes approximately 1 hour)

```./build.sh```

## Usage

Launch container with created image

```sudo ./run.sh```

In container use ```tmux``` to create multiple windows (```Ctrl-B %``` or ```Ctrl-B "``` to create multiple panes)

Run TORCS game server

```torcs```

Run screen sharing (initially paused, press ```P``` in window Image from TORCS to unpause)

```./torcs-1.3.7/screenpipe/IPC_command```

Run python client

```python client.py```