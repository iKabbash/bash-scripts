#!/bin/bash 
admin[1]=<username>
key[1]=""
# Add user if doesn't exist:
for n in $(seq 1 ${#admin[@]})
do
        # Create user
        if [ -z `grep ${admin[n]} /etc/passwd` ]
        then
                useradd -s /bin/bash -md /home/${admin[n]} ${admin[n]}
                mkdir /home/${admin[n]}/.ssh
                echo -n "${key[n]}" > /home/${admin[n]}/.ssh/authorized_keys
                chown ${admin[n]}:${admin[n]} /home/${admin[n]} -R
                chmod 700 /home/${admin[n]}/.ssh
                chmod 600 /home/${admin[n]}/.ssh/authorized_keys
        fi

        # Add user to visudo (CAREFUL WITH IT)
        # grep "${admin[n]}" /etc/sudoers > /dev/null 2>&1
        # if ! [ $? -eq 0 ]
        # then
        # echo -e "\n${admin[n]}  ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
        # fi
done
