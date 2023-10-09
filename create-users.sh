#!/bin/bash

# create users bash script

# global variables
users=$1
count=1
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color


function check_privilege(){
    # EUID is the Effective User ID, it changes for processes
    # Example: When user2 wants to change their password, they execute /usr/bin/passwd
    # The RUID will be user2 but the EUID of that process will be root
    if [[ $EUID -ne 0 ]]; then
        echo "Error: you do not have root privilege to execute"
        exit 1
    fi
}

function count_user(){
    getent passwd | wc -l
}

function give_privilege(){
    # if user wants to have root privilege
    echo -e "Would you like to give $username sudo privileges ${RED}(type y or n)?${NC} \c"
    read flagTwo
    if [ "$flagTwo" = "y" ];then
        usermod -aG sudo $username
        echo -e "user $username has been created successfuly ${GREEN}with sudo privilege${NC}"
    else
        echo -e "user $username has been created successfuly ${GREEN}without sudo privilege${NC}"
    fi
}

function create_user(){
    while [ $count -le $users ];do
        echo -e "Enter username no. $count: \c"
        # echo -e "Enter a username: \c"
        read username

        # Check if username exists (to avoid adding extra count)
        if id "$username" >/dev/null 2>&1;then
            echo "Error: user exists"
        
        # Continue with the rest of the code
        else
            echo -e "The defaults will be bash and home directory, would you like to customize ${RED}(type y or n)?${NC} \c"
            read flag

            # if no, the defaults will execute (home dir and bash)
            if [ "$flag" = "n" ];then
                useradd $username -m -s /bin/bash
                # count incremented, restart loop
                let "count=count+1"
                # if user wants to have sudo privilege
                give_privilege

            # else, user customizes
            elif [ "$flag" = "y" ];then
                echo -e "${YELLOW}Desired bash: ${NC}\c"
                read customBash
                echo -e "${YELLOW}Desired directory: ${NC}\c"
                read customDir
                useradd $username -m -d $customDir -s $customBash
                # count incremented, restart loop
                let "count=count+1"
                # if user wants to have sudo privilege
                give_privilege

            # for strict measures
            else
                echo "You did not give a specific answer"
            fi

        fi
    done
}

function main(){
    check_privilege
    before=$(count_user)
    create_user
    after=$(count_user)

    echo -e "\n-------------------------"
    echo "No. of users before script: $before"
    echo "No. of users after script: $after"
}

main
