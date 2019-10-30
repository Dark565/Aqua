## MSGSND(2)

## NAME
	msgsnd - Send a message

## SYNOPSIS
```c
#include <aqua/msg.h>
#include <time.h>

long msgsnd(pid_t pid, msg_t msgid, void* data,
	size_t len, const struct timespec* tv, int flags);
```

## DESCRIPTION
	msgsnd() sends a message to a queue.

	*pid* is a PID of a process wielding a specified memory queue.

	*msgid* is a queue id.

	*data* is a pointer to data.
	If this value is NULL, empty advisory message will be sent to a process.
	Note: Process doesn't have a responsibility to catch these signals.

	*len* is a count of bytes to transfer.

	*tv* is a time in which message should be sent.
	if *tv* is NULL, there is no time limit.
	if *tv->tv_sec* and *tv->tv_nsec* are 0, then this call returns immadiately.

	*flags* is control flags. Can be ORed with values specified below:

	MSG_SND_WAIT_ON_ERROR
		Wait on an error, instead of returning the error immadiately.

	MSG_SND_GET_MSG_SIZE
		Instead of sending a message, just get the limit of message size
		for specified message queue.
		When this flag is on, *data*, *len* and *tv* are ignored.

	MSG_SND_CUTOFF
		If a message is too large, cut it to the suitable size.

## RETURN VALUE
	Number of transfered bytes.

## ERRORS
	EINVAL	*len* is zero.
	EINVAL	*data* points to an invalid memory address.
	EINVAL	*flags* has an invalid value.
	ENOPROC	Specified *pid* doesn't exist.
	EAGAIN	Error has occured when trying to send a massage.
	EOFF	Message queue is not active.

### Copyright (C) 2019 Grzegorz Kociołek (Dark565), devildefu and Szczepan (Firstbober)
