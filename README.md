# LibC version hack

If you have a binary that's been built against a modern libc.so.6 the ELF file will probably fail to run. It's possible to modify the binary to replace the version with a "weak" reference. The error message will still be printed, but it won't kill the program when it's run.

This script implements the process [outlined by James B](http://www.lightofdawn.org/wiki/wiki.cgi/NewAppsOnOldGlibc).

It's probably a bad idea to use this script. It's an ugly hack; it implements a hex editor in the shell... 

# Example/Usage

Run the script on a target ELF file. The patched version will be placed in file.patched.

    $ ./main
    ./main: /lib64/libc.so.6: version `GLIBC_2.14' not found (required by ./main)
    
    $ ./glib_version_hack.sh main
    Going to patch main: 
    .gnu_version_r table (@ 938)
    ----> GLIBC_2.14 (@ 30)
    Offset 96D
    
    # chmod +x main.patched
    
    $ ./main.patched
    ./main.patched: /lib64/libc.so.6: weak version `GLIBC_2.14' not found (required by ./main.patched)
    [libmboard] Version        : 0.3.1 (SERIAL)
    [libmboard] Build date     : Tue Dec 15 13:25:36 UTC 2015
    [libmboard] Config options :  '--disable-parallel' '--disable-tests'
    [libmboard] +++ This is a DEBUG version +++
    [libmboard] <settings> MBOARD_MEMPOOL_RECYCLE = 0 (default)
    [libmboard] <settings> MBOARD_MEMPOOL_BLOCKSIZE = 512 (default)
    ...
  
