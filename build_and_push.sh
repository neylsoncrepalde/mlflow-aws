echo "We need those environment variables:"
echo "IMAGE, AWS_ACCESS, AWS_SECRET, DB_PASS, BUCKET_NAME and DB_ENDPOINT"

docker build -t $IMAGE:latest . --build-arg AWS_ACCESS=${AWS_ACCESS} --build-arg AWS_SECRET=${AWS_SECRET} --build-arg DB_PWD=${DB_PASS}

echo "Image ${IMAGE}:latest built. Let's push it to ECR"

eval $(aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com)

# tag and push image using latest
docker tag $IMAGE $AWS_ACCOUNT.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$IMAGE:latest
docker push $AWS_ACCOUNT.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$IMAGE:latest
