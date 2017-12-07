'use strict';

var url = require('url');

var Sensor = require('./SensorService');

module.exports.allMeasurements = function allMeasurements (req, res, next) {
  Sensor.allMeasurements(req.swagger.params, res, next);
};
