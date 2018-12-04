exports.handler = function(event, context, callback) {
    console.log('hello world.');
    console.log('remaining time=', context.getRemainingTimeInMillis());
    callback(null, context.functionName);
} 
