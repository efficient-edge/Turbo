# Turbo: Opportunistic Enhancement for Edge Video Analytics
### [Project Page](https://sites.google.com/view/turbo-video/home) | [Paper](https://jason-cs18.github.io/assets/paper/sensys22turbo.pdf) | [Slides](https://jason-cs18.github.io/assets/slides/Turbo_SenSys_Presentation.pdf)
![overview](./media/overview.png)

This repository contains the official implementation of the SenSys'22 paper:  
**Turbo: Opportunistic Enhancement for Edge Video Analytics**.  
[Yan Lu](https://jason-cs18.github.io/), [Shiqi Jiang](https://www.microsoft.com/en-us/research/people/shijiang/), [Ting Cao](https://www.microsoft.com/en-us/research/people/ticao/), [Yuanchao Shu](https://www.microsoft.com/en-us/research/people/yushu/publications/).  
The paper introduces **Turbo** which selectively enhances incoming frames based GPU resource availability via a detector-specific GAN and a resource-aware scheduling algorithm.

Source code and docs for Turbo

## Installation
We provide some dockerfiles for NVIDIA GPU users to complete different tasks (training, testing, deployment and visualization). Thus, users do not need to install any libraries and only build the specific docker image for a component.
## Source code
- [ ] Trion: convert detectors to TensorRT models and deploy them on Triton
- [ ] VAP: use advanced video analytics pipelines as data preprocessing techniques
- [ ] Scheduling: enable resource-aware scheduling algorithms on Triton with a specific video analytics pipeline
- [ ] GAN: train and evaluate the enhancer on pre-trained data
- [ ] E2E: run enhancers with a specific video analytics pipeline and elastic scheduling algorithm on Triton
## Documentations
1. [Test Detectors (yolov3, faster-rcnn, efficientdet-dx) on Triton](https://github.com/efficient-edge/Turbo/tree/main/Triton)
2. [Integrate with Video Analytics Pipelines](https://github.com/efficient-edge/Turbo/tree/main/VAP)
3. [Enable Resource-Aware Scheduling](https://github.com/efficient-edge/Turbo/tree/main/Scheduling)
4. [GAN (enhancer) Pre-Training](https://github.com/efficient-edge/Turbo/tree/main/GAN)
5. [End2end Experiments](https://github.com/efficient-edge/Turbo/tree/main/E2E)
## Demo
TBD
## Reference
1. [Open-MMLab mmdeploy](https://github.com/open-mmlab/mmdeploy): convert detectors (yolov3 and fasterrcnn) to TensorRT models.
2. [TensorRT Efficient-TensorRT8](https://github.com/NVIDIA/TensorRT/blob/96e23978cd6e4a8fe869696d3d8ec2b47120629b/demo/EfficientDet/notebooks/EfficientDet-TensorRT8.ipynb): convert detectors (efficientdet-dx) to TensorRT models.
3. [Nvidia Triton](https://github.com/triton-inference-server/server): build and deploy detectors on Triton server. 
## Citing Turbo
If you find this project is useful to your research, please consider cite it.
```
@inproceedings{lu22sensys, 
  author={Lu, Yan and Jiang, Shiqi and Cao, Ting and Shu, Yuanchao}, 
  booktitle={ACM Conference on Embedded Network Sensor Systems (SenSys)}, 
  title={{Turbo: Opportunistic Enhancement for Edge Video Analytics}}, 
  year={2022},
}
```