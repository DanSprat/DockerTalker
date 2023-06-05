
FROM python:3.8.16-bullseye
ARG DEBIAN_FRONTEND=noninteractive

# Установка драйверов NVIDIA
RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

RUN curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | apt-key add -
RUN distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
    && curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | tee /etc/apt/sources.list.d/nvidia-docker.list

RUN apt-get update && apt-get install -y --no-install-recommends \
    nvidia-docker2 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    software-properties-common \
    wget \
    git \
    build-essential \
    libgl1 \
    libssl-dev \
    libffi-dev \
    libxml2-dev \
    libxslt1-dev \
    zlib1g-dev \
    libjpeg-dev \
    libpng-dev \
    unzip \
    ffmpeg

# Set the working directory
WORKDIR /app

# # Clone the SadTalker repository
# RUN git clone https://github.com/Winfredy/SadTalker.git

# Change the working directory to SadTalker
WORKDIR /app/SadTalker

ADD . .

# Install PyTorch with CUDA 11.3 support
RUN pip install torch==1.12.1+cu113 torchvision==0.13.1+cu113 torchaudio==0.12.1 --extra-index-url https://download.pytorch.org/whl/cu113

# Install dlib
RUN pip install dlib-bin

# Install GFPGAN
RUN pip install git+https://github.com/TencentARC/GFPGAN

# Install dependencies from requirements.txt
RUN pip install -r requirements.txt

# Download models using the provided script
RUN chmod +x scripts/download_models.sh && scripts/download_models.sh

# Custom cache invalidation
ARG CACHEBUST=1

ENTRYPOINT ["python3", "inference.py"]