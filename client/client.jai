main :: () {
    ok, s: = Connect.open(.CLIENT);
    defer Connect.close(s);
    if !ok {
        Log.panic("Could not connect to server");
    }
    Log.info("Connected to %:%", address, port);

    ok = Connect.send(s, "Hello from CLIENT!");
    if !ok {
        Log.panic("Could not send data");
    }

    Log.info("Reading response from server...");
    data := Connect.read(s);
    defer free(data);
    body := Connect.parse_response_data(data);
    Log.debug("Body: %", body);
}

#import "Basic";

Log      :: #import "Log";
Connect  :: #import "Connection";

#load "../common/common.jai";
