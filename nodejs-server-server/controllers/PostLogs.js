'use strict';

var url = require('url');

var PostLogsService = require('./PostLogsService');

module.exports.logPOST = function logPOST (req, res, next) {
  PostLogsService.logPOST(req.swagger.params, res, next);
};
