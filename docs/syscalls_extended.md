# Extended syscalls

Aqua doesn't have only those syscalls defined in syscalls.md.  
Each program running in the system which has permission level 0 can define its own syscall.  
This syscall's procedure must be placed in the kernel virtual space.  
Definition of 'syscall' word in Aqua philosophy is "A function placed in the kernel virtual memory, called from the user space".  
To make private or public mapping be placed in the kernel virtual area, one can use `vmap(2)` with flag VMAP_KERNEL_SPACE.  
Example syscalls registered by user processes:  

- `clock_gettime(2)` defined by 0:time

- `open(2)`, `read(2)`, `write(2)` and the rest of posix syscalls defined by 0:fs and others

- `shutdown(2)` defined by 0:powerctl


These all syscalls are callable from one kernel syscall: `oscall(2)`.  
Each such syscall is defined in a syscall array, which itself is defined in the syscall array table  
So for example to call posix open, you do such thing:
```c
#include <aqua/oscall.h>

/* These definitions are in <aqua/oscall.h> and <aqua/unix.h> but I wrote them here,
 * to show how it works better */

typedef uint64_t oscall_vec;
#define OSCALL_UNIX 1 /* Unix's array index in the syscall array table is 1 */
#define UNIX_WRITE_NR 1 /* Syscall's number of write syscall */

int main(void)
{
	int fd = 1;
	const char *str = "Hello, world!"
	size_t size = strlen(str);

	struct oscall_vec args[3] = {fd, str, size};
	oscall(OSCALL_UNIX, UNIX_WRITE_NR, args, 3); /* Now, this call will execute UNIX_WRITE_NR syscall defined in OSCALL_UNIX syscall array */
}
```

User can also set default syscall namespace, exactly namespace array, and call it directly using syscall instruction.  
There is one special syscall - `-2`. It is a link for kernel's prctl(2) syscall. It is linked like this to allow process to return to previous syscall array.
Here is the code for switching current working arrays:
```c
#include <aqua/oscall.h>
#include <aqua/prctl.h>

int main(void)
{
	int fd = -1;
	const char *str = "Hello, world!"
	size_t size = strlen(str);

	uint32_t prev_sysarray = prctl(SET_SYSCALL_ARRAY, OSCALL_UNIX);
	syscall(UNIX_WRITE_NR, fd, str, size);

}
```

This switching is very useful when implementing compatibility layer for any other OS.
For example, process can set the current syscall array to LINUX's and because of it, be able to call any Linux program
or implement NT's syscalls and be able to call Windows programs.
