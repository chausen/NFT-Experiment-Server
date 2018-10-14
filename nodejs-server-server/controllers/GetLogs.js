'use strict';

var url = require('url');

var GetLogsService = require('./GetLogsService');

module.exports.logGET = function logGET (req, res, next) {
  GetLogsService.logGET(req.swagger.params, res, next);
};

module.exports.logBySystemGET = function logBySystemGET (req, res, next) {
  GetLogsService.logBySystemGET(req.swagger.params, res, next);
};