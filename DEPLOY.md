# Serve the static website from a VPS (Ubuntu 18.04)

## Install jekyll and svplume

Follow ./INSTALL.md

## [webhook](https://github.com/adnanh/webhook)

### Install webhook and setup service

    sudo apt install webhook
    
    sudo systemctl stop webhook
    sudo systemctl disable webhook
    sudo rm /etc/systemd/system/multi-user.target.wants/webhook.service
    sudo systemctl enable ~/flit/services/webhook.service
    
### Add proxy to nginx

    # At the end of the /etc/nginx/sites-available/default
    upstream webhooks {
        server localhost:PORT;
    }

Open the incoming TCP PORT on the VPS firewall!

### Define the webhook on the model

https://github.com/adnanh/webhook/blob/master/docs/Hook-Examples.md

(real webhook.json is in `flit` repo)
