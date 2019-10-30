## WAIT(2)

## NAME
	wait - Wait for a process to exit

## SYNOPSIS
```c
#include <aqua/context.h>
#include <time.h>

int wait(pid_t pid, const timespec* tv);
```

## DESCRIPTION
	wait() block a calling process until selected process will die.

## RETURN VALUE
	On exit, process' exit value is returned.

### Copyright (C) 2019 Grzegorz Kociołek (Dark565), devildefu and Szczepan (Firstbober)
