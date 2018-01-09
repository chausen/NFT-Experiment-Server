'use strict';

exports.logPOST = function(args, res, next) {
  /**
   * Create a new log entry.
   * Optional extended description in CommonMark or HTML.
   *
   * entry LogEntry 
   * no response value expected for this operation
   **/

  var MongoClient = require('mongodb').MongoClient;
  var url = "mongodb://localhost:27017/GH";
  let dataLogText = `${args.entry.value.ec}
                     ${args.entry.value.voltage}
                     ${args.entry.value.pH}
                     ${args.entry.value.rH}
                     ${args.entry.value.wTemp}
                     ${args.entry.value.aTemp}
                     ${args.entry.value.timestamp}`;                    
  

  MongoClient.connect(url, function(err, db) {
    if (err) throw err;

    db.collection("EnvParms").insertOne(args.entry.value, function(err, res) {
      if (err) throw err;
      console.log("Inserted:");
      console.log(dataLogText);
      db.close();
    });
  });  
  
  res.end();
}

