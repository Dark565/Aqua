## IDENTIFIER_pid(2)

## NAME
	identifier_pid - Get a process with specified identifier

## SYNOPSIS
```c
	#include <aqua/identifiy.h>

	pid_t identifier_pid(const char* identifier, int index);
```

## DESCRIPTION
	identifier_pid() returns a task id which has specified identifier.
	Of many, one with index is chosen.
	If index is zero, then count of all tasks with specified identifier is returned.

## ERRORS
	ENOENT *index* is invalid.
	ENOENT *identifier* is invalid.

### Copyright (C) 2019 Grzegorz Kociołek (Dark565), devildefu and Szczepan (Firstbober)
