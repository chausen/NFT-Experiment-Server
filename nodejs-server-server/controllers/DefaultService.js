'use strict';

exports.logPOST = function(args, res, next) {
  /**
   * Create a new log entry.
   * Optional extended description in CommonMark or HTML.
   *
   * entry LogEntry 
   * no response value expected for this operation
   **/

  console.log(`${args.entry.value.ec}
               ${args.entry.value.voltage}
               ${args.entry.value.pH}
               ${args.entry.value.rH}
               ${args.entry.value.wTemp}
               ${args.entry.value.aTemp}
               ${args.entry.value.timestamp}
              `);

  
  res.end();
}

