#Add this function to your ~/.bashrc on MARCC
#Simply call `ninjakiller` to review jobs you have currently running and decide which ones to close
#Courtesy of Surya Chhetri, October 2020.
ninjakiller(){
    str_match=$1
    kill_list=$(ps -eaf | grep ${USER}| cut -f3 -d " ")
    user_id=$(echo "${USER}" | cut -f1 -d "@")
    altkill_list=$(ps aux | grep -i "${user_id}*" | grep -v "grep" | grep -v "^root" \
                | awk '{print $2}')
    safekill_list=$(ps aux | grep -i "${user_id}*" | grep -v "grep" | grep -v "^root" \
                | grep -v "${user_id}@jhu.edu@pts" | grep -v "\-bash\b" | awk '{print $2}')
    if [[ ${str_match} == "-h" ]]; then
        echo 1>&2 -e "
        Syntax:\n
        ninjakiller scan : Scans job associated to user\n
        ninjakiller go : Kills user associated jobs without warn\n
        ninjakiller : Warns job kill\n\n
        Your User ID appears to be: ${USER}\n"
        return
    elif [[ ${str_match} == "scan" ]];then
        echo -e "Your User ID appears to be: ${USER}\n"
        for each in ${altkill_list};do
            echo -e "\nJOB detail for PID (${each})\n$(ps -up ${each})"
        done
        echo -e "\nFor selective kill(do): kill -9 <PID>(listedabove)"
        return
    elif [[ ${str_match} == "go" ]];then
        echo -e "Preparing ninja kill run:\n"
        for each_pid in ${altkill_list}; do
            echo -e "Killing PID: ${each_pid}"
            kill -9 ${each_pid} &> /dev/null;
        done
        echo -e "command success!\n";
        return
    elif [[ ${str_match} == "" ]];then
        echo -e "Your User ID appears to be: ${USER}\n"
        echo -e "Ninja job listing:\n${safekill_list}\n"
        while true; do
        read -p "Do you wish to kill these jobs? " yn
        case $yn in
            [Yy]* ) for each_pid in ${safekill_list}; do
                        echo -e "Killing PID: ${each_pid}"
                        kill -9 ${each_pid} &> /dev/null;
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
