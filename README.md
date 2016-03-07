# letsencrypt.sh-formula
Saltstack formula for letsencrypt, using the client letsencrypt.sh

## Why

The official client is quite complex for the task required, what if using just a bunch of bash scripts? 
By now this fomula supports by default only nginx, but I hope to get also apache support soon.

# Modules

## nginx
In order to use this formula with the nginx-formula, please add in nginx vhost the option:
 - include /etc/nginx/global.d/*.conf;

If nginx is already configure with wrong cert path, it is possible to comment them with the util scrip in /etc/letsencrypt.sh/
