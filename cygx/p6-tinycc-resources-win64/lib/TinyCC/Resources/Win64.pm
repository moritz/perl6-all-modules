BEGIN {
    my \PREFIX = $*VM.config<prefix>.IO;
    %?RESOURCES{"bin/libtcc.dll"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("bin/libtcc.dll");
    %?RESOURCES{"include/_mingw.h"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("include/_mingw.h");
    %?RESOURCES{"include/assert.h"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("include/assert.h");
    %?RESOURCES{"include/conio.h"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("include/conio.h");
    %?RESOURCES{"include/ctype.h"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("include/ctype.h");
    %?RESOURCES{"include/dir.h"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("include/dir.h");
    %?RESOURCES{"include/direct.h"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("include/direct.h");
    %?RESOURCES{"include/dirent.h"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("include/dirent.h");
    %?RESOURCES{"include/dos.h"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("include/dos.h");
    %?RESOURCES{"include/errno.h"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("include/errno.h");
    %?RESOURCES{"include/excpt.h"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("include/excpt.h");
    %?RESOURCES{"include/fcntl.h"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("include/fcntl.h");
    %?RESOURCES{"include/fenv.h"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("include/fenv.h");
    %?RESOURCES{"include/float.h"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("include/float.h");
    %?RESOURCES{"include/inttypes.h"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("include/inttypes.h");
    %?RESOURCES{"include/io.h"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("include/io.h");
    %?RESOURCES{"include/libtcc.h"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("include/libtcc.h");
    %?RESOURCES{"include/limits.h"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("include/limits.h");
    %?RESOURCES{"include/locale.h"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("include/locale.h");
    %?RESOURCES{"include/malloc.h"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("include/malloc.h");
    %?RESOURCES{"include/math.h"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("include/math.h");
    %?RESOURCES{"include/mem.h"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("include/mem.h");
    %?RESOURCES{"include/memory.h"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("include/memory.h");
    %?RESOURCES{"include/process.h"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("include/process.h");
    %?RESOURCES{"include/sec_api/conio_s.h"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("include/sec_api/conio_s.h");
    %?RESOURCES{"include/sec_api/crtdbg_s.h"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("include/sec_api/crtdbg_s.h");
    %?RESOURCES{"include/sec_api/io_s.h"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("include/sec_api/io_s.h");
    %?RESOURCES{"include/sec_api/mbstring_s.h"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("include/sec_api/mbstring_s.h");
    %?RESOURCES{"include/sec_api/search_s.h"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("include/sec_api/search_s.h");
    %?RESOURCES{"include/sec_api/stdio_s.h"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("include/sec_api/stdio_s.h");
    %?RESOURCES{"include/sec_api/stdlib_s.h"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("include/sec_api/stdlib_s.h");
    %?RESOURCES{"include/sec_api/stralign_s.h"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("include/sec_api/stralign_s.h");
    %?RESOURCES{"include/sec_api/string_s.h"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("include/sec_api/string_s.h");
    %?RESOURCES{"include/sec_api/sys/timeb_s.h"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("include/sec_api/sys/timeb_s.h");
    %?RESOURCES{"include/sec_api/tchar_s.h"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("include/sec_api/tchar_s.h");
    %?RESOURCES{"include/sec_api/time_s.h"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("include/sec_api/time_s.h");
    %?RESOURCES{"include/sec_api/wchar_s.h"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("include/sec_api/wchar_s.h");
    %?RESOURCES{"include/setjmp.h"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("include/setjmp.h");
    %?RESOURCES{"include/share.h"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("include/share.h");
    %?RESOURCES{"include/signal.h"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("include/signal.h");
    %?RESOURCES{"include/stdarg.h"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("include/stdarg.h");
    %?RESOURCES{"include/stdbool.h"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("include/stdbool.h");
    %?RESOURCES{"include/stddef.h"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("include/stddef.h");
    %?RESOURCES{"include/stdint.h"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("include/stdint.h");
    %?RESOURCES{"include/stdio.h"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("include/stdio.h");
    %?RESOURCES{"include/stdlib.h"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("include/stdlib.h");
    %?RESOURCES{"include/string.h"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("include/string.h");
    %?RESOURCES{"include/sys/fcntl.h"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("include/sys/fcntl.h");
    %?RESOURCES{"include/sys/file.h"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("include/sys/file.h");
    %?RESOURCES{"include/sys/locking.h"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("include/sys/locking.h");
    %?RESOURCES{"include/sys/stat.h"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("include/sys/stat.h");
    %?RESOURCES{"include/sys/time.h"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("include/sys/time.h");
    %?RESOURCES{"include/sys/timeb.h"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("include/sys/timeb.h");
    %?RESOURCES{"include/sys/types.h"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("include/sys/types.h");
    %?RESOURCES{"include/sys/unistd.h"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("include/sys/unistd.h");
    %?RESOURCES{"include/sys/utime.h"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("include/sys/utime.h");
    %?RESOURCES{"include/tcc/tcc_libm.h"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("include/tcc/tcc_libm.h");
    %?RESOURCES{"include/tcclib.h"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("include/tcclib.h");
    %?RESOURCES{"include/tchar.h"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("include/tchar.h");
    %?RESOURCES{"include/time.h"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("include/time.h");
    %?RESOURCES{"include/vadefs.h"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("include/vadefs.h");
    %?RESOURCES{"include/values.h"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("include/values.h");
    %?RESOURCES{"include/varargs.h"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("include/varargs.h");
    %?RESOURCES{"include/wchar.h"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("include/wchar.h");
    %?RESOURCES{"include/wctype.h"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("include/wctype.h");
    %?RESOURCES{"include/winapi/basetsd.h"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("include/winapi/basetsd.h");
    %?RESOURCES{"include/winapi/basetyps.h"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("include/winapi/basetyps.h");
    %?RESOURCES{"include/winapi/guiddef.h"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("include/winapi/guiddef.h");
    %?RESOURCES{"include/winapi/poppack.h"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("include/winapi/poppack.h");
    %?RESOURCES{"include/winapi/pshpack1.h"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("include/winapi/pshpack1.h");
    %?RESOURCES{"include/winapi/pshpack2.h"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("include/winapi/pshpack2.h");
    %?RESOURCES{"include/winapi/pshpack4.h"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("include/winapi/pshpack4.h");
    %?RESOURCES{"include/winapi/pshpack8.h"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("include/winapi/pshpack8.h");
    %?RESOURCES{"include/winapi/winbase.h"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("include/winapi/winbase.h");
    %?RESOURCES{"include/winapi/wincon.h"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("include/winapi/wincon.h");
    %?RESOURCES{"include/winapi/windef.h"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("include/winapi/windef.h");
    %?RESOURCES{"include/winapi/windows.h"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("include/winapi/windows.h");
    %?RESOURCES{"include/winapi/winerror.h"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("include/winapi/winerror.h");
    %?RESOURCES{"include/winapi/wingdi.h"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("include/winapi/wingdi.h");
    %?RESOURCES{"include/winapi/winnt.h"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("include/winapi/winnt.h");
    %?RESOURCES{"include/winapi/winreg.h"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("include/winapi/winreg.h");
    %?RESOURCES{"include/winapi/winuser.h"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("include/winapi/winuser.h");
    %?RESOURCES{"include/winapi/winver.h"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("include/winapi/winver.h");
    %?RESOURCES{"lib/chkstk.S"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("lib/chkstk.S");
    %?RESOURCES{"lib/crt1.c"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("lib/crt1.c");
    %?RESOURCES{"lib/crt1w.c"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("lib/crt1w.c");
    %?RESOURCES{"lib/dllcrt1.c"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("lib/dllcrt1.c");
    %?RESOURCES{"lib/dllmain.c"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("lib/dllmain.c");
    %?RESOURCES{"lib/gdi32.def"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("lib/gdi32.def");
    %?RESOURCES{"lib/kernel32.def"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("lib/kernel32.def");
    %?RESOURCES{"lib/libtcc1-32.a"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("lib/libtcc1-32.a");
    %?RESOURCES{"lib/libtcc1-64.a"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("lib/libtcc1-64.a");
    %?RESOURCES{"lib/msvcrt.def"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("lib/msvcrt.def");
    %?RESOURCES{"lib/user32.def"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("lib/user32.def");
    %?RESOURCES{"lib/wincrt1.c"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("lib/wincrt1.c");
    %?RESOURCES{"lib/wincrt1w.c"}.copy(.parent.mkdir.child(.basename)) given PREFIX.child("lib/wincrt1w.c");
}
