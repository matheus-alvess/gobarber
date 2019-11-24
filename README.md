Sequelize commands:

Create Migration run:
`yarn sequelize migration:create --name create-files`

DOCKER RUN APP COMMAND:

docker build -t sucrase-app .

docker run \
 --net='host' \
 --name=sucrase-app \
 --log-opt max-size=10m \
 --log-opt max-file=5 \
 -p 3333:3333 \
 -d \
 --restart=unless-stopped sucrase-app
