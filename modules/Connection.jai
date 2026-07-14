open :: (to: Machine) -> ok: bool, s: Socket {
    if !socket_init() { // needed by Windows
        Log.debug("Could not initialize socket");
        return false, -1;
    }

    s := socket(AF_INET, .SOCK_STREAM, 0);
    if s < 0 {
        Log.debug("Could not initialize socket (%).", s);
        return false, s;
    }

    if to == .SERVER {
        b := bind(s, address, port, AF_INET);
        if b < 0 {
            Log.debug("Could not bind adress to socket (%).", b);
            return false, b;
        }
        
        l := listen(s, 10); 
        if l < 0 {
            Log.debug("Could not listen to socket (%).", l);
            return false, l;
        }
    }
    else if to == .CLIENT {
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

        c := connect(s, cast(*sockaddr)*sa, size_of(type_of(sa)));
        if c < 0 Log.panic("Could not connect (%).\n", c);
    }
    else {
        Log.debug("Could not connect to machine. It must be client or server.");
        return false, -1;
    }
    return true, s;
}

send :: (s: Socket, msg: string) -> ok: bool{
    buf := sprint("Content-Length: %\r\n\r\n%", msg.count, msg);
    w := send(s, buf.data, xx (buf.count+1), .OOB);
    return w > 0;
}

// Allocates memory
read :: (s: Socket) -> string {
    sb: String_Builder;
    bytes_received: s64;
    res_buff: [max_header_size]u8;
    len := 0;
    while true {
        bytes_received = recv(s, res_buff.data, res_buff.count-1, 0);
        if bytes_received <= 0 break;
        if len == 0 {
            value := to_integer(parse_http_head_value(to_string(res_buff.data), "Content-Length:"));
            len = value; // TODO: parse Content-Length value from header
        }
        res_buff[bytes_received] = #char "\0";
        print_to_builder(*sb, to_string(res_buff.data));
        if bytes_received => len break;
    }
    return builder_to_string(*sb);
}

parse_response_data :: (data: string) -> string {
    found, remainder := contains(data, "\r\n\r\n");
    if !found remainder = "";
    return remainder;
}

parse_http_head_value :: (header: string, prop: string) -> string{
    start := find_index_from_left(header, prop);
    start += prop.count;
    end := find_index_from_left(header, "\r\n", start);
    str_num : []u8;
    str_num.data = *header.data[start];
    str_num.count = end - start;
    return to_string(str_num.data);
}

accept :: (s: Socket) -> Socket, sockaddr_in {
    addr: sockaddr_in;
    addrlen: u32 = size_of(sockaddr_in);
    fd := accept(s, cast(*sockaddr)*addr, xx *addrlen);
    return fd, addr;
}

close :: (s: Socket) {
    Posix.close(s);
}

Log   :: #import "Log";
Posix :: #import "POSIX";

#import "Socket";
#import "Basic";
#import "String";

#load "../common/common.jai";
