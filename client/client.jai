main :: () {
    ok, s: = Connect.open(server_address, server_port);
    defer Connect.close(s);
    if !ok {
        Log.panic("Could not connect to server");
    }

    ok = Connect.connect(s);
    if !ok {
        Log.panic("Could not connect to server");
    }
    
    Log.info("Connected to %:%", server_address, server_port);

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

connect_to_server :: () {
}

#import "Basic";

Log      :: #import "Log";
Connect  :: #import "Connection";

#load "../globals.jai";
