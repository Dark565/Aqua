## MSGPOLL(2)

## NAME
	msgpoll() - Wait for a message

## SYNOPSIS
```c
	#include <aqua/msg.h>
	#include <aqua/context.h>

	struct aqua_msg_poll_stat {
		int status;
		pid_t sender;
		void* addr;
		size_t msgsize;
	};

	int msgpoll(msg_t msgid, struct aqua_msg_wait_stat *statbuf,
			struct timespec *tv, int flags);
```

## DESCRIPTION
	msgpoll() waits for a message.

	*msgid* means message queue id.

	*statbuf* indicates a pointer to *aqua_msg_wait_stat* structure, wielding
	information about a received message.
	If *statbuf* is NULL, just a pending process count is returned and a information queue is not cleared.

	*tv* is a timeval in which message should be received.
	May be NULL, so then this argument is ignored and function will wait without any time limit.
	If tv->tv_sec and tv->tv_nsec are 0, then msgpoll() returns immadiately.

	*flags* is an integer which may be ORed with flags listed below:

	MSG_POLL_LOCK_ON_LAST
		If a message is the last pending, lock a queue after receiving.

	aqua_msg_poll_stat::status may has following statuses:

	MSG_STATUS_OK_NORMAL
		Everything was transfered OK.

	MSG_STATUS_OK_EMPTY
		Empty message has been transfered.

	MSG_STATUS_ERROR_OVERFLOW
		Queue has been overflowed.

	MSG_STATUS_ERROR_PROTECTION
		Memory page has an invalid protection.

	MSG_STATUS_ERROR_TURNEDOFF
		Message queue is turned off.
		Queues are turned off when *queue_start* and *queue_end* are NULL

## NOTE
	To unlock a queue after it was locked with MSG_LOCK_ON_{LAST,ERROR} or manually, you have to use
	*msgctl(msgid, MSG_SETLOCK, 0)*.

## RETURN VALUE
	On success number of pending messages is returned.
	Current message is in the sum too. If there are no messages pending in specified timeval, 0 is returned.
	If error, -1 is returned and errno is set to error code.
	and errno is set to appriopriate error number.

# ERRORS
	This system call doesn't return any errors.


### Copyright (C) 2019 Grzegorz Kociołek (Dark565), devildefu and Szczepan (Firstbober)
