#import "Basic";
#import "Socket";
#import "String";
#import "POSIX";

#load "../common/common.jai";

main :: () {
    address :: "127.0.0.1";
    port : u16 : 6969;

    if !socket_init() panic("Could not initialize socket."); // needed by Windows
        
    s := socket(AF_INET, .SOCK_STREAM, 0);
    if s < 0 panic("Could not initialize socket (%).", s);

    b := bind(s, address, port, AF_INET);
    if b < 0 panic("Could not initialize socket (%).", b);
    
    l := listen(s, 10); 
    if l < 0 panic("Could not listen properly (%).", l);

    log(.INFO, "Listening to %:%...", address, port);
    buffer_size :: 1024;
    while true {
        client_fd, sock_addr := accept(s); 
        log(.INFO, "client % connected from %", client_fd, to_string(sock_addr));
        
        buff: [buffer_size]u8;
        read(client_fd, *buff, buff.count);

        // TODO: find a way to parse the content-length and keep reading until it ends (if it exists)
        // use recv()
        // TODO: differentiate between POST and GET requests?
        found, remainder := contains(to_string(buff.data), "\r\n\r\n");
        if found && remainder != "" log(.DEBUG, "request body: %", remainder);
        
        // response
        response_body := "Hello from http server";

        sb: String_Builder;
        print_to_builder(*sb,"HTTP/1.1 200 OK\r\n");
        print_to_builder(*sb, "Content-Type: text/plain\r\n");
        print_to_builder(*sb, "Content-Length: %\r\n", response_body.count);
        print_to_builder(*sb, "Connection: close\r\n");
        print_to_builder(*sb, "\r\n");
        print_to_builder(*sb, "%", response_body);

        res := builder_to_string(*sb);

        write(client_fd, res.data, xx res.count);
        close(client_fd);
    }
}
