module.exports = function() {
    this.append = function(message) {
        var $ = require('jquery');
        var $button = $('<button class="kintoneplugin-button-normal">Alert</button>');
        $button.click(function() {
            alert(message);
        });
        var space = kintone.app.getHeaderMenuSpaceElement();
        $(space).append($button);
    };
};
