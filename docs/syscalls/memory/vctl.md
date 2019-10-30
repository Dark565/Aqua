## VCTL(2)

## NAME
	vctl - Control a memory page

## SYNOPSIS
```c
	#include <aqua/vmap.h>

	long vctl(void* addr, int option, ...);
```

## DESCRIPTION
	vctl() sets or gets memory page options.

	VCTL_GET_SHARING_STATUS (void)
		Sharing status may be as follows:
		0 - Unshared (private)
		1 - Locally shared
		2 - "Physically" shared (memory must be linear)

	VCTL_GET_SHARED_CONV (const struct aqua_shared_conv*)
		Get a sharing convention for a page.

	VCTL_GET_MANGLED_PAGES_COUNT (void)
		Get pages which are not-linear placed in a physical memory.

	VCTL_GET_PHYS_ADDRESS (void)
		Get physical address of a virtual page.

	VCTL_GET_PHYS_LINEAR_SIZE (size_t)
		Get linear size of reserved physical memory for specified pages.

	VCTL_GET_PARTNERS_COUNT (void)
		Get count of all processes sharing the same memory part.

	VCTL_GET_PARTNERS_LIST (pid_t*)
		Save all processes which share the same page into the list/

	VCTL_SET_SHARED_CONV (struct aqua_shared_conv*)
		Set a sharing convention for a page.

	VCTL_SET_SHARING_STATUS (int)
		Set a sharing status to one of presented in VCTL_GET_SHARING_STATUS.

	VCTL_SET_TERMINATE (int)
		Set termination flag to 1 or 0.

## RETURN VALUE
	Valid value is returned basing on selected option.

### Copyright (C) 2019 Grzegorz Kociołek (Dark565), devildefu and Szczepan (Firstbober)
