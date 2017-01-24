{% if grains['kernel'] == 'Linux' %}
  {% if grains['os_family'] == 'Debian' %}
  include:
    - tick.repo.deb
  {% elif grains['os_family'] == 'RedHat' %}
  include:
    - tick.repo.redhat
  {% endif %}
{% endif %}
