FROM mhart/alpine-node:12.22.1

WORKDIR /usr/app
COPY . ./

RUN yarn
RUN yarn build
EXPOSE 3333

CMD ["yarn", "run", "start"]
