'use strict';

var url = require('url');

var Default = require('./GetLogsService');

module.exports.logGET = function logGET (req, res, next) {
  Default.logGET(req.swagger.params, res, next);
};
