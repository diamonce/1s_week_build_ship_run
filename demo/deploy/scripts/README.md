## How to install kubectl plugin

To use a plugin, make the plugin executable:

sudo chmod +x ./kubectl-kubeplugin
and place it anywhere in your PATH:

sudo mv ./kubectl-kubeplugin /usr/local/bin
You may now invoke your plugin as a kubectl command:

kubectl kubeplugin

## Usage example 

![dctop example](https://raw.githubusercontent.com/diamonce/1s_week_build_ship_run/main/demo/deploy/scripts/dctop.png)
<img src="![dctop example](https://raw.githubusercontent.com/diamonce/1s_week_build_ship_run/main/demo/deploy/scripts/dctop.png)">