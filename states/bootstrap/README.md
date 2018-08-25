
Step 0: Create volumes accroding to CIS benchmarks

Step 1: Do yum upgrade -y

Step 2: Verify Kernel version and kernel devel version

Step 3: Do salt-setup with grains conf

Step 4: Execute- salt 'minion'  state.sls bootstrap
