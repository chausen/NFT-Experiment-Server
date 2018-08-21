'use strict';

exports.logGET = function(args, res, next) {
  /**
   * Return all logs entries that come after the provided timestamp.
   * Optional extended description in CommonMark or HTML.
   *
   * entry LogEntry 
   * no response value expected for this operation
   **/
  
  const cradle = require('cradle');
  const dbName = 'GH'
  const db = new(cradle.Connection)().database(dbName); 

  let inputTimestamp = args.timestamp.value.toISOString();
  let results = {};

  db.view(args.system.value, function(err, res) {
    res.forEach(function (sensors) {
      if (sensors.timestamp > inputTimestamp) {
        results[sensors.timestamp] = sensors;
      }
    });
  });

  res.write(JSON.stringify(results));
  res.end();  
}
