## VUNMAP(2)

## NAME
	vunmap - Unmap memory pages

## SYNOPSIS
```c
	#include <aqua/vmap.h>

	int vunmap(void* addr, size_t len);
```

## DESCRIPTION
	vunmap() unmaps memory pages from specified address.
	If memory has been unmapped, then its "physical" ownership goes to
	second owner or is unallocated.

## RETURN VALUE
	On succes 0 is returned. On error -1.

## ERRORS
	EINVAL	*addr* is not valid memory pointer
	EINVAL	len is zero


### Copyright (C) 2019 Grzegorz Kociołek (Dark565), devildefu and Szczepan (Firstbober)
