#!/bin/bash

#使用说明
usage(){
    echo "useage: sh run.sh [all|node] [up|down|restart]"
    
}

check_monitor_precondition(){
    docker network ls|grep -q "dev_monitoring"
    if [ $? != 0 ] ;then
    echo "create network: dev_monitoring."
        docker network create dev_monitoring
    fi

    docker volume ls|grep -q "grafana_data"
    if [ $? != 0 ] ;then
    echo "create volume: grafana_data."
        docker volume create grafana_data
    fi

    docker volume ls|grep -q "prometheus_data"
    if [ $? != 0 ] ;then
    echo "create volume: prometheus_data."
        docker volume create prometheus_data
    fi
}

check_springcloud_precondition(){
    docker network ls|grep -q "dev_springcloud"
    if [ $? != 0 ] ;then
        echo "create network: dev_springcloud."
        docker network create dev_springcloud
    fi

    docker volume ls|grep -q "pgsql_data"
    if [ $? != 0 ] ;then
    echo "create volume: pgsql_data."
        docker volume create pgsql_data
    fi

    docker volume ls|grep -q "pgadmin_data"
    if [ $? != 0 ] ;then
    echo "create volume: pgadmin_data."
        docker volume create pgadmin_data
    fi
}

all_up(){
    check_monitor_precondition
    check_springcloud_precondition
    docker compose -f all_in_one.yml -p "all-in-one" up -d
}

all_down(){
    docker compose -f all_in_one.yml -p "all-in-one" down
}

node_up(){
    check_monitor_network
    docker compose -f node_exporter.yml -p "node-exporter" up -d
}

node_down(){
    docker compose -f node_exporter.yml -p "node-exporter" down
}

ali_up(){
    check_springcloud_precondition
    docker compose -f nacos-seata.yaml -p "spring-cloud-alibaba" up -d
}

ali_down(){
    docker compose -f nacos-seata.yaml -p "spring-cloud-alibaba" down
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

ali(){
   case "$1" in
    "up"|"restart")
        ali_up
    ;;
    "down")
        ali_down
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
"ali")
    ali $2
;;
"node")
    node $2
;;
*)
	usage
;;
esac