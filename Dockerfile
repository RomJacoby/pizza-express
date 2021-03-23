FROM node:8.4.0
WORKDIR /app
COPY . .
RUN apt-get update && apt-get install -y redis-server
RUN npm install; chmod +x /app/startup_script.sh
EXPOSE 3000
CMD ["/app/startup_script.sh"]
