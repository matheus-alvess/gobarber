Sequelize commands:

Create Migration run:
`yarn sequelize migration:create --name create-files`

DOCKER RUN APP COMMAND:

docker build -t go-barber .

docker run \
 --net='host' \
 --name=go-barber \
 --log-opt max-size=10m \
 --log-opt max-file=5 \
 -p 3333:3333 \
 -d \
 --restart=unless-stopped go-barber
