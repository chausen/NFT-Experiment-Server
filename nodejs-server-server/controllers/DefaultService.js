'use strict';

exports.logPOST = function(args, res, next) {
  /**
   * Create a new log entry.
   * Optional extended description in CommonMark or HTML.
   *
   * entry LogEntry 
   * no response value expected for this operation
   **/

  const cradle = require('cradle');
  const dbName = 'GH';
  const db = new(cradle.Connection)().database(dbName); 
  
  db.exists(function (err, exists) {
    if (err) {
      console.log('error', err);      
    } else if (exists) {
      // Do nothing
    } else {
      console.log('Creating ' + dbName);
      db.create(function(err) {
        console.log('Error creating ' + dbName);
      });
    }
  });

  db.get('_design/' + args.system.value, function (err, doc) {
    if (err) {
      let newView = {};
      newView[args.system.value] = {
        map: function (doc) {
          if (doc.system && doc.system == args.system.value)
            emit(doc.timestamp, doc.sensors);
      }};

      db.save('_design/' + args.system.value, newView);
    }
  });  
     
  let dataLogText = `${args.system.value}
                     ${args.entry.value.sensors}
                     ${args.entry.value.timestamp}`;

  db.save({
    system: args.system.value,
    sensors: args.entry.sensors,
    timestamp: args.entry.timestamp
  }, function (err, res) {
    if (err)
      console.log("Error writing record.");
    else
      console.log(dataLogText);
  });      
  
  res.end();
}

