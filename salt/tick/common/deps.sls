{% if grains.os_family == 'Debian' %}
tick.dep:
  pkg.installed:
    - pkgs:
      - apt-transport-https
      - python-m2crypto
{% endif %}
