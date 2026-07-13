buffer_size :: 1024;

main :: () {
    s := connect(.SERVER);
    log(.INFO, "Listening to %:%...", address, port);
    defer close(s);

    while true {
        client_fd, sock_addr := accept(s); 
        log(.DEBUG, "client % connected from %", client_fd, to_string(sock_addr));
        
        log(.INFO, "Reading data from client...");
        sb: String_Builder;
        data := read_from_client(client_fd, sb);
        defer free(data);
        body := parse_response_data(data);
        log(.DEBUG, "Body: %", body);
        
        // response
        response_body := "Hello from http server";

        reset(*sb);
        print_to_builder(*sb,"HTTP/1.1 200 OK\r\n");
        print_to_builder(*sb, "Content-Type: text/plain\r\n");
        print_to_builder(*sb, "Content-Length: %\r\n", response_body.count);
        print_to_builder(*sb, "Connection: close\r\n");
        print_to_builder(*sb, "\r\n");
        print_to_builder(*sb, "%", response_body);

        res := builder_to_string(*sb);
        defer free(res);

        write(client_fd, res.data, xx res.count);
        close(client_fd);
    }
}

#import "Basic";
#import "Socket";
#import "String";
#import "POSIX";

#load "../common/common.jai";
