# Battle Lab Cloud Computing Guide



[TOC]

## Glossary

**Regions** - AWS has physical datacenters around the world. For the Battle Lab, it is recommended to use all services on the Ohio (us-east-2) region because it is geographically close and a history of fewer outages

**EC2** - Elastic Compute Cloud: service that allows users to rent virtual computers

**AMI** - Amazon Machine Image: template for a software configuration (e.g. an operating system with other software preinstalled)

**Instance** -  A copy of the AMI running as a virtual computer

**Instance type** - Determines the "computing hardware" of the virtual computer

**EBS** - Elastic Block Storage: behaves as "hard drives" that store data. An EBS volume can be "attached" to an EC2 instance.

**AWS CLI** - Amazon Web Services Command Line Interface: command-line times for interacting with AWS resources

**S3** - Simple Storage Service: An object storage service that is suitable for large datasets that need to be shared

**EBS Snapshots** - Incremental backups of EBS volumes.

**IAM** - Identity Access Management: tools for controlling access to AWS resources



## Quickstart Tutorial

### General workflow

1. Start an existing stopped instance or launch a completely new one.
2. Use SSH to connect to the instance
3. After running computations, stop the instance so the lab won't be billed for inactivity.



### Getting an account

Request a new account from the lab administrators by sending a message on `#battle_lab_trainee`. You will receive a spreadsheet file with username, password, access key ID, secret access key, and console login link.

Open the console login link and enter your username and password.

<img src="Cloud Computing Guide pics/login.png" alt="login" style="zoom:40%;"/>

As of May 2022, on the first login, a popup will ask if you want to use the new user interface. The rest of this document assumes you are using the new user interface.

### Launching an EC2 instance

We are keeping all of our computing in the Ohio region (us-east-2). Make sure the region is Ohio by checking the top right of the management console. There is an IAM policy that prevents accessing EC2 on other regions.

<img src="Cloud Computing Guide pics/region.png" alt="login" style="zoom:40%;"/>



#### Configure your instance

In the management console, search for "EC2" and click on "Launch instance" > "Launch instance"



**Names and tags**

AWS resources can be given tags, which are key-value pairs, that make organization easier. The Name tag should match the username of the AWS account. There is an IAM policy that prevents you from starting, stopping, or terminating instances when the Name tag does not match.

"Add additional tags" is completely optional. For example, you can have a project tag that specifies which project your instance is meant for.

<img src="Cloud Computing Guide pics/tag.png" alt="login" style="zoom:40%;"/>



**Application and OS images (Amazon Machine Image)**

Choose the distribution of linux you are most familiar with. If unsure, use Ubuntu.



**Instance type**

Use the default t2.micro for this tutorial.



**Key pair (login)**

If this is your first time, select "Create new key pair". Give the key pair name the same as your account. For "Private key file format", select ".pem" if you are using Linux/Mac to connect to AWS and ".ppk" if you are using PuTTY on Windows to connect to AWS. Click on "Create key pair" and save the private key somewhere safe. **YOU CANNOT CONNECT TO THIS EC2 INSTANCE WITHOUT THE PRIVATE KEY!**

<img src="Cloud Computing Guide pics/keypair.png" alt="login" style="zoom:40%;"/>



**Network settings**

Under "Firewall (security groups)", choose "Select. existing security group" and pick "Battle_Lab_SSH_access" from the drop down menu.

<img src="Cloud Computing Guide pics/security group.png" alt="login" style="zoom:40%;"/>

**Configure storage**

Set the volume type to "gp3". Compared to gp2, gp3 costs less per GiB.



Now click on "Launch instance"



#### Connecting to your instance

View your instances by searching for "EC2" and on the left side bar, select "Instances". Check that the instance you want to connect to has the green "Running" instance state. Right click on the instance and choose "Connect". Follow the instructions provided under "SSH client".



After connecting, the default user depends on which Linux distribution you chose. Check the user with `whoami` in the terminal. For Ubuntu the default user is `ubuntu`



Ubuntu login screen example

```shell
The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.

To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

ubuntu@ip-172-31-16-234:~$ whoami
ubuntu
```



Troubleshooting common issues:

* Private key does not have appropriate permissions (`chmod 400`)
* The path to the private key is incorrect
* The public DNS changes after stopping and staring the instance



### Managing your instance software

For Ubuntu, the package manager is `apt`. Run the two lines to update current packages on Ubuntu and install the unzip package. We'll need unzip to install AWS CLI later.

```shell
sudo apt update && sudo apt upgrade

sudo apt install unzip
```



### Stopping your instance

The EC2 instance costs $X per hour, even when sitting idle. To stop AWS from charging, you need to change the "Instance state" from "Running" to "Stopped". The best practice is to stop the instance when you're not actively running computations. Stopping the instance is similar to powering down a desktop computer. When you start it up again, all of your files will persist. Terminating an instance is like throwing out the entire computer, including it's hard drive. Terminating an instance will also delete it's attached instance.



## Advanced Tutorials

### AWS CLI

If using Amazon Linux, the AWS CLI is already installed. Otherwise, follow these [instructions](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) to install AWS CLI. Next we need to configure AWS CLI with your account's credentials. The access key ID and secret access key can be found in the same csv file as your login information. **Treat the access key ID and secret access key as a password. If you suspect it's been stolen, notify an administrator user immediately.**



Run `aws configure` and enter the following information. Note that Ohio is `us-east-2`

```shell
AWS Access Key ID [None]: YOUR_ACCESS_KEY_ID
AWS Secret Access Key [None]: YOUR_SECRET_ACCESS_KEY
Default region name [None]: us-east-2
Default output format [None]: json
```



### Accessing lab data on S3 from your instance

AWS CLI allows you to use commands to manipulate files on S3.



List buckets

```
aws s3 ls
```

Check contents of test bucket

```shell
aws s3 ls s3://battle-lab-test
```

Create a dummy file and copy to the test bucket

```shell
touch victor_dummy_file.txt
aws s3 cp victor_dummy_file.txt s3://battle-lab-test
```

Download a file from test bucket

```shell
aws s3 cp s3://battle-lab-test sales.pdf .
```

Download an entire S3 bucket to a local directory

```shell
aws s3 sync s3://battle-lab-test my_battle_lab_test
```

Delete a file from test bucket

```shell
aws s3 rm s3://battle-lab-test/victor_dummy_file.txt
```





### Uploading data outside of AWS to S3

1. SSH into your EC2 instance
2. Use `scp` or `rsync` to download data from MARCC to your instance
3. Use AWS CLI to upload data from your instance to S3



You have to first download MARCC data to our EBS volume because AWS CLI cannot be installed on MARCC. For information on using `scp`, click [here](https://kb.iu.edu/d/agye). For information on using `rsync`, click [here](https://www.digitalocean.com/community/tutorials/how-to-use-rsync-to-sync-local-and-remote-directories).



### Snapshots and switching instances

Snapshots are incremental backups of a EBS volume (similar to time machine on Mac). You can use them to restore your EBS volume to a previous state, or convert the snapshot into an AMI to launch a new instance with a different instance type.



**Create snapshot**

In the EC2 dashboard, click on your instance. In the bottom menu, navgiate to "Storage" > "Volume ID" and click on the link.

<img src="Cloud Computing Guide pics/ec2 bottom.png" alt="login" style="zoom:80%;"/>



Right click on the volume that is attached to your instance and select "Create snapshot". Navigate to the "Snapshots" menu on the left and wait for the snapshot to complete. The larger the EBS volume, the longer the wait.

<img src="Cloud Computing Guide pics/create snapshot.png" alt="login" style="zoom:80%;"/>



**Switching instances**

Suppose you are finished preliminary analysis and prototyping a pipeline. You want to run your pipeline on the full dataset and so require more computing power than your current instance type. To change instances, create a snapshot, convert that snapshot into an AMI, and finally launch a new instance from that AMI. On the launch instance configuration page, you are free to select an instance type different from your original. Details are [here](https://medium.com/tensult/launch-the-aws-instance-from-a-snapshot-3f7397229a1b).

After your new instance is up and running, terminate the old instance to save on compute costs, EBS space, and organize your AWS resources.

### Attaching multiple EBS volumes to a single EC2 instance
TODO
Use case: Have the first EBS volume act as root volume (smaller volume with the operating system and software) and the second EBS volume act as a data only volume. That way, you can make snapshots of only the root volume when making a backup before installing new software, which shouldn't affect data.

### Using jupyter notebook

TODO

### Using RStudio

TODO

### Recommended instance types

Prices are from 2023 Oct 17, in USD. 

- `t2.micro`: 0.011 per hour. Great for first-timers and for testing light loads such as installing an R package.
- `t2.xlarge`: 0.1856 per hour. This has 4 cores and 16GB of RAM; good for moderate loads or regular non-trivial use.
- `m5a.8xlarge`: 1.37 per hour. This is expensive, about 33 dollars a day, but it is optimized for RAM: 128GB. This is good for **occasional** very RAM-heavy analyses; if you need this kind of resource frequently, bring it up with Alexis.
