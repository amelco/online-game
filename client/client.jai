main :: () {
    s: = connect(.CLIENT);
    log(.INFO, "Connected to %:%", address, port);
    defer close(s);

    send(s, "Hello from CLIENT!");

    log(.INFO, "Reading response from server...");
    data := read_from_server(s);
    body := parse_response_data(data);
    defer free(body);
    log(.DEBUG, "Body: %", body);
}


#import "Basic";
#import "String";
#import "Socket";
#import "POSIX";

#load "../common/common.jai";
