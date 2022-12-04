# Test Detectors (YOLOv3, Faster RCNN, Efficientdet-dx) on NVIDIA Triton Server
In Turbo, we deploy TensorRT models on Nvidia Triton because most operators of TensorRT are supported by Triton. Thus, we first convert pre-trained detectors to TensorRT format. For YOLOv3 and Faster RCNN, we use Pytorch pre-trained models from [mmdetection](https://mmdetection.readthedocs.io/). For Efficient-dx, we use official TensorFlow pre-trained models from [automl](https://github.com/google/automl).
## Contents
1. model conversion
   1. [Pytorch models (YOLOv3 and Faster RCNN)](#pytorch-models)
   2. [TensorFlow models (EfficientDet-Dx)](#tensorflow-models)
2. [model configuration](#model-configuration)
3. [triton server deployment](#triton-server-deployment)
4. [triton client applications](#triton-client-applications)
5. [visualization](#visualization)
## model conversion
### Pytorch models
### TensorFlow models
0. Build a docker image for conversing TensorFlow models.
   ```
   docker build --network host -t efficientdet $Turbo/Docker/tensorflow_tensorrt/
   ```
1. Convert a TensorFlow model to TensorRT format
   ```
   # Run the docker container in a interactive mode
   1. docker run -it --rm --net host -v $Turbo/Models/:/checkpoints efficientdet
   # Within the container
   2. pip uninstall pycuda
   3. pip install pycuda
   4. python3 ./tensorrt/samples/python/efficientdet/build_engine.py --onnx ./onnx_model/model.onnx --engine /checkpoints/engine.trt --precision fp32
   ```
2. Inspect the TensorRT model with _polygraphy_
   ```
   # Run the docker container in a interactive mode
   1. docker run -it --rm -v $Turbo/Models/:/checkpoints efficientdet
   # Within the container, print basic info (input, output, name, #layers) for tensorrt model
   2. polygraphy inspect model /checkpoints/engine.trt --model-type engine
   ```

<em>Note#1:</em>  Because we have downloaded a checkpoint of efficientdet-dx within the docker image, you do not need to download it again. In this example, we download efficient-d0. If you want to download other variants, you need to modify lines 36--38 and 58--61 of <em>$Turbo/Docker/tensorflow_tensorrt/Dockerfile</em>.

<em>Note#2:</em> Details (input size) of efficient-dx can be found in [EfficientDet-TensorRT8.ipynb](https://github.com/NVIDIA/TensorRT/blob/96e23978cd6e4a8fe869696d3d8ec2b47120629b/demo/EfficientDet/notebooks/EfficientDet-TensorRT8.ipynb).

## model configuration
0. Pull a docker image for Triton server
   ```
   docker pull nvcr.io/nvidia/tritonserver:<22.08>-py3
   ```
1. Pull a docker image for Triton client
   ```
   docker pull nvcr.io/nvidia/tritonserver:<22.08>-py3-sdk
   ```
2. Inspect TensorRT models and modify the config.pbtxt
   ```
   # For efficientdet-d0
   # YOLOv3 and Faster RCNN can refer to previous steps
   1. docker run -it --rm -v $Turbo/Models/:/checkpoints efficientdet
   2. polygraphy inspect model /checkpoints/engine.trt --model-type engine
   ```
![](https://github.com/efficient-edge/Turbo/blob/main/media/model_config1.png)

![](https://github.com/efficient-edge/Turbo/blob/main/media/config_sample.png)

3. (Optional) Download model_repository.tar.gz (~487MB) and decompress them in <em>$Turbo/Models</em>
   ```
   1. cd $Turbo/Models
   2. download https://drive.google.com/file/d/1o3V_QcShEwEVMlwWmw5qTVUpa3dDatEk/view?usp=sharing
   3. tar -xf model_repository.tar.gz
   ```
![](https://github.com/efficient-edge/Turbo/blob/main/media/model_config2.png)
## triton server deployment
```
1. Modify the argument $MODEL_PATH of triton_server.sh
2. bash triton_server.sh
```
![](https://github.com/efficient-edge/Turbo/blob/main/media/triton_server_success.png)
## triton client applications
```
# image client application
bash triton_client.sh image
# video client application
bash triton_client.sh video
```
## visualization