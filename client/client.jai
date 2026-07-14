main :: () {
    ok, s: = connect(.CLIENT);
    defer Posix.close(s);
    if !ok {
        Log.panic("Could not connect to server");
    }
    Log.info("Connected to %:%", address, port);

    ok = send(s, "Hello from CLIENT!");
    if !ok {
        Log.panic("Could not send data");
    }

    Log.info("Reading response from server...");
    data := read(s);
    defer free(data);
    body := parse_response_data(data);
    Log.debug("Body: %", body);
}

Posix :: #import "POSIX";
Log   :: #import "Log";

#load "../common/common.jai";
