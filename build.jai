 #run {
    set_build_options_dc(.{do_output = false});

    sw := compiler_create_workspace("Server workspace");
    if !sw {
        print("ERROR: Could not create server workspace\n");
        return;
    }
    {
        print("Compiling server...\n");
        options := get_build_options(sw);
        options.output_type = .EXECUTABLE;
        options.output_path = "./server/";
        options.output_executable_name = "server";
        set_build_options(options, sw);
        add_build_file(tprint("%/server/server.jai", #filepath), sw);
    }


    cw := compiler_create_workspace("Client workspace");
    if !cw {
        print("ERROR: Could not create client workspace\n");
        return;
    }
    {
        print("Compiling client...\n");
        options := get_build_options(cw);
        options.output_type = .EXECUTABLE;
        options.output_path = "./client/";
        options.output_executable_name = "client";
        set_build_options(options, cw);
        add_build_file(tprint("%/client/client.jai", #filepath), cw);
    }

 }


 #import "Basic";
 #import "Compiler";
