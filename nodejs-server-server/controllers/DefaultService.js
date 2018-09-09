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
  const dbName = 'gh';
  const db = new(cradle.Connection)().database(dbName); 
  
  db.exists(function (err, exists) {
    if (err) {
      console.log('error', err);      
    } else if (exists) {
      // Do nothing
    } else {
      console.log('Creating ' + dbName);
      db.create(function(err) {
        if (err)
          console.log('Error creating ' + dbName);
      });
    }
  });
  
  let viewName = '_design/' + args.system.value;  

  db.get(viewName, function (err, doc) {
    if (err) {
      console.log("Saving view...")
      console.log(JSON.stringify(viewName));

      db.save(viewName, {
        byTimestamp: {
          map: function (doc) {                      
            if (doc.timestamp)
              emit(doc.timestamp, doc);
          }
        }
      });                              
    } else {
      console.log("View already exists...")
    }
  });  
     
  let dataLogText = `${args.system.value}
                     ${args.entry.value.sensors}
                     ${args.entry.value.timestamp}`;

  db.save({
    system: args.system.value,
    sensors: args.entry.value.sensors,
    timestamp: args.entry.value.timestamp
  }, function (err, res) {
    if (err)
      console.log("Error writing record.");
    else
      console.log(dataLogText);
  });      
  
  res.end();
}

