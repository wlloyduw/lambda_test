var response = "";
var info = "";
    
exports.handler = function(event, context, callback)  {
    var cpu;

    var line;
    console.log('hello world.');
    //console.log('remaining time=', context.getRemainingTimeInMillis());
    
    var lineReader = require('readline').createInterface({
      input: require('fs').createReadStream('/proc/cpuinfo')
    });

    lineReader.on('line', function (line) {
      //console.log('>', line); 
      if(line.indexOf('model name') > -1) 
      {
         cpu=line.split(':');
         cpu=cpu[1];
         cpu=cpu.trim();
         console.log('CPU-in is =',cpu);
         response='{ "cpuType":"' + cpu + '", "uuid":"1111","pid":"555","cpupusr":"50000","cpuUsr":"111","cpuKrn":"222","vmcpusteal":"0","vuptime":"100","newcont":"0"}';
         //response='{ "cpuType":"' + cpu + '"}';
         
         console.log('y=',JSON.parse(response));
         response=JSON.parse(response);
         //return response;
      }
    });
    
    
    console.log('x=',response);
    //return response;

    callback(null, response);
} 

