{% from "letsencryptsh/map.jinja" import letsencryptsh_settings with context %}

letsencryptsh-dependency:
  pkg.installed:
    - pkgs: {{ letsencryptsh_settings:required }}

letsencryptsh-install:
  git.latest:
    - name: {{ letsencryptsh_settings:repository }}
    - branch: {{ letsencryptsh_settings:branch }}
    - depth: {{ letsencryptsh:depth }}
    - target: {{ letsencryptsh:install_path }}

letsencryptsh-config:
  file.managed:
    - name: {{ letsencryptsh:config_path }}
    - makedirs: True
    - source: salt://letsencryptsh.files.config.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 644

letsencryptsh-domains:
  file.managed:
    - name: {{ letsencryptsh:BASEDIR }}/domains.txt
    - makedirs: True
    - contents_pillar: letsencryptsh:domains
    - user: root
    - group: root
    - mode: 644
