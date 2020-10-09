echo "We need those environment variables:"
echo "IMAGE, AWS_ACCESS, AWS_SECRET, DB_PASS, BUCKET_NAME and DB_ENDPOINT"

docker build -t $IMAGE:latest . --build-arg AWS_ACCESS=${AWS_ACCESS} --build-arg AWS_SECRET=${AWS_SECRET} --build-arg DB_PWD=${DB_PASS}

echo "Image ${IMAGE}:latest built. Let's run it"

docker run -d -p 5000:5000 \
    -e BUCKET_NAME=$BUCKET_NAME \
    -e DB_ENDPOINT=$DB_ENDPOINT \
    $IMAGE:latest