# start a triton server in docker mode with all deployed tensorrt detectors
# In default, MODEL_PATH=$Turbo/Models/
MODEL_PATH=/home/jason/Toolbox/e2e-detection/temp/model_repository/

# start triton server
docker run --rm --gpus all -v $MODEL_PATH:/models \
    -e LD_PRELOAD=/models/libmmdeploy_tensorrt_ops.so \
    nvcr.io/nvidia/tritonserver:22.08-py3 tritonserver --model-repository=/models/
