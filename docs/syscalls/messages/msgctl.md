## MSGCTL(2)

## NAME
	msgctl - Control a message queue

## SYNOPSIS
```c
#include <aqua/msg.h>

long msgctl(msg_t msgid, long option, ...);
```

## DESCRIPTION
	msgctl() lets user to control a message queue.
	It specifies following flags:

	There are taken types in brackets

	MSG_GET_MSGSIZE (void)
		Get a limit size of a message.

	MSG_GET_CUR_POINTER (void)
		Get a pointer of a current queue byte.

	MSG_GET_END_POINTER (void)
		Get a pointer of a last+1 queue byte

	MSG_GET_CONFIG (struct aqua_msg_configuration*)
		Get queue config as specified for msgset().

	MSG_GET_BLCK_REQ_COUNT (void)
		Get a count of requests which are blocked in order to wait
		for a message queue to be available.

	MSG_SET_MSGSIZE (size_t)
		Set a size of queue.

	MSG_SET_CUR_POINTER (void*)
		Set a pointer of current queue byte.

	MSG_SET_END_POINTER (void*)
		Set a pointer of last queue byte.

	MSG_SET_CONFIG (const struct aqua_msg_configuration*)
		Set queue config.

	MSG_FLUSH_PENDING (void)
		Flush an information buffer.

	MSG_SETLOCK(int)
		Set a lock for a queue.
		This flag can take following modes:
		0 	Unlock a queue;
		1	Lock a queue;
		2	Get the current lock.

## NOTE
	Do not make blocks like:
```c
msgctl(msgid, MSG_SET_CUR_POINTER, x);
msgctl(msgid, MSG_SET_END_POINTER, y);
msgctl(msgid, MSG_SET_MSGSIZE, z);
msgctl(msgid, MSG_SET_CONFIG, w);
```
	but instead do:
```c
msgset(msgid, x, y, z, w);
```
	which will do the same job in shorter time.
	Those function are in msgctl for a fast control, but *don't exaggerate!*

## ERRORS
	EINVAL	Pointer set by MSG_SET_END_POINTER points to byte placed lower than byte set by MSG_SET_CUR_POINTER (but is not NULL)
	EINVAL	Value passed for MSG_SETLOCK is not in range [0-2].

## RETURN VALUE
	On success value proprietary of a chosen flag is returned.

## EXAMPLE


### Copyright (C) 2019 Grzegorz Kociołek (Dark565), devildefu and Szczepan (Firstbober)
