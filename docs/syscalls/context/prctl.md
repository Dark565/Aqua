## PRCTL(2)

## NAME
	prctl - Control a process

## SYNOPSIS
```c
#include <aqua/context.h>

long prctl(int option, ...);
```

## DESCRIPTION
	prctl() sets or gets process configuration.
	It takes following options:

	PRCTL_SET_LOCAL_SEGS (const struct aqua_local_seg_count[3])
		Set local segments (es/fs/gs).

	PRCTL_SET_IDENTIFIER (const char*)
		Set process identifier.

	PRCTL_GET_ACTIVE_MSG_QUEUES_COUNT (void)
		Get a count of active msg queues.

	PRCTL_GET_ACTIVE_MSG_QUEUES_LIST (msg_t*)
		Get a list of active msg queues.

## RETURN VALUE
	Valid value is returned basing on an option.
	If error has occured, then -1 is returned.

## ERRORS
	EINVAL	Pointer to aqua_local_seg_count is NULL or has invalid data.
	EINVAL	Identifier passed to PRCTL_SET_IDENTIFIER is NULL.
	EINVAL	Cannot save a list using PRCTL_GET_ACTIVE_MSG_QUEUES_LIST, because of memory error.

### Copyright (C) 2019 Grzegorz Kociołek (Dark565), devildefu and Szczepan (Firstbober)
