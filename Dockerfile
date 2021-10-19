FROM mhart/alpine-node:16.4.2

WORKDIR /usr/app
COPY . ./

RUN yarn
RUN yarn build
EXPOSE 3333

CMD ["yarn", "run", "start"]
