'use strict';

var url = require('url');

var Sensor = require('./SensorService');

module.exports.updatePetWithForm = function updatePetWithForm (req, res, next) {
  Sensor.updatePetWithForm(req.swagger.params, res, next);
};
