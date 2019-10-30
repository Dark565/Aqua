## VREMAP(2)

## NAME
	vremap - Remap a memory page

## SYNOPSIS
```c
	#include <aqua/vmap.h>

	void* vremap(void* addr, size_t old_size, size_t new_size,
			int flags, void* new_addr);
```

## DESCRIPTION
	vremap() remaps memory pages.

	*addr* is a starting address.

	*old_size* is an old size of a page.

	*new_size* is a new size of a page.

	*flags* are options for a syscall.
	Can has value as specified below:

	*new_addr* is optional 
	and works only in conjunction with specific flag.

	VREMAP_MOVE
		Remap memory from old virtual address to new.
		If memory cannot be moved into specified position, return an error.

	VREMAP_FIXED
		If specified position is already used, unmap this.

	VREMAP_PHYS_LINEAR
		Try to resize memory in-place, so linear physical address will be chosen.
		If it is not possible, return an error.
		Note: All "physically" shared mappings must be linear and they are automatically resized linearly
			even without this flag.

	If *new_size* is 0 and *new_addr* is not NULL, then mapping is copied into specified position.
	Works only for shared mappings.

## ERRORS
	EINVAL	Arguments had bad values.
	ENOLN	Memory pages are used, so memory cannot be allocated linearly.

## RETURN VALUE
	New address of resized memory pages or NULL if zero.


### Copyright (C) 2019 Grzegorz Kociołek (Dark565), devildefu and Szczepan (Firstbober)
