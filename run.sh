#!/bin/bash

#使用说明
usage(){
    echo "useage: sh run.sh [all|node] [up|down|restart]"
}

all_up(){
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