angular.module('config', [])
  .constant('config', {
    'endpoint'    : "http://"+window.location.hostname+":8080",
    //'endpoint'    : "/api",
    //'provider'    : "gitlab", // google, github, gitlab or basic
    //'client_id'   : "96312bbaeebb8aa363f78dfa24adf2641be481c92210dbd47eeca1a7bdd1e795",
    //'gitlab_url'  : "https://git.spin.ee",  // replace with your gitlab server
    'colors'      : {
      'severity': {
        'critical'     : '#D8122A',
        'major'        : '#EA680F',
        'minor'        : '#FFBE1E',
        'warning'      : '#ffff00',
        'indeterminate': '#A6ACA8',
        'cleared'      : '#00AA5A',
        'normal'       : '#00AA5A',
        'ok'           : '#00AA5A',
        'informational': '#00A1BC',
        'debug'        : '#9D006D',
        'security'     : '#333333',
        'unknown'      : '#ff9900'
      },
    // 'text': 'black',
    // 'highlight': 'lightgray'
    },

    // use default colors
    'severity'    : {}, // use default severity codes
    'audio'       : {}, // no audio
    'tracking_id' : ""  // Google Analytics tracking ID eg. UA-NNNNNN-N
});
