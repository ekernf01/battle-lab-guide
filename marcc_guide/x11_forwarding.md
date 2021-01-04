# Visualizing files in a command line setting
When it comes to viewing images on MARCC, you have a few options. The easiest might be to use an interactive GUI, such as RStudio or Jupyter Notebook, to view the files. However, this can also be done via **X11 forwarding**.
This requires local software (on your machine) that can communicate with the remote server to view an image. The approach is generally the same between linux and Mac systems, with some caveats. For a more complete breakdown, I recommend [this] (https://www.businessnewsdaily.com/11035-how-to-use-x11-forwarding.html) tutorial to get you started.

## Install XQuartz on your local machine
Install XQuartz using a download [here](https://www.xquartz.org/)

## Log in to MARCC with a trusted X11 forwarding connection
At this point, you may be able to log in directly using the following:
`ssh -Y login.marcc.jhu.edu -l username@jhu.edu`
Most tutorials suggest using the `-X` tag, but on MARCC this throws a warning:
`Warning: untrusted X11 forwarding setup failed: xauth key data not generated`
(For more information see [this](https://serverfault.com/questions/273847/what-does-warning-untrusted-x11-forwarding-setup-failed-xauth-key-data-not-ge) StackExchange thread)

Note that when attempting this on my machine (MacOS Catalina v. 10.15.7), I needed to perform an additional step of restarting OpenSSh, following the guidelines 
on (this thread)[https://serverfault.com/questions/273847/what-does-warning-untrusted-x11-forwarding-setup-failed-xauth-key-data-not-ge].

## Launch a visualization
Once you are logged into MARCC, test the visualization with the command `xclock`, which should open up a picture of a clock. Note that this mode of visualization isn't particularly fast, so give it a second.
If you have an image file you want to view, you will need to use `eog`:
```
ml eog
eog image_file.png
```
Once again, this may be slow. You can also view plots in an interactive R session with X11 forwarding set up.
