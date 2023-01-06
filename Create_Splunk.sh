#!/bin/bash

# Variable Assignments
#=====================
d_script_path=/opt/containerd/docker-playbooks
ip=$(curl -s http://checkip.amazonaws.com)

# Standalone Menu
#================
fn_Standalone() {
        clear -x
        echo " "
        echo "Choose Splunk Instance - (This will create a single instance only)"
        echo "=================================================================="
        echo " 1) Indexer             : enter 1"
        echo " 2) Search Head         : enter 2"
        echo " 3) Heavy Forwarder     : enter 3"
        echo " 4) Deployment Server   : enter 4"
        echo " 5) Deployer            : enter 5"
        echo " 6) Universal Forwarder : enter 6"
        echo " "
        echo "To Exit - enter 0"
        echo " "

        local chooseSA
        read -p "Enter choice [1-6] : " chooseSA
        case $chooseSA in
                1) fn_SA $chooseSA ;;
                2) fn_SA $chooseSA ;;
                3) fn_SA $chooseSA ;;
                4) fn_SA $chooseSA ;;
                5) fn_SA $chooseSA ;;
                6) fn_UF ;;
                0) fn_exit ;;
        esac
}

# Build Single Splunk Instance
#=============================
fn_SA() {
        case "$chooseSA" in
                1) instance="Indexer" ;;
                2) instance="SearchHead" ;;
                3) instance="HeavyForwarder" ;;
                4) instance="DeploymentServer" ;;
                5) instance="Deployer" ;;
        esac

        echo " "
        echo "Starting to create $instance"
        echo " "
        echo "*** Password must be atleast 8 characters ***"
        read -s -p "Enter Splunk admin password: " passwd
        echo " "
        SPLUNK_PASSWORD=$passwd docker compose -p $instance -f $d_script_path/docker-compose_sa.yml up --build -d
        echo " "
        echo "$instance created"
        echo " "
        echo "Access the Web Interface using http://$ip:8000"
        echo " "
        echo "Container Details"
        echo "================="
        echo " "
        docker ps
        echo " "
        fn_exit
}

# Build Single UF Instance
#=========================
fn_UF() {
        echo " "
        echo "Starting to create single instance Universal Forwarder"
        echo " "
        echo "*** Password must be atleast 8 characters ***"
        read -s -p "Enter Splunk admin password: " passwd
        echo " "
        SPLUNK_PASSWORD=$passwd docker compose -f $d_script_path/docker-compose_uf.yml up --build -d
        echo " "
        fn_processbar
        echo " "
        echo "single instance Universal Forwarder created"
        echo " "
        echo "Container Details"
        echo "================="
        echo " "
        docker ps
        echo " "
        fn_exit
}

# Clustered Menu
#===============
fn_Clustered() {
        clear -x
        echo " "
        echo "Choose type of Clustered environment"
        echo "===================================="
        echo " 1) Cluster 1 (1 CM, 3 IDX's, 3 SH's, 1 DS, 1 Dep, 1 HWF) : enter 1"
        echo " 2) Cluster 2 (1 IDX, 1 SH, 1 HWF)                        : enter 2"
        echo " 3) Cluster 3 (1 IDX, 1 SH)                               : enter 3"
        echo " "
        echo "To Exit - enter 0"
        echo " "

        local chooseSI
        read -p "Enter choice [1-3] : " chooseSI
        case $chooseSI in
                1) fn_C1 ;;
                2) fn_C2 ;;
                3) fn_C3 ;;
                0) fn_exit ;;
        esac
}

# Build Clustered Instances
#==========================
fn_C1() {
        echo " "
        echo "*** Password must be atleast 8 characters ***"
        read -s -p "Enter Splunk admin password: " passwd
        echo " "
        echo "Creating Splunk Clustered Environment"
        echo " "
        echo "Creating ... 1-Cluster Master, 3-Indexers, 3-Search Heads, 1-Heavy Forwarder, 1-Deployment Server, 1-Deployer"
        echo " "
        SPLUNK_PASSWORD=$passwd docker compose -f $d_script_path/docker-compose_c1.yml up --build -d
        echo " "
        fn_processbar
        echo " "
        echo "Container Details"
        echo "================="
        echo " "
        docker ps
        echo " "
        fn_exit
}

# ProcessBar
#===========
fn_processbar() {
        i=1
        sp="/-\|"
        echo -n ' '
        while true
                do
                        printf "\b${sp:i++%${#sp}:1}"
                        break
                done
}

# ExitFunction
#=============
fn_exit() {
        echo " "
        exit 1
}

# Initial Menu Display
#=====================
showMenu() {
        clear -x
        echo " "
        echo "Choose Splunk environment"
        echo "========================="
        echo " 1) Standalone : enter 1"
        echo " 2) Clustered  : enter 2"
        echo " "
        echo "To Exit - enter 0"
        echo " "
}

# Above Option Reading
#=====================
readOptions() {
        local chooseSE
        read -p "Enter choice [0-2] : " chooseSE
        case $chooseSE in
                1) fn_Standalone ;;
                2) fn_Clustered ;;
                0) fn_exit ;;
        esac
}

# Main Program
#=============
while true
        do
                showMenu
                readOptions
        done
