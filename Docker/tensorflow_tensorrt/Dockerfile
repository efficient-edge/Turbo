
# TensorRT 8.4 and new versions work
# https://docs.nvidia.com/deeplearning/tensorrt/container-release-notes/rel-22-10.html#rel-22-10
FROM nvcr.io/nvidia/tensorrt:22.08-py3

# Check NVIDIA Driver, CUDA, TensorRT
# requirements: Nvidia GPU (TensorRT 8)
# Nvidia Driver 465 with CUDA tooklit
# TensorRT >= 8.0.1
# TensorFlow >= 2.4.0
RUN nvidia-smi
RUN python3 -c 'import tensorrt; print("TensorRT version: {}".format(tensorrt.__version__))'
RUN dpkg -l | grep TensorRT

# Install pip
RUN apt-get update && apt-get install pip
RUN pip3 install --upgrade pip

# Install dependencies for EfficientDet
RUN ls -ltr ./tensorrt/samples/python/efficientdet
RUN pip3 install -r ./tensorrt/samples/python/efficientdet/requirements.txt

# Clone AutoML github repository
RUN git clone https://github.com/google/automl
# Install requirements for AutoML
RUN pip3 install matplotlib>=3.0.3 PyYAML>=5.1 tensorflow-model-optimization>=0.5
# Downgrade protobuf
# RUN pip3 uninstall protobuf
RUN pip3 install protobuf==3.19.0
# Install onnx_graphsurgeon
RUN pip3 install onnx
RUN pip3 install 'git+https://github.com/NVIDIA/TensorRT#subdirectory=tools/onnx-graphsurgeon'

# Download TensorFlow saved model
RUN [ ! -d "tf_checkpoint" ] && mkdir tf_checkpoint
RUN wget https://storage.googleapis.com/cloud-tpu-checkpoints/efficientdet/coco2/efficientdet-d0.tar.gz -P tf_checkpoint
RUN tar -xvf tf_checkpoint/efficientdet-d0.tar.gz -C tf_checkpoint
RUN ls tf_checkpoint/efficientdet-d0/

# Export a TensorFlow saved model
# Create a directory to store TensorFlow saved model 
RUN [ ! -d "tf_model" ] && mkdir tf_model
# Install absl
RUN pip3 install absl-py
# Install tensorflow-gpu
RUN pip3 install tensorflow-gpu
# Export TF model
RUN python3 ./automl/efficientdet/model_inspect.py \
    --runmode saved_model \
    --model_name efficientdet-d0 \
    --ckpt_path ./tf_checkpoint/efficientdet-d0/ \
    --saved_model_dir ./tf_model
RUN ls tf_model/

# Create ONNX Graph
# Create directory for onnx_model
RUN [ ! -d "onnx_model" ] && mkdir onnx_model
RUN python3 ./tensorrt/samples/python/efficientdet/create_onnx.py \
    --saved_model ./tf_model/ \
    --onnx ./onnx_model/model.onnx \
    --input_size '512, 512'
    # --input_shape '1,512,512,3'

# Build TensorRT engine
# Create directory for exported TensorRT engine
# RUN [ ! -d "trt_engine" ] && mkdir trt_engine
# Install pycuda
# RUN pip install pycuda
# Build engine with FP32 precision
# RUN python3 ./tensorrt/samples/python/efficientdet/build_engine.py \
    # --onnx ./onnx_model/model.onnx \
    # --engine ./trt_engine/engine.trt \
    # --precision fp32
# RUN ls trt_engine/

# Benchmarking TensorRT Engine


# ARG CUDA=11.3
# # ARG CUDA=10.2
# ARG PYTHON_VERSION=3.8
# ARG TORCH_VERSION=1.10.0
# ARG TORCHVISION_VERSION=0.11.0
# ARG ONNXRUNTIME_VERSION=1.8.1
# ARG MMCV_VERSION=1.5.3
# ARG PPLCV_VERSION=0.7.0
# ENV FORCE_CUDA="1"

# ENV DEBIAN_FRONTEND=noninteractive

# ### change the system source for installing libs
# ARG USE_SRC_INSIDE=false
# RUN if [ ${USE_SRC_INSIDE} == true ] ; \
#     then \
#         sed -i s/archive.ubuntu.com/mirrors.aliyun.com/g /etc/apt/sources.list ; \
#         sed -i s/security.ubuntu.com/mirrors.aliyun.com/g /etc/apt/sources.list ; \
#         echo "Use aliyun source for installing libs" ; \
#     else \
#         echo "Keep the download source unchanged" ; \
#     fi

# ### update apt and install libs
# RUN apt-get update &&\
#     apt-get install -y vim libsm6 libxext6 libxrender-dev libgl1-mesa-glx git wget libssl-dev libopencv-dev libspdlog-dev --no-install-recommends &&\
#     rm -rf /var/lib/apt/lists/*

# RUN curl -fsSL -v -o ~/miniconda.sh -O  https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh  && \
#     chmod +x ~/miniconda.sh && \
#     ~/miniconda.sh -b -p /opt/conda && \
#     rm ~/miniconda.sh && \
#     /opt/conda/bin/conda install -y python=${PYTHON_VERSION} conda-build pyyaml numpy ipython cython typing typing_extensions mkl mkl-include ninja && \
#     /opt/conda/bin/conda clean -ya

# ### pytorch
# # RUN /opt/conda/bin/conda install pytorch==${TORCH_VERSION} torchvision==${TORCHVISION_VERSION} cudatoolkit=${CUDA} -c pytorch
# # ENV PATH /opt/conda/bin:$PATH

# ### install mmcv-full
# # RUN /opt/conda/bin/pip install mmcv-full==${MMCV_VERSION} -f https://download.openmmlab.com/mmcv/dist/cu${CUDA//./}/torch${TORCH_VERSION}/index.html

# # WORKDIR /root/workspace/
# # ### Install MMDetection
# # RUN conda clean --all
# # RUN git clone https://github.com/open-mmlab/mmdetection.git /mmdetection
# # WORKDIR /mmdetection
# # ENV FORCE_CUDA="1"
# # RUN pip install --no-cache-dir -r requirements/build.txt
# # RUN pip install --no-cache-dir -e .
# # RUN pip install onnx
# # RUN pip install onnxsim
# # RUN pip install onnxruntime

# WORKDIR /root/workspace
# ### get onnxruntime
# RUN wget https://github.com/microsoft/onnxruntime/releases/download/v${ONNXRUNTIME_VERSION}/onnxruntime-linux-x64-${ONNXRUNTIME_VERSION}.tgz \
#     && tar -zxvf onnxruntime-linux-x64-${ONNXRUNTIME_VERSION}.tgz &&\
#     pip install onnxruntime-gpu==${ONNXRUNTIME_VERSION}

# ### cp trt from pip to conda
# RUN cp -r /usr/local/lib/python${PYTHON_VERSION}/dist-packages/tensorrt* /opt/conda/lib/python${PYTHON_VERSION}/site-packages/

# ### install tensorflow
# RUN /opt/conda/bin/conda install tensorflow-gpu
# ENV PATH /opt/conda/bin:$PATH

# WORKDIR /root/workspace
# ### install tensorrt requirements
# RUN git clone -b master https://github.com/nvidia/TensorRT TensorRT
# RUN cd TensorRT/samples/python/efficientdet && pip install -r requirements.txt
# RUN pip install onnx-graphsurgeon --index-url https://pypi.ngc.nvidia.com
# RUN cd /root/workspace
# RUN git clone https://github.com/google/automl
# RUN cd automl && git checkout 0b0ba5e
# RUN pip install matplotlib

# ### install mmdeploy
# # ENV ONNXRUNTIME_DIR=/root/workspace/onnxruntime-linux-x64-${ONNXRUNTIME_VERSION}
# # ENV TENSORRT_DIR=/workspace/tensorrt
# # ARG VERSION
# # RUN git clone https://github.com/open-mmlab/mmdeploy &&\
# #     cd mmdeploy &&\
# #     if [ -z ${VERSION} ] ; then echo "No MMDeploy version passed in, building on master" ; else git checkout tags/v${VERSION} -b tag_v${VERSION} ; fi &&\
# #     git submodule update --init --recursive &&\
# #     mkdir -p build &&\
# #     cd build &&\
# #     cmake -DMMDEPLOY_TARGET_BACKENDS="ort;trt" .. &&\
# #     make -j$(nproc) &&\
# #     cd .. &&\
# #     pip install -e .
# # ### tensorrt backend needs
# # RUN pip install pycuda
# # RUN pip install prettytable

# ### build sdk
# # RUN git clone https://github.com/openppl-public/ppl.cv.git &&\
# #     cd ppl.cv &&\
# #     git checkout tags/v${PPLCV_VERSION} -b v${PPLCV_VERSION} &&\
# #     ./build.sh cuda

# # ENV BACKUP_LD_LIBRARY_PATH=$LD_LIBRARY_PATH
# # ENV LD_LIBRARY_PATH=/usr/local/cuda/compat/lib.real/:$LD_LIBRARY_PATH

# # RUN cd /root/workspace/mmdeploy &&\
# #     rm -rf build/CM* build/cmake-install.cmake build/Makefile build/csrc &&\
# #     mkdir -p build && cd build &&\
# #     cmake .. \
# #         -DMMDEPLOY_BUILD_SDK=ON \
# #         -DMMDEPLOY_BUILD_EXAMPLES=ON \
# #         -DCMAKE_CXX_COMPILER=g++ \
# #         -Dpplcv_DIR=/root/workspace/ppl.cv/cuda-build/install/lib/cmake/ppl \
# #         -DTENSORRT_DIR=${TENSORRT_DIR} \
# #         -DONNXRUNTIME_DIR=${ONNXRUNTIME_DIR} \
# #         -DMMDEPLOY_BUILD_SDK_PYTHON_API=ON \
# #         -DMMDEPLOY_TARGET_DEVICES="cuda;cpu" \
# #         -DMMDEPLOY_TARGET_BACKENDS="ort;trt" \
# #         -DMMDEPLOY_CODEBASES=all &&\
# #     make -j$(nproc) && make install &&\
# #     export SPDLOG_LEVEL=warn &&\
# #     if [ -z ${VERSION} ] ; then echo "Built MMDeploy master for GPU devices successfully!" ; else echo "Built MMDeploy version v${VERSION} for GPU devices successfully!" ; fi

# # ENV LD_LIBRARY_PATH="/root/workspace/mmdeploy/build/lib:${BACKUP_LD_LIBRARY_PATH}"
