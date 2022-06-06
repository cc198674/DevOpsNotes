'use strict'

exports.handler = function(event, context, callback) {
    var response = {
        statusCode: 200,
        headers: {
            'Content-Type': 'text/html; charset=utf-8'
        },
        body: '<p>Hao a ni!</p>'
    }
    callback(null, response)
}
