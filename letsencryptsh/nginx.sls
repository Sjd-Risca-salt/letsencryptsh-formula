letsencryptsh-nginx-global-alias:
  file.managed:
    - name: /etc/nginx/global.d/letsencryptsh.conf
    - source: salt://letsencryptsh/files/letsencryptsh.conf
    - user: root
    - group: root
    - mode: 644
    - makedirs: True
    - template: jinja

letsencryptsh-utils-nginx:
  file.managed:
    - name: /etc/letsencrypt.sh/check_ssl_path.py
    - user: root
    - group: root
    - mode: 755
    - source: salt://letsencryptsh/files/check_ssl_path
