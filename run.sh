#!/bin/bash

#使用说明
usage(){
    echo "useage: sh run.sh [all|node] [up|down|restart]"
    
}

check_network(){
    docker network ls|grep -q "dev_monitoring"
    if [ $? != 0 ] ;then
    echo "create network: dev_monitoring."
        docker network create dev_monitoring
    fi

    docker network ls|grep -q "dev_springcloud"
    if [ $? != 0 ] ;then
        echo "create network: dev_springcloud."
        docker network create dev_springcloud
    fi
}

all_up(){
    check_network
    docker compose -f all_in_one.yml up -d
}

all_down(){
    docker compose -f all_in_one.yml down
}

node_up(){
    docker compose -f node_exporter.yml up -d
}

node_down(){
    docker compose -f node_exporter.yml down
}

all(){
    case "$1" in
    "up"|"restart")
        all_up
    ;;
    "down")
        all_down
    ;;
    esac
}

node(){
    case "$1" in
    "up"|"restart")
        node_up
    ;;
    "down")
        node_down
    ;;
    esac
}

case "$1" in
"all")
    all $2
;;
"node")
    node $2
;;
*)
	usage
;;
esac