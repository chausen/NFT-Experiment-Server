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
  const dbName = 'gh'
  const db = new(cradle.Connection)().database(dbName); 

  let inputTimestamp = new Date(args.timestamp.value.toISOString());    

  let results = {};

  let designDoc = '_design/' + args.system.value;
  let viewName = args.system.value + '/byTimestamp'; 
  
  db.get(designDoc, function (err, doc) {
    if (err) {
      res.write(JSON.stringify("System does not exist: " + args.system.value));      
      res.end();  
    } else {
      db.view(viewName, function(err, results) {  
        let filteredResults = {};

        if (err) {
          res.write(err);
        } else if (results) {
          results.forEach(function (key, row) {
            var docTimestamp = new Date(key);                                
            if (docTimestamp > inputTimestamp && args.system.value === row.system)
              filteredResults[row.timestamp] = row.sensors;          
          });

          console.log('Results: ' + JSON.stringify(filteredResults));
          res.write(JSON.stringify(filteredResults));          
        }         
        res.end();   
      });
    }
  });  
}
