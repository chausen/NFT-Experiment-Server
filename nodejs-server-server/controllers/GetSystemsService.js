'use strict';

exports.systemGET = function(args, res, next) {
  /**
   * Get the names of all systems that have created log entries.
   * Optional extended description in CommonMark or HTML.
   *
   * system  
   * no response value expected for this operation
   **/
  
  const cradle = require('cradle');
  const dbName = 'gh'
  const db = new(cradle.Connection)().database(dbName);     

  db.get('_design/system', function (err, doc) {
    if (err) {
      console.log("Saving system view...")
      console.log(JSON.stringify('_design/system'));

      db.save('_design/system', {
        all: {
          map: function (doc) {                      
            if (doc.system)
              emit(null, system);
          }
        }
      });                              
    } else {
      console.log("View already exists...")
    }
  });  
  
  db.view('system/all', function(err, results) {      
    if (err) {
        res.write(JSON.stringify(err));
    } else if (results) {
        let filteredResults = {systems: []};
        results.forEach(function (key, row) {
          console.log(row);
          console.log(JSON.stringify(row));
          if (!filteredResults.systems.includes(row))
            filteredResults.systems.push(row);
        });   
        console.log('Results: ' + JSON.stringify(filteredResults));
        res.write(JSON.stringify(filteredResults));          
    }         
    res.end();   
  });
    
}
