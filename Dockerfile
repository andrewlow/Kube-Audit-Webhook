FROM node:alpine

WORKDIR /app
COPY app.js /app

CMD node app.js
