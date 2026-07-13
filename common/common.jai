DebugMode :: true;

LogType :: enum u32 {
    DEBUG;
    INFO;
    WARNING;
    ERROR;
    FATAL;
}

log :: (type: LogType, msg: string, args: ..Any) {
    if type == {
    case .DEBUG;  if !DebugMode {return;}; 
                   print("DEBUG:   ");
    case .INFO;    print("INFO:    ");
    case .ERROR;   print("ERROR:   ");
    case .WARNING; print("WARNING: ");
    case .FATAL;   print("FATAL:   ");
    }
    print(msg, ..args);
    print("\n");
}

panic :: (msg: string, args: ..Any) {
    log(.FATAL, msg, ..args); 
    exit(1);
}
