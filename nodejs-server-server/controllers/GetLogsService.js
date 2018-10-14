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
  
  let viewName = 'log/byTimestamp'; 
  
  db.view(viewName, function(err, results) {          
    if (err) {
      res.write(JSON.stringify(err));
    } else if (results) {
      let filteredResults = {entries: []};
      results.forEach(function (key, row) {        
        let docTimestamp = new Date(key);                                
        if (docTimestamp > inputTimestamp) {
          let record = row.sensors;
          record['system'] = row.system;
          record['timestamp'] = row.timestamp;
          filteredResults.entries.push(record);    
        }      
      })
      console.log('Results: ' + JSON.stringify(filteredResults));
      res.write(JSON.stringify(filteredResults));          
    }         
    res.end();   
  });
    
}

exports.logBySystemGET = function(args, res, next) {
  /**
   * Return all logs entries, for the provided system, 
   * that come after the provided timestamp.
   * Optional extended description in CommonMark or HTML.
   *
   * entry LogEntry 
   * no response value expected for this operation
   **/
  
  const cradle = require('cradle');
  const dbName = 'gh'
  const db = new(cradle.Connection)().database(dbName);   

  let inputTimestamp = new Date(args.timestamp.value.toISOString());    
  
  let viewName = 'log/byTimestamp'; 

  db.view(viewName, function(err, results) {          
    if (err) {
      res.write(JSON.stringify(err));
    } else if (results) {
      let filteredResults = {entries: []};          
      results.forEach(function (key, row) {        
        let docTimestamp = new Date(key);                                
        if (docTimestamp > inputTimestamp && args.system.value === row.system) {
          let record = row.sensors;
          record['system'] = row.system;
          record['timestamp'] = row.timestamp;
          filteredResults.entries.push = record;
        }          
      })
      console.log('Results: ' + JSON.stringify(filteredResults));
      res.write(JSON.stringify(filteredResults)); 
    }         
    res.end();   
  });      
}