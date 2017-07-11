(function() {
    //load JS And CSS
    //require('./../../common/style/51-modern-default.css');
    var config = require('./../../common/js/config');

    var AlertButton = require('./alertButton');
    var alertButton = new AlertButton();

    kintone.events.on('app.record.index.show', function() {
        var message = config.app1.message;
        alertButton.append(message);
    });
})();
