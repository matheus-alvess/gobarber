#!/bin/bash
appname="go-barber"
host=""

echo $1 $2

run() {
    echo "docker run \
        $env \
        $cond \
        --name=$appname \
        -p 3333:3333 \
        --log-opt max-size=50m --log-opt max-file=5 \
        -d \
        --restart=unless-stopped $appname"
}

if [ $1 == "local" ]
  then

    env="-e ENV_PROD=0"
    cond="--net='host'"

    if [ $2 == "deploy" ]
      then
        docker build -t $appname .
        docker stop $appname
        docker rm $appname
        eval $(run)
    fi

    if [ $2 == "stop" ]
      then
        docker stop $appname
    fi

    if [ $2 == "exec" ]
      then
        docker exec -it $appname $3
    fi

    if [ $2 == "start" ]
      then
        docker start $appname
    fi

    if [ $2 == "logs" ]
      then
        docker logs -f $appname
    fi
fi

if [ $1 == "remote" ]
  then
    env="-e ENV_PROD=1"
    cond="--net='host'"

    if [ $2 == "deploy" ]
      then
        ssh -tt $host "mkdir -p $appname && cd $appname && sudo chmod 777 * -R"
        rsync --progress --exclude-from '.deployignore' -avz -e "ssh" . $host:$appname
        ssh -tt $host "cd $appname && docker build -t $appname ."
        ssh -tt $host "cd $appname && docker stop $appname"
        ssh -tt $host "cd $appname && docker rm $appname"
        ssh -tt $host "cd $appname && $(run)"
    fi

    if [ $2 == "stop" ]
      then
        ssh -tt $host "docker stop $appname"
    fi

    if [ $2 == "exec" ]
      then
        ssh -tt $host "docker exec -it $appname $3"
    fi

    if [ $2 == "start" ]
      then
        ssh -tt $host "cd $appname && docker start $appname"
    fi


    if [ $2 == "restart" ]
      then
        ssh -tt $host "cd $appname && docker restart $appname"
    fi

    if [ $2 == "logs" ]
      then
        ssh -tt $host "docker logs -f --tail 1 $appname"
    fi

    if [ $2 == "full-logs" ]
      then
        ssh -tt $host "docker logs -f $appname"
    fi

    if [ $2 == "env" ]
      then
        ssh -tt $host "docker exec -it $appname cat .env"
    fi
fi
