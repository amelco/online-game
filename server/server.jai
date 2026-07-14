buffer_size :: 1024;

main :: () {
    s := connect(.SERVER);
    log(.INFO, "Listening to %:%...", address, port);
    defer close(s);

    while true {
        client_fd, sock_addr := accept(s); 
        log(.DEBUG, "client % connected from %", client_fd, to_string(sock_addr));
        
        log(.INFO, "Reading data from client...");
        data := read_from_client(client_fd);
        defer free(data);
        body := parse_response_data(data);
        log(.DEBUG, "Body: %", body);
        
        // send response
        response_body := "Hello from http server";
        content := sprint("HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\nContent-Length: %\r\nConnection: close\r\n\r\n%", response_body.count, response_body);
        write(client_fd, content.data, xx content.count);

        close(client_fd);
    }
}

#import "Basic";
#import "Socket";
#import "String";
#import "POSIX";

#load "../common/common.jai";
