## SETPERM(2)

## NAME
	setperm - Set current process permission level

## SYNOPSIS
```c
	#include <aqua/perms.h>

	int setperm(int perm);
```

## DESCRIPTION
	setperm() sets application permission ring to a selected.
	Higher rings can choose lower ring.
	Lower ring cannot choose higher ring.

## RETURN VALUE
	On success 0 is returned, on error -1.

## ERRORS
	EPERM	Operation not permitted.


### Copyright (C) 2019 Grzegorz Kociołek (Dark565), devildefu and Szczepan (Firstbober)
