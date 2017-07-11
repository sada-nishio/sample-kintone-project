var path = require('path');
var webpack = require('webpack');

module.exports = {
    entry: {
        app1_desktop: './app1/js/desktop.js'
    },
    output: {
        path: __dirname + '/dist/',
        filename: '[name]_bundle.js'
    },
    resolve: {
        alias: {
            'modules': path.join(__dirname, 'node_modules')
        }
    },
    module: {
        rules: [
            {
                test: /\.css$/,
                use: [
                    'style-loader',
                    'css-loader'
                ]
            },
            {
                test: /.(png|jpg|jpeg|gif|svg|woff|woff2|eot|ttf)(\?v=\d+\.\d+\.\d+)?$/i,
                use: [
                    'url-loader'
                ]
            }
        ]
    }
};
