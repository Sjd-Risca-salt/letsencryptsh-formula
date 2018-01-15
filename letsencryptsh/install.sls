{#- Install the dehydrated package.
Options:
  - install from git
  - install from ditribution package
#}
{%- from "letsencryptsh/map.jinja" import letsencryptsh_settings with context %}

{%- if letsencryptsh_settings.install_method == 'git' %}
letsencryptsh-dependency:
  pkg.installed:
    - pkgs:
{%-     for pkg in letsencryptsh_settings.required %}
      - {{ pkg }}
{%-     endfor %}

letsencryptsh-install:
  git.latest:
    - name: {{ letsencryptsh_settings.repository }}
    - branch: {{ letsencryptsh_settings.branch }}
    - depth: {{ letsencryptsh_settings.depth }}
    - target: {{ letsencryptsh_settings.install_path }}
{%- else %}
letsencryptsh-install:
  pkg.installed:
    - pkgs:
      - {{ letsencryptsh_settings.dehydrated_pkg }}
{%- endif %}

# TODO: create and set permission of WELLKNOWN (default: /var/www/dehydrated/)
letsencrypt-serverpath:
  file.directory:
    - name: {{ letsencryptsh_settings.WELLKNOWN }}
    - makedirs: true
    - user: root
    - group: root
    - dir_mode: 755
    - file_mode: 644

letsencrypt-check-cronjob:
{%- if letsencryptsh_settings.cron_enabled %}
  cron.present:
    - name: {{ etsencryptsh_settings.dehydrated_path }} --cron
    - user: root
    - minute: 7
    - hour: 11
    - identifier: letsencryptjob
{%- else %}
  cron.absent:
    - identifier: letsencryptjob
{% endif %}
