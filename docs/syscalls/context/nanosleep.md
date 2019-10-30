## NANOSLEEP(2)

## NAME
	nanosleep - Sleep a process

## SYNOPSIS
```c
	#include <time.h>

	int nanosleep(const timespec* time, timespec* rest);
```

## DESCRIPTION
	This syscall waits a time specified in *time*.
	If it was interrupted by calling a message procedure,
	time which rested is saved in *rest* if it is not NULL.

## RETURN VALUE
	On success 0 is returned.

## ERRORS
	EINVAL	*time* is NULL
	EINVAL	*time->tv_nsec* is greater than 1000000000 (one second in ns)

### Copyright (C) 2019 Grzegorz Kociołek (Dark565), devildefu and Szczepan (Firstbober)
