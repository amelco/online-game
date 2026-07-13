main :: () {
    address :: "127.0.0.1";
    port : u16 : 6969;

    // create socket
    if !socket_init() panic("Could not initialize (Windows) socket."); // needed by Windows
    s := socket(AF_INET, .SOCK_STREAM, 0);
    if s < 0 panic("Could not create socket (%).", s);

    // prepare address
    sa: sockaddr_in;
    sa.sin_family = AF_INET;
    c_address := to_c_string(address);
    defer free(c_address);
	addr := inet_addr(c_address);
    #if OS == .WINDOWS {
        sa.sin_addr.S_un.S_addr = addr;
    } else {
        sa.sin_addr.s_addr = addr;
    }
    sa.sin_port = htons(port);

    // connect
    // TODO: keep the connection alive for the client until user decides to quit
    c := connect(s, cast(*sockaddr)*sa, size_of(type_of(sa)));
    if c < 0 panic("Could not connect (%).\n", c);
    defer close(s);
    log(.INFO, "Connected to %", to_string(sa));

    // send test message
    body := "Hello from client!";
    buf := sprint("GET / HTTP/1.1\r\nHost: 127.0.0.1:6969\r\nConnection: close\r\nContent-Length: 4\r\nContent-Type: text/plain\r\n\r\n%", body);
    w := send(s, buf.data, xx (buf.count+1), .OOB);  // +1 to account c string null terminator
    if w < 0 panic("Could not send data (%)\n", w);

    // read the response from the server
    log(.INFO, "Reading response from server...");
    sb: String_Builder;
    bytes_received: s64;
    res_buff: [10]u8;
    while true {
        bytes_received = recv(s, res_buff.data, res_buff.count-1, 0);
        if bytes_received <= 0 break;
        res_buff[bytes_received] = #char "\0";
        print_to_builder(*sb, to_string(res_buff.data));
    }

    // parse response
    found, remainder := contains(builder_to_string(*sb), "\r\n\r\n");
    log(.DEBUG, "response: %", remainder);
}

#import "Basic";
#import "String";
#import "Socket";
#import "POSIX";

#load "../common/common.jai";
