main :: () {
    s: = connect(.CLIENT);
    Log.info("Connected to %:%", address, port);
    defer close(s);

    send(s, "Hello from CLIENT!");

    Log.info("Reading response from server...");
    data := read_from_server(s);
    defer free(data);
    body := parse_response_data(data);
    Log.debug("Body: %", body);
}


#import "Basic";
#import "String";
#import "Socket";
#import "POSIX";
Log :: #import "Log";

#load "../common/common.jai";
