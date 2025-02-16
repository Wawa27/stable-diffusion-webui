FROM nvidia/cuda:12.2.0-runtime-ubuntu20.04

ARG APP_PATH=/app

ARG DEBIAN_FRONTEND=noninteractive
USER root
RUN apt-get update -yq
RUN apt-get upgrade -yq
RUN apt-get install -yq git python3-pip libgl1 libglib2.0-0
RUN mkdir -p /.local /.config
RUN chown -R 1001:1001 /.local /.config

# Workaround for RealESRGAN writing somewhere it shouldn't
RUN mkdir -p /usr/local/lib/python3.8/dist-packages/weights
RUN chown -R 1001:1001 /usr/local/lib/python3.8/dist-packages/weights

RUN pip install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu113

COPY --chown=1001:1001 ./ $APP_PATH
WORKDIR $APP_PATH

RUN pip install -r requirements.txt
USER 1001

RUN COMMANDLINE_ARGS="--skip-torch-cuda-test" python3 -c "import launch"

ENTRYPOINT [ "python3", "webui.py", "--listen" ]

