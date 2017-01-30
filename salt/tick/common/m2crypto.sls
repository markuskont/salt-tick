{% if grains.kernel == 'Linux' %}
python-m2crypto:
  pkg.installed
{% endif %}
