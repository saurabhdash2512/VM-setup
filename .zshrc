
# Start and Stop gcloud instance based on setup_files/vim-instances.json
stop-instance() {
    inst_name="$1"
    zone=$(cat /Users/saurabhdash/.ssh/vm-instances.json | jq --arg var $inst_name '.[$var]' | jq '.zone' | tr -d '"')
    echo "Instance Name: $inst_name \t Zone: $zone"
    gcloud compute instances stop $inst_name --zone $zone
}

restart-instance() {
    inst_name="$1"
    zone=$(cat /Users/saurabhdash/.ssh/vm-instances.json | jq --arg var $inst_name '.[$var]' | jq '.zone' | tr -d '"')
    echo "Instance Name: $inst_name \t Zone: $zone"
    gcloud compute instances start $inst_name --zone $zone > inst_temp.log 2>&1
    line=$(grep 'external IP is' inst_temp.log)
    ip="${line##* }"
    echo "New IP: $ip"
    rm inst_temp.log
    old_ip=`grep -w $inst_name -A 1 ~/.ssh/config | awk '/HostName/ {print $2}'`
    sed -i '' "s/$old_ip/$ip/g" ~/.ssh/config
}

export zone="us-central1-a"
export single_a100="saurabh-test-image"

create_spot_instance() {
    inst_name="$1"
    zone="$2"
    inst_image="$3"
    gcloud alpha compute instances create $inst_name --provisioning-model=SPOT --instance-termination-action=STOP --zone=$zone --source-machine-image=$inst_image > inst_temp.log 2>&1
    ip=$(awk 'FNR == 3{print $5}' inst_temp.log)
    rm inst_temp.log
    # ip=gcloud compute instances list --filter=$inst_name --format "get(networkInterfaces[0].accessConfigs[0].natIP)"
    echo "New VM created with name: $inst_name zone: $zone IP address: $ip"
    echo -e "\nHost $inst_name \n \
    HostName $ip \n \
    IdentityFile ~/.ssh/google_compute_engine \n \
    User saurabh_cohere_com\n" \
    >> ~/.ssh/config
    jq --arg var1 $inst_name --arg var2 $zone '.[$var1].zone += $var2' /Users/saurabhdash/.ssh/vm-instances.json >temp.json && 
    mv temp.json /Users/saurabhdash/.ssh/vm-instances.json
}

create_instance() {
    inst_name="$1"
    zone="$2"
    inst_image="$3"
    gcloud alpha compute instances create $inst_name --zone=$zone --source-machine-image=$inst_image > inst_temp.log 2>&1
    ip=$(awk 'FNR == 3{print $5}' inst_temp.log)
    rm inst_temp.log
    # ip=gcloud compute instances list --filter=$inst_name --format "get(networkInterfaces[0].accessConfigs[0].natIP)"
    echo "New VM created with name: $inst_name zone: $zone IP address: $ip"
    echo -e "\nHost $inst_name \n \
    HostName $ip \n \
    IdentityFile ~/.ssh/google_compute_engine \n \
    User saurabh_cohere_com\n" \
    >> ~/.ssh/config
    jq --arg var1 $inst_name --arg var2 $zone '.[$var1].zone += $var2' /Users/saurabhdash/.ssh/vm-instances.json >temp.json && 
    mv temp.json /Users/saurabhdash/.ssh/vm-instances.json
}
