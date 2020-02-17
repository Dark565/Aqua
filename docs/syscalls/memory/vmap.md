## VMAP(2)

## NAME
	vmap - map physical memory into virtual

## SYNOPSIS
```c
	#include <aqua/vmap.h>
	#include <aqua/shmem.h>

	struct aqua_memory_part {
		void* addr;
		size_t len;
	};

	struct aqua_shared_conv {
		pid_t second_owner;
		int shared_prot;
	};

	void *vmap(void *addr, size_t size, int prot, int flags,
		const struct aqua_memory_part *phys_part, 
		const struct aqua_shared_conv *shared_conv);
```

## DESCRIPTION
	vmap() allocates physical memory if required and maps it into virtual memory address suggested by addr.
	If address is used, memory manager rounds it into first free one.

	vmap() takes ORs of following protection flags:
	
	PROT_READ  (0b100)
		Process can read a memory part

	PROT_WRITE (0b010)
		Process can write to a memory part

	PROT_EXEC  (0b001)
		Process can execute a memory part

	PROT_NONE  (0b000)
		Process cannot access a memory part


	vmap() can take following flags:

	VMAP_FIXED
		Map a memory pages into virtual memory address specified exactly by addr.
		addr must be page aligned.
		If it is already mapped by current task, unmap that one.

	VMAP_STACK
		Flag used for creating stacks.
		vmap() creates one additional "control" mapping before requested mapping and sets write protection on this.
		If process will touch mapping before, requested part, kernel will allocate, allow using that part and setup a new "control" page before the new one.

	
	VMAP_PHYS_POINT
		Alloc physical memory part specified in *phys_part for the mapping if possible.
		If allocated area is greater than mapped virtual memory size, vremap(2) will map next virtual pages to unused area.
		If memory is used or cannot be allocated, -1 is returned and *errno is set to ENOMEM.
		Note:
			Not every physical memory part can be allocated, because it belongs to devices and other peripethals.
		  	Only ring 0 and 1 programs can use and alloc that special parts or allow other programs to alloc specific parts in those specific areas.
			See specific driver program if you want to use that special part.
			Also you can't allocate kernel memory. It is area from 0x0 to 0x650000.

	VMAP_LINEAR
		Alloc memory linear. This means, that page 1 will be right after page 2 in physical memory.
		If allocated memory wasn't linear, this would be page 1, page 5, page 2.
		All "physically" shared memory **must** be **linear**.
		VMAP_SHARE uses this flag automatically, so don't worry.

	VMAP_UNSHARE
		Compatibility flag.

	VMAP_SHARE
		Share this mapping.
		What it means exactly is, if another process uses vmap() in conjunction with VMAP_PHYSICAL_POINT on the physical memory part being allocated,
		let it use this part.

		The other process, mapping a shared memory can't set whatever protection it wants.
		Initially shared memory has protection mode as specified in shared_conv->shared_prot
		and process which mapping it, can set the protection with rule: (shared_conv->shared_prot & shared_prot).

		If process who made the memory part shared will die or unmap that part, shared_conv->second_owner will become an memory part owner and
		will be able to set shared protection options with vctl(2).
		If shared_conv->second_owner was 0, then death of the sharing process will unalloc that part.
		If shared_conv->second_owner has invalid PID (because e.g there is no process with that PID), convention is the same like when shared_conv->seconv_owner was 0.

		Shared memory part will be allocated until the last mapper unmaps this.

		If a process uses vmap() without VMAP_PHYS_POINT shared aligment should never be chosen by the kernel.
		Note:
			It was designed to use this flag with MAP_PHYS_POINT, but you can use it even without.
			In this case, to check which physical memory fragment was allocated, use vinfo(2) (see /docs/syscalls/vctl.md).
			Memory fragment which isn't marked with this flag, still can be shared with ask(2) interface (see /docs/syscalls/ask.md).

	VMAP_TERMINATE
		When last process which mapped a memory part will unmap this, fill the memory with zero.

	VMAP_EXCL_FREE
		Make sure, that requested physical memory point isn't yet allocated.
		If it is, errno is set to ENOFREE and -1 is returned.

	VMAP_KERNEL  
		Map kernel memory into specified address.

		Only permission ring 1 and below is permitted.

		If addr is NULL, the memory is mapped into 0xfffffffe00000000 - 0xffffffffffffffff address range.
		Note:
			It is necessary to map kernel memory into above range to be able to validly use kernel functions.
			Kernel memory is like it was allocated with VMAP_SHARE, but only for previleged users.

	VMAP_KERNEL_SPACE
		Alloc a page in the kernel memory.  
		This page will be mapped in each process' virtual memory.
		Kernel page may be SHARED with the convention of VMAP_SHARE, but  
		anyway it is also publicly shared in the range specified in VMAP_KERNEL.  
		Only previleged processes with hardware ring 0 can access this range.


	vunmap() unmaps memory and eventually deallocates it if no more process uses it.
	
## NOTE
	Unlike posix implementation, memory is not cleared in a mapping time, but in unmapping time and it is not necessary to always clear it,
	so clearing is turned off automatically to increase overall performance. 
	If you operate with unsafe data and don't want anyone to look at it later, activate VMAP_TERMINATE flag by vmap() or vctl()!

## EXAMPLE
```c
	#include <stdlib.h>
	#include <stdio.h>
	#include <aqua/vmap.h>
	#include <aqua/shmem.h>

	/* This simple program tries to allocate and map a memory range
	 * equal 2 times current device page size
	 * starting on physical point - 0x1000000, then share it with others with
	 * second memory part owner - process 32.
	 * If it will fail, error message is printed and 1 is returned.

	int main(void)
	{
	
		const size_t pagesize = sysconf(_SC_PAGESIZE);
		const size_t memsize = pagesize * 2;
		
		static struct aqua_memory_part phys_point = {
			.addr = 0x1000000,
			.len = memsize
		};

		static struct aqua_shared_conv sharing_conv = {
			.second_owner = 32,
			.shared_prot = PROT_READ
		};

		void *addr = vmap(NULL, memsize, PROT_WRITE | PROT_READ,
				VMAP_PHYS_POINT | VMAP_SHARE | VMAP_ECXL_FREE,
				&phys_point, &sharing_conv);

		if (addr == NULL) {
			fprintf(stderr, "Cannot allocate physical memory range %p-%p: %m",
				 phys_point.addr, phys_point.addr + memsize);

			return 1;
		}

		memset(addr, 0, memsize);
		vunmap(addr, memsize);

		return 0;

	}
```
