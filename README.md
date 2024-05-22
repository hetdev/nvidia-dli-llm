# nvidia-dli-llm

Nvidia project lab for Building Transformer-Based Natural Language Processing

## Setup

Install Nvidia container toolkit: https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html

Authenticate your docker: https://org.ngc.nvidia.com/setup/api-key


#### NEMO DLI
Docker image [Nemo DLI](https://catalog.ngc.nvidia.com/orgs/nvidia/teams/dli/containers/dli-nlp-nemo)
```commandline
docker run --runtime=nvidia -d -v $PWD:/dli/task --shm-size=16g -p 8888:8888 -p 8889:8889 -p 6006:6006 --ulimit memlock=-1 --ulimit stack=67108864 nvcr.io/nvidia/dli/dli-nlp-nemo:v3-nemo1.0.1

#for part3

docker run --runtime=nvidia -d -v $PWD:/dli/task --shm-size=16g --net=host --ulimit memlock=-1 --ulimit stack=67108864 nvcr.io/nvidia/dli/dli-nlp-nemo:v3-nemo1.0.1
```

Go to the container shell:
```commandline
docker exec -it {dli-nlp-nemo-container-name} sh

Example:
docker exec -it focused_bell sh
```
Install bertviz
```commandline
pip install bertviz
```


#### Triton Server (Part3)
Docker image [Triton server ](https://github.com/triton-inference-server/server)

Apply step 2 and 3 ([Serve a Model in 3 Easy Steps](https://github.com/triton-inference-server/server?tab=readme-ov-file#serve-a-model-in-3-easy-steps))

https://docs.nvidia.com/deeplearning/triton-inference-server/user-guide/docs/getting_started/quickstart.html



# Known issues