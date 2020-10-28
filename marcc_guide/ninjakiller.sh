#Add this function to your ~/.bashrc on MARCC
#Simply call `ninjakiller` to review jobs you have currently running and decide which ones to close
#Courtesy of Surya Chhetri, October 2020.
ninjakiller(){
    str_match=$1
    kill_list=$(ps -eaf | grep ${USER}| cut -f3 -d " ")
    if [[ ${str_match} == "-h" ]]; then
        echo 1>&2 -e "
        Syntax:\n
        ninjakiller scan : Lists job associated with user\n
        ninjakiller go : Terminates user associated jobs without warn\n
        ninjakiller : Lists currently running job IDs, and prompts to terminate them all (response y/n)\n\n
        Your User ID appears to be: ${USER}\n"
        return
    elif [[ ${str_match} == "scan" ]];then
        echo -e "Your User ID appears to be: ${USER}\n"
        for each in ${kill_list};do
            echo -e "JOB detail for PID (${each})\n$(ps ax|egrep "^${each}")"
        done
        echo -e "For selective kill(do): kill -9 <PID>(listedabove)"
        return
    elif [[ ${str_match} == "go" ]];then
        echo -e "Preparing ninja kill run:\n"
        for each_pid in ${kill_list}; do
            echo -e "Killing PID: ${each_pid}"
            kill -9 ${each_pid};
        done
        echo -e "command success!\n";
        return
    elif [[ ${str_match} == "" ]];then
        echo -e "Your User ID appears to be: ${USER}\n"
        echo -e "Ninja job listing: ${kill_list}\n"
        while true; do
        read -p "Do you wish to kill these jobs? " yn
        case $yn in
            [Yy]* ) for each_pid in ${kill_list}; do
                        echo -e "Killing PID: ${each_pid}"
                        kill -9 ${each_pid};
                    done;
                    echo -e "command success!\n"; break;;
            [Nn]* ) echo -e "\nlooking for?: ninjakiller scan\n";break;;
            * ) echo "Please answer yes or no.";;
        esac
        done
    else
        echo -e "\nFor help(Type): ninjakiller -h\n"
        return
    fi
}
