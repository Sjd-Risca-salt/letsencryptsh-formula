{#- Configuration setups:
  - main config
  - domains list
  - hooks
#}
# This is the default package configuration, write your own in conf.d/
letsencryptsh-main_config:
  file.managed:
    - name: {{ letsencryptsh_settings.config_path }}/config
    - makedirs: True
    - source: salt://letsencryptsh/files/config_default.txt
    - user: root
    - group: root
    - mode: 644
{% set conf_dir = (letsencryptsh_settings.config_path, 'conf.d')|join("/") %}
{% set conf_files = salt['pillar.get']('letsencryptsh:config',{}) %}
{% set existing_files = salt['file.find'](conf_dir,type='f',print='name',maxdepth=0) %}
{% for conf_file in existing_files %}
{%   if conf_file not in conf_files %}
letsencrypt-delete-old-conf_{{ conf_file }}:
  file.absent:
    - name: {{ conf_dir }}/{{ conf_file }}
{%   endif %}
{% endfor %}
{# then go through the sites and manage the files... #}
{% for conf in conf_files %}
letsencrypt-conf-file-{{ conf }}:
  file.managed:
    - name: {{ conf_dir }}/{{ conf }}
    - source: salt://letsencryptsh/files/config.jinja
    - template: jinja
    - user: root
    - group: root
    - defaults:
        filename: {{ conf }}
    - mode: 644
{% endfor %}

{%- set domains = salt[pillar.get]('letsencryptsh:domains', '') %}
letsencryptsh-domains:
  file.managed:
    - name: {{ [letsencryptsh_settings.config_path, 'domains.txt']|join('/') }}
    - makedirs: True
{%- if domains is string %}
    - contents_pillar: letsencryptsh:domains
{%- else %}
    - contents:
{%-   for dom in domains %}
      - {{ dom }}
{%-   endfor %}
{%- endif %}
    - user: root
    - group: root
    - mode: 644

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
