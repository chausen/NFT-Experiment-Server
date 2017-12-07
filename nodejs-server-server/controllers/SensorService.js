'use strict';

exports.allMeasurements = function(args, res, next) {
  /**
   * Add a set of measurements for temperature, EC, voltage, pH, and rH
   * 
   *
   * ec Float Electrical conductivity measurement
   * voltage Float Voltage measurement (in volts)
   * pH Float pH measurement
   * rH Float rH measurement
   * wTemp Float WTemperature measurement
   * aTemp Float ATemperature measurement
   * timestamp String time the measurements were collected
   * no response value expected for this operation
   **/
  res.json({success: 1, description: "Sensor data uploaded."});

  res.end();
}

