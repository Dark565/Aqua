# List of Aqua microkernel syscalls

## Exact desciptions what specific syscall does are in /docs/syscalls directory

| Name				| Description
| ---				| ---
| **Context management:**	|
| exit(2)			| Exit the program with error code and free its resources
| clone(2)			| Clone a task
| makecxt(2)			| Create a new task context
| wait(2)			| Wait for a task to exit
| prctl(2)			| Set or get a process config (like identifier)
| getpid(2)			| Get current process id
| nanosleep(2)			| Sleep a task
|				|
| **Task identification:**	|
| identifier_list(2)		| Get list of identifiers
| identifier_entry(2)		| Get tasks of specific identifier
|				|
| **Permissions**		|
| setperm(2)			| Set current process permission (0-3)
| refperm(2)			| Refresh process capabilities
|				|
| **Memory management:**	|
| vmap(2)			| Allocate and map physical memory into virtual
| vremap(2)			| Remap existing mapping
| vunmap(2)			| Unmap existing mapping
| vctl(2)			| Set a memory page settings
|				|
| **Messages mechanism:**	|
| msgcreat(2)			| Create a message queue for specified signal on specified memory page
| msgwait(2)			| Wait for a message from specified or all signals
| msgsnd(2)			| Send a meesage to a task
| msgrm(2)			| Remove a message queue from specified page
| msgproc(2)			| Install a procedure which will be called on messaging specified signal
| msgproc_ret(2)		| Return from a msg procedure
|				|
| **Other:**			|
| clock_gettime(2)		| Get a time ***For tests only. For getting a time there is a task: 0:timer in Aqua OS***



### Note
- As you can see, there are extremely little syscalls - 21 (without clock_gettime). They are only for those basic operations without which, communication shouldn't be possible. 
  Everything other is done using other tasks, because kernel must be as smallest as possible.
  To be honest, even all *Context Management* functions would be out of the syscall interface, but they are very important and always should be in a kernel.  
  The syscall count may be changed in the future.

- wait(2) interface can wait for each user program, unlike in posix implementation, which can wait only for childs or traced process.  
  This is because, there are not ptrace(2) in the kernel, not like in posix (Well, it actually is, but out of the kernel) and putting waiting for others in wait(2) is a good idea here.
  A process can wait for itself. In this case, it will be sleeped until it will be killed.

- There are no sigaction(2) and kill(2) syscalls, because signals interface are implemented with msg\* family.

- Using setperm(2), higher permission ranks can set their ranks to lower, but not vice versa. To restore the permission, process have to ask permission managing program, so be aware,  
  because, if a driver program will decrease its rank, it will lose its capabilities.

- refperm(2) has a sense in situations when a task with high permissions manually threw his capabilities.  
  Lets get the following example: process with permission level 0 unmapped kernel memory and changed its physical ring to 3.  
  Now if it wants to restore physical ring - 0, it's enough to call refperm(2).

- When a signal calls a function registered via msgproc(2) - wait(2), msgwait(2) and sleep(2) syscalls are interrupted.
  They can be restarted if SIG_SYSRESTART was specified in sig_async(2) flags argument.

- Virtual memory range 0x0 - 0x650000 is reserved for the kernel.  
You can't map this, unless you use VMAP_KERNEL as flag for vmap(2), which is used to map whole kernel memory into this range. See /docs/syscalls/vmap.md  
BE AWARE! The range can be changed in future kernel releases, but honestly I don't predict this.
