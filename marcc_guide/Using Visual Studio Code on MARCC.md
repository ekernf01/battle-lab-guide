# Using Visual Studio Code on MARCC
VS Code is a popular and powerful code editor. It can catch syntax errors in real time, present documentation pop-ups, and easily find definitions of variables/functions/classes in complex projects.

Once everything is set up, the general workflow is:
1. Login to MARCC and request a job
2. Connect to MARCC using VS Code's SSH Remote extension


## Multiplexing Login and SSH config
Before setting VS Code and its necessary extensions, it is highly recommended to modify your SSH config file to enable multiplexing, which allows multiple SSH sessions over a single master connection. One major benefit is the 2FA code prompt will appear only once instead of each time a new SSH connection is made.

On linux/mac, create/edit the file `~/.ssh/config` so it looks like the following.

```ssh-config
Host marcc
	HostName login.marcc.jhu.edu
	User user123@jhu.edu
	ControlMaster auto
	ControlPath ~/.ssh/control:%h:%p:%r
	ControlPersist 10m
```

`Host marcc` - Beginning of the stanza. The command `ssh marcc` starts an SSH connection according to the stanza's options.

`HostName login.marcc.jhu.edu` - Specifies the SSH connection address.

`User user123@jhu.edu` - Specifies user connecting to MARCC.

`ControlMaster auto` - Activates multiplexing. With the `auto` setting, SSH will create a new master connection if it doesn't already exist.

`ControlPath ~/.ssh/control:%h:%p:%r` - Creates a file in `~/.ssh` to store the "control socket" for multiplexed connections. `%h` refers to host name, `%p` refers to destination port, and `%r` refers to user.

`ControlPersist 10m` - Keeps the master connection active for 10 minutes after it has remained idle. Useful for when SSH connection is accidentally closed.


After saving `~/.ssh/config`, simply enter `ssh marcc` in the terminal. There will be a prompt for the 2FA code and password. For subsequent connections while the multiplexing is active, only the password will be requested.

## VS Code and Remote - SSH

1. Download and open [VS Code](https://code.visualstudio.com/download).
2. Open the extensions menu on the left side bar, search for "Remote - SSH", and install the extension.
3. Install other language specific extensions e.g. "Python" 

### Connect to MARCC

1. In VS Code, click on bottom left corner green icon
2. Select "Connect to Host..." and then "marcc".
3. Enter the MARCC login password. If multiplexing is not active, then enter the 2FA code.
4. Click on top left explorer icon and navigate around the directory on MARCC.

Remote - SSH will timeout if the 2FA code/password is not entered in 15 seconds. To extend the duration, use <kbd>SHIFT</kbd><kbd>CMD</kbd><kbd>P</kbd> to bring up the command palette and search "Preferences: Open Settings (UI)" to open up settings. In the search bar, enter `Remote.SSH: Connect Timeout` and change it from 15 to 30 seconds.

## VS Code on compute nodes, GPU nodes, and battle-bigmem
When running code through the VS Code integrated terminal, make sure "Remote - SSH" is accessing the appropriate computing resources (please do not run heavy workloads on the login node). To ensure best practices, set up VS Code to SSH into the login node and then SSH into the desired computing resource.

For compute nodes, `~/.ssh/config` should look like
```ssh-config
Host marcc
	HostName login.marcc.jhu.edu
	User user123@jhu.edu
	ControlMaster auto
	ControlPath ~/.ssh/control:%h:%p:%r
	ControlPersist 10m

Host compute*
	HostName %h
	ProxyJump marcc
	User user123@jhu.edu
```

The first stanza is the same from the multiplexing section. 

`Host compute*` - `compute*` makes sure the configuration applies to all compute nodes.

`ProxyJump marcc` - Indicates that the first SSH connection is to `login.marcc.jhu.edu`

`User user123@jhu.edu` - Specifies user connecting to MARCC.


For example, run `interact -c 1 -t 1:0:0 -p debug` for a simple interactive session. The node granted by the interactive session can be seen in the terminal.
```console
[user123@jhu.edu@bc-login02 ~]$ interact -c 1 -t 1:0:0 -p debug
[user123@jhu.edu@compute0675 ~]$
```

Notice that `bc-login02` becomes `compute0675`, the compute node granted by the interactive session. To get VS Code to connect to it:
1. In VS Code, click on the bottom left corner green icon
2. Select "Connect to Host..." and then enter `compute0675`

Similar `~/.ssh/config` stanzas are needed for GPU nodes and battle-bigmem.

```ssh-config
Host marcc
	HostName login.marcc.jhu.edu
	User user123@jhu.edu
	ControlMaster auto
	ControlPath ~/.ssh/control:%h:%p:%r
	ControlPersist 10m

Host compute*
	HostName %h
	ProxyJump marcc
	User user123@jhu.edu

Host gpu*
	HostName %h
	ProxyJump marcc
	User user123@jhu.edu

Host battle-bigmem
	HostName %h
	ProxyJump marcc
	User user123@jhu.edu
```

## VS Code Jupyter Notebook
1. Start a jupyter notebook job `sbatch -c 1 -t 1:0:0 -p express jupyter_notebook_start`
```console
[user123@jhu.edu@bc-login02 projects]$ tail slurm-54791342.out

[STATUS] HOW TO ACCESS YOUR NOTEBOOK SERVER
[STATUS] from a terminal (on the same machine with your browser) you must run:

ssh -N -L 9610:compute0754:9610 user123@jhu.edu@login.marcc.jhu.edu

[STATUS] once you connect, visit:

http://localhost:9610/?token=ae7e1cebad6b60bb8952fd892095fccc92705952ce61f414
```

2. **On the local machine**, run the SSH tunnel `ssh -N -L 9610:compute0754:9610 user123@jhu.edu@login.marcc.jhu.edu`.
3. **On the local machine**, open a jupyter notebook from the explorer.
4. When given the "Pick how to connect to Jupyter" prompt, choose "Existing" and enter `http://localhost:9610/?token=ae7e1cebad6b60bb8952fd892095fccc92705952ce61f414`. Note that while the opened .ipynb file is on the local machine, the jupyter notebook server is still running on MARCC. Can check this by running `os.getcwd()`, which will return a location on MARCC.



## Further Reading and References
[SSH Config File](https://linuxize.com/post/using-the-ssh-config-file/)

[SSH Multiplexing](https://blog.scottlowe.org/2015/12/11/using-ssh-multiplexing/)

[SSH Into Interactive Session](https://stackoverflow.com/a/66389686)

[VS Code R Extension](https://github.com/REditorSupport/vscode-R)

[Writing R in VSCode](https://renkun.me/2019/12/11/writing-r-in-vscode-a-fresh-start/)

[Run Jupyter notebook on a compute node in VS code](https://hpc.nih.gov/apps/vscode.html)