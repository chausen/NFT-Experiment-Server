'use strict';

var url = require('url');

var GetSystemsService = require('./GetSystemsService');

module.exports.systemGET = function systemGET (req, res, next) {
  GetSystemsService.systemGET(req.swagger.params, res, next);
};