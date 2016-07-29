# docker-node
Docker image to run Node.js

## Requirements

* Docker (1.6.0 minimum)

## Description

This Docker image is based on:

* Alpine 3.4
* Node.js 6.3.1

## Usage

To build this Node.js image run the following command:

```
docker build -t jplu/node .
```

Once you have built your image you can use it as a Node.js executable:

```
docker run -it --rm -v "$PWD":/my-app -w /my-app jplu/node node run production
```

Or use it as a base image to run a Node.js app:

```
FROM jplu/node
COPY . /my-app/
WORKDIR /my-app
RUN npm install --production
EXPOSE 3333
CMD [ "npm", "run", "prod" ]
```

And run it with:

```
docker build -t node-test .
docker run -it --rm node-test
```

