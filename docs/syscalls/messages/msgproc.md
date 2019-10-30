## MSGPROC(2)

## NAME
	msgproc - Register an asynchronous function for catching messages

## SYNOPSIS
```c
	#include <aqua/msg.h>
	#include <aqua/async.h>

	int msgproc(msg_t msgid,
		void(*handler)(msg_t msgid, struct aqua_msg_poll_stat* stat, int pending_count, struct regs_t* cxt), 
		int flags);
```
## DESCRIPTION
	msgproc() registers a function handler for catching messages.

	*msgid* is an id of a message queue.

	*handler* is a handler for messages.
		Handler takes following arguments:

		*msgid* - id of a message queue from which a message is from.
		*stat* - pointer to message information.
		*pending_count* - count of signals, which are waiting to be received.
		*cxt* - saved process context

	*flags* has option bits as shown below:

	MSG_POLL_BLOCK_ON_LAST
		If handled signal is last pending, block a queue.

## RETURN VALUE
	If everything succeed, this function return 0, otherwise -1.

## ERRORS
	EINVAL	Invalid flags were specified.

### Copyright (C) 2019 Grzegorz Kociołek (Dark565), devildefu and Szczepan (Firstbober)
