buffer_size :: 1024;

main :: () {
    ok, s := connect(.SERVER);
    defer Posix.close(s);
    if !ok {
        Log.panic("Could not connect to server");
    }

    Log.info("Listening to %:%...", address, port);
    while true {
        client_fd, sock_addr := accept(s); 
        Log.debug("client % request from % begun", client_fd, to_string(sock_addr));
        
        // wait until client sends a message
        Log.info("Reading data from client...");
        data := read(client_fd);
        defer free(data);
        body := parse_response_data(data);
        Log.debug("Body: %", body);
        
        // send response
        ok := send(client_fd, "Hello from http server");
        if !ok {
            Log.error("Could not send data");
        }

        Log.debug("client % request from % ended", client_fd, to_string(sock_addr));
        Posix.close(client_fd);
    }
}

Posix :: #import "POSIX";
Log   :: #import "Log";

#load "../common/common.jai";
