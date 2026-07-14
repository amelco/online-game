DebugMode :: true;

LogType :: enum u32 {
    DEBUG;
    INFO;
    WARNING;
    ERROR;
    PANIC;
}

log :: (type: LogType, msg: string, args: ..Any) {
    if type == {
    case .DEBUG;  if !DebugMode {return;}; 
                   print("DEBUG:   ");
    case .INFO;    print("INFO:    ");
    case .ERROR;   print("ERROR:   ");
    case .WARNING; print("WARNING: ");
    case .PANIC;   print("PANIC:   ");
    }
    print(msg, ..args);
    print("\n");
}

debug :: (msg: string, args: ..Any) {
    log(.DEBUG, msg, ..args); 
}

info :: (msg: string, args: ..Any) {
    log(.INFO, msg, ..args); 
}

error :: (msg: string, args: ..Any) {
    log(.ERROR, msg, ..args); 
}

warning :: (msg: string, args: ..Any) {
    log(.WARNING, msg, ..args); 
}

panic :: (msg: string, args: ..Any) {
    log(.PANIC, msg, ..args); 
    exit(1);
}

#import "Basic";
