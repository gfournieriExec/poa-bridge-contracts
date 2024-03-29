FROM node:10

RUN apt-get update
RUN apt-get install -y netcat
RUN git config --global url.https://github.com/.insteadOf git://github.com/

RUN apt-get clean

WORKDIR /contracts

COPY package.json .
COPY package-lock.json .
RUN npm install

COPY ./deploy/package.json ./deploy/
COPY ./deploy/package-lock.json ./deploy/
RUN cd ./deploy; npm install; cd ..

COPY . .
RUN mkdir  ./deploy/output
RUN npm run compile
RUN bash flatten.sh

ENV PATH="/contracts/:${PATH}"
