buffer_size :: 1024;

main :: () {
    ok, s := Connect.open(.SERVER);
    defer Connect.close(s);
    if !ok {
        Log.panic("Could not connect to server");
    }

    Log.info("Listening to %:%...", address, port);
    while true {
        client_fd, sock_addr := Connect.accept(s); 
        // Log.debug("client % request from % begun", client_fd, to_string(sock_addr));
        
        // wait until client sends a message
        Log.info("Reading data from client...");
        data := Connect.read(client_fd);
        defer free(data);
        body := Connect.parse_response_data(data);
        Log.debug("Body: %", body);
        
        // send response
        ok := Connect.send(client_fd, "Hello from http server");
        if !ok {
            Log.error("Could not send data");
        }

        // Log.debug("client % request from % ended", client_fd, to_string(sock_addr));
        Connect.close(client_fd);
    }
}

#import "Basic";
#import "Socket";

Log     :: #import "Log";
Connect :: #import "Connection";

#load "../common/common.jai";
