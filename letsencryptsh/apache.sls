letsencryptsh-apache-global-alias:
  file.managed:
    - name: /etc/apache2/conf-available/letsencryptsh.conf
    - source: salt://letsencryptsh/files/letsencryptsh-apache.conf
    - user: root
    - group: root
    - mode: 644
    - makedirs: True
    - template: jinja

#letsencryptsh-utils:
#  file.managed:
#    - name: /etc/letsencrypt.sh/check_ssl_path.py
#    - user: root
#    - group: root
#    - mode: 755
#    - source: salt://letsencryptsh/files/check_ssl_path
