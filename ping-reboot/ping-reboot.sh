
# Target IP or hostname
TARGET_HOST='1.1.1.1'

# Initialize a counter for consecutive failures
failure_count=0

# Loop to ping the target 5 times
for i in {1..5}
do
    # Ping the target once
    count=$(ping -c 1 $TARGET_HOST | grep 'from' | wc -l)

    if [ $count -eq 0 ]; then
        # If ping failed, increment the failure count
        failure_count=$((failure_count + 1))
    else
        # If ping succeeded, reset the failure count
        failure_count=0
    fi

    # If there are 5 consecutive failures, reboot
    if [ $failure_count -ge 5 ]; then
        echo "$(date)" "Target host $TARGET_HOST unreachable, 5 consecutive failures, Rebooting!" >> /usrdata/root/ping-reboot.log
        /sbin/shutdown -r now
        exit 1
    fi
done

# If there were no consecutive failures, log success
echo "$(date) ===-> OK! " >> /usrdata/root/ping-reboot.log
