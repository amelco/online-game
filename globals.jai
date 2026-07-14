address :: "127.0.0.1";
port : u16 : 6969;

// This is the maximum size for the http header. This value is the same as the default value
// in the Apache http server, so I figure it is good enough here. It should be enought to parse
// any header value in the first recv() read. For example, we need to know in advance the
// `Content-Length` value so we can properly stop reading the message in the server.
max_header_size :: 8190;
