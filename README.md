# letsencrypt.sh-formula
Saltstack formula for letsencrypt, using the client [[https://github.com/lukas2511/letsencrypt.sh|letsencrypt.sh]].

## Why

The official client is quite complex for the task required, what if using just a bunch of bash scripts? 
By now this fomula supports by default only nginx, but I hope to get also apache support soon.

# Modules

## nginx
In order to use this formula with the nginx-formula, please add in nginx vhost the option:
 - include /etc/nginx/global.d/*.conf;

If nginx is already configure with wrong cert path, it is possible to comment them with the util script in /etc/letsencrypt.sh/ in order to start the server without any certificate.

## apache
For apache it is required to enable the letsencrypt.conf configuration and reload the webserver:

{{{
a2enconf letsencrypt.conf
service apache restart
}}}
