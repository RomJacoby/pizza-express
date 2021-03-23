echo "Building test image.."
docker build -q -t test_image -f Dockerfile.test . 
docker run --rm --name test_container -v /root/bigid/pizza-express/exit_code:/app/exit_code test_image
if grep -q 0 exit_code; then
  echo -e "\nAll tests completed successfully! Building main image...\n"
  docker build -q -t main_image .
  echo -e "\nRunning docker image and checking it's service status code\n"
  docker run --rm --name main_container -d -p 8081:3000 main_image
  sleep 5
  EXIT_CODE=`curl -o /dev/null -s -w "%{http_code}\n" localhost:8081`
  if [ "$EXIT_CODE" = 200 ]; then
    echo -e "\nGET request exit code is 200 :). Pushing image to dockerhub\n"
    docker tag main_image romjacoby/main_image
    cat my_password | docker login --username romjacoby --password-stdin
    docker push --quiet romjacoby/main_image && echo "Image was pushed successfully!"
  else
    echo -e "\nGET request exit code is not 200 :(. Aborting..\n"
  fi
else
  echo -e "\nSome tests have failed. Aborting..\n"
fi
echo -e "\nCleaning up..\n"
docker rm -f main_container
