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
