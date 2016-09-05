{% from "letsencryptsh/map.jinja" import letsencryptsh_settings with context %}

letsencryptsh-dependency:
  pkg.installed:
    - pkgs:
{%- for pkg in letsencryptsh_settings.required %}
      - {{ pkg }}
{% endfor %}

letsencryptsh-install:
  git.latest:
    - name: {{ letsencryptsh_settings.repository }}
    - branch: {{ letsencryptsh_settings.branch }}
    - depth: {{ letsencryptsh_settings.depth }}
    - target: {{ letsencryptsh_settings.install_path }}

letsencryptsh-config:
  file.managed:
    - name: {{ letsencryptsh_settings.config_path }}
    - makedirs: True
    - source: salt://letsencryptsh/files/config.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 644

letsencryptsh-domains:
  file.managed:
    - name: {{ [salt['pillar.get']('letsencryptsh:BASEDIR', letsencryptsh_settings.install_path), 'domains.txt']|join('/') }}
    - makedirs: True
    - contents_pillar: letsencryptsh:domains
    - user: root
    - group: root
    - mode: 644

# TODO: create and set permission of WELLKNOWN (default: /var/www/letsencrypt?)
letsencrypt-serverpath:
  file.directory:
    - name: {{ letsencryptsh_settings.WELLKNOWN }}
    - makedirs: true
    - user: root
    - group: root
    - dir_mode: 755
    - file_mode: 644

{% if salt['pillar.get']('letsencryptsh:HOOK', False) %}
# Setup hook.sh file
letsencrypt-hook-file:
  file.managed:
    - name: {{ salt['pillar.get']('letsencryptsh:HOOK') }}
    - makedirs: True
    - source: salt://letsencryptsh/files/hook.sh
    - template: jinja
    - user: root
    - group: root
    - mode: 755
{% endif %}

letsencrypt-check-cronjob:
{%- if letsencryptsh_settings.cron_enabled %}
  cron.present:
    - name: /opt/letsencryptsh/letsencrypt.sh --cron
    - user: root
    - minute: 7
    - hour: 11
    - identifier: letsencryptjob
{%- else %}
  cron.absent:
    - identifier: letsencryptjob
{% endif %}
