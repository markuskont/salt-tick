{% if grains.kernel == 'Windows' and grains.cpuarch == 'AMD64' %}
C:\salt\bin\Lib\site-packages\M2Crypto:
  file.recurse:
    - source: salt://lib/win-x64/M2Crypto
{% endif %}
