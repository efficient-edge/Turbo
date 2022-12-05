# start a triton client application to send/receive a video
# In default, $SCRIPTS is the path to $Turbo/Scripts/
# $DATA is the path to test images or videos
SCRIPTS=/home/jason/Toolbox/test_code/triton_client
DATA=/home/jason/Toolbox/test_data

docker run -it --rm -v $SCRIPTS:/python_scripts \
    -v $DATA:/testdata --net host \
    nvcr.io/nvidia/tritonserver:22.08-py3-sdk 