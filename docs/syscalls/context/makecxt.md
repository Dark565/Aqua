## MAKECXT(2)

## NAME
	makecxt - Create a new context (process)

## SYNOPSIS
```c
	#include <aqua/context.h>

	#define _AQUA_SEG_ES 0
	#define _AQUA_SEG_FS 1
	#define _AQUA_SEG_GS 2

	struct aqua_makecxt_data {
		regs_t registers;
		struct aqua_local_seg_conf segs_conf[3];
	};

	pid_t makecxt(void* destination, void* src, size_t refsize
			const struct aqua_makecxt_data* cxt, pid_t pid, int flags);
```

## DESCRIPTION
	makecxt() creates a new process.

	*destination* is a memory place on which virtual memory pages will be
	copied/referenced from local process.

	*src* is a local memory point.

	*refsize* indicates how many bytes, you want to proceed.

	*cxt* is a starting process context.
	It wields also *segs_conf* what is used to install local segments.

	*pid* is a PID a new process should gain if there is that possibility.

	*flags* are flags for a syscall as specified below:

	MAKECXT_SHARE_VMEM
		Share the whole virtual memory of a local process with created process.
		When the whole virtual memory is shared,
		then shared pages (as made with VMAP_SHARE or directly with vctl(2)) have multiple owners.
		And ownership of the shared memory page will be passed to second owner only after
		all first-place owners will die. It can be compared to a familiy.
		When someone creates a family with other one, they will share their treasures.
		When they both will die, the country will take it and it's all over.

	MAKECXT_COPY_SHARED
		Reserve new space in created process for all sharable pages in local process and
		copy data from these pages to new process' pages and share them locally.
		This flag can't be conjuncted with MAKECXT_SHARE_VMEM, because it will be ignored.

	MAKECXT_COPY_CONTEXT | MAKECXT_FORK
		Copy a context from a calling process, with following exceptions:
		a) rip is increased with 2;
		b) rax value is set to 0.
		This flag makes, that *cxt* argument is no longer needed.

	MAKECXT_FIXED_PID
		Pid must be exactly as given.
		If not, return an error.

	MAKECXT_FIXED_MOVE
		Ensure that all pages were copied/referenced and none of them met an error.

	MAKECXT_INSTALL_LOCAL_SEGMENTS
		This flag lets user to set segments: es/fs/gs to any value.
		They can be used to point local thread variables.
		Segment configs are in array *cxt->segs_conf*

## RETURN VALUE
	Return value is a PID of the new process or -1 if something went wrong.

## ERRORS
	EEXIST	Selected pid already exists. (only with MAKECXT_FIXED_PID)
	EINVAL	Selected destination, src or cxt are NULL.
	EINVAL	refsize is 0.
	EINVAL	Invalid flags were passed.
	EEGAIN	Not all pages have been moved correctly.

## EXAMPLE
```c
#include <aqua/context.h>
#include <stdio.h>

int main(void) {

	pid_t new_proc = makecxt(0, 0, -1, NULL, 0, MAKECXT_COPY_CONTEXT);

	printf("Calling from process: %u\n", getpid());
}
```
RESULT:
```
Calling from process: 151
Calling from process: 152
```

### Copyright (C) 2019 Grzegorz Kociołek (Dark565), devildefu and Szczepan (Firstbober)
