## IDENTIFIER_get(2)

## NAME
	identifier_get - Get an identifier

## SYNOPSIS
```c
	#include <aqua/identify.h>

	size_t identifier_get(char* identifier, int index);
```

## DESCRIPTION
	identifier_get() fills *identifier* with name of the identifier in index.
	If *identifier* or *index* are NULL, the function returns count of all identifiers.

## ERRORS
	EINVAL	*identifier* points on invalid memory.
	ENOENT	*index* is invalid.

### Copyright (C) 2019 Grzegorz Kociołek (Dark565), devildefu and Szczepan (Firstbober)
