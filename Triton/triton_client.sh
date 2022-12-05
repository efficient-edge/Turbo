# start a triton client application to send/receive a video
# In default, $SCRIPTS is the path to $Turbo/Scripts/
SCRIPTS=/home/jason/Toolbox/test_code/triton_client

docker run -it --rm -v $SCRIPTS:/python_scripts \
    --net host nvcr.io/nvidia/tritonserver:22.08-py3-sdk 