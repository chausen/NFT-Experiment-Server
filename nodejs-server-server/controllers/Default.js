'use strict';

var url = require('url');

var Default = require('./DefaultService');

module.exports.logPOST = function logPOST (req, res, next) {
  Default.logPOST(req.swagger.params, res, next);
};
