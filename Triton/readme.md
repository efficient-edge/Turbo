# Test Detectors (YOLOv3, Faster RCNN, Efficientdet-dx) on NVIDIA Triton Server
In Turbo, we use Pytorch pre-trained models for YOLOv3 and Faster RCNN. For Efficientdet-dx, we start from the pre-trained models of official TensorFlow implementation. Thus, we will show you two approaches to converting pre-trained models to TensorRT models.
## Contents
1. model conversion
   1. [Pytorch models](#pytorch-models)
   2. [TensorFlow models](#tensorflow-models)
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
   # In the container
   2. pip uninstall pycuda
   3. pip install pycuda
   4. python3 ./tensorrt/samples/python/efficientdet/build_engine.py --onnx ./onnx_model/model.onnx --engine /checkpoints/engine.trt --precision fp32
   ```
2. XXX
   
<em>Note: Because we have downloaded a checkpoint of efficientdet-dx in the docker image, you do not need to download again. In this example, we download efficient-d0. If you want to download other variants, you need to modify lines 36--38 of $Turbo/Docker/tensorflow_tensorrt/Dockerfile.</em> 
## model configuration
## triton server deployment
## triton client applications
## visualization