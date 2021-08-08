.RECIPEPREFIX = >
IMAGE_NAME = 239318528382.dkr.ecr.us-west-1.amazonaws.com/speech2text-lambda

build:
> docker build -t ${IMAGE_NAME} .

push: build
> docker push ${IMAGE_NAME}:latest