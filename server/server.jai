buffer_size :: 1024;

main :: () {
    s := connect(.SERVER);
    Log.info("Listening to %:%...", address, port);
    defer close(s);

    while true {
        client_fd, sock_addr := accept(s); 
        Log.debug("client % connected from %", client_fd, to_string(sock_addr));
        
        // wait until client sends a message
        Log.info("Reading data from client...");
        data := read_from_client(client_fd);
        defer free(data);
        body := parse_response_data(data);
        Log.debug("Body: %", body);
        
        // send response
        send(client_fd, "Hello from http server");

        close(client_fd);
    }
}

#import "Basic";
#import "Socket";
#import "String";
#import "POSIX";
Log :: #import "Log";

#load "../common/common.jai";
