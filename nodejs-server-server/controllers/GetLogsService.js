'use strict';

exports.logGET = function(args, res, next) {
  /**
   * Return all logs entries that come after the provided timestamp.
   * Optional extended description in CommonMark or HTML.
   *
   * entry LogEntry 
   * no response value expected for this operation
   **/

  let inputTimestamp = args.timestamp.value.toISOString();

  let MongoClient = require('mongodb').MongoClient;
  let url = "mongodb://localhost:27017/GH";                    

  MongoClient.connect(url, function(err, db) {
    if (err) throw err;
    
    let query = {"timestamp": { "$gt": inputTimestamp }};    
      
    db.collection("EnvParms").find(query).toArray(function(err, results) {
      if (err) throw err;
	console.log(results);
	res.write(JSON.stringify(results));	
	db.close();
	res.end();
    });
  }); 
}
