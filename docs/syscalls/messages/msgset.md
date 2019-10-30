## MSGSET(2)

## NAME
	msgset() - Set up a message queue

## SYNOPSIS
```c
	#include <aqua/msg.h>
	#include <aqua/context.h>

	struct aqua_msg_configuration {
		int flags;
		pid_t *pids_filter;
		size_t pids_filter_size;
		size_t max_pending;
	};

	int msgset(msg_t msgid, void *queue_start, void *queue_end,
		size_t msg_size, struct aqua_msg_configuration *config);
```

## DESCRIPTION
	msgset() creates, deletes or changes a message queue for specified *msgid* and memory address.
	When queue will overflow, managing process has a responsibility to set its index back.

	*msgid* indicates queue id. It is a value from 0 to (2^64)-1.

	*queue_start* is a pointer to first byte of a queue.

	*queue_end* is a pointer to last+1 byte of a queue.

	*msg_size* is a message maximal size.
	
	*config* is a pointer to configuration structure. It has:
		*flags* 		- integer variable which takes ORs of flags specified below,
		*pids_filter* 		- pointer to array of pid_t variables specifing processes to be filtered,
		*pids_filter_size*	- size of an array specified above,
		*max_pending*		- how many requests can wait to be polled at the same time.
	If *config* is NULL, then this argument is ignored.

	It can be changed later with *msgctl(msgid, MSG_SET_CONFIG, config)*,
	where config is a pointer to *aqua_msg_configuration*.

	If *queue_start* is random non-zero number and *queue_end* is NULL,
	then all transfered data are terminated and only thing which poller receives
	is information about a sender.

	If both of queue_* variables are NULL, then sending message to this queue will give the same behavior as
	sending messages when a queue is overflowed or has a memory error.
	Note, that setting a queue to this state will disable it and free its in-kernel data.
	All queues has following state at the beginning.

	If pending limit was exceeded, then sender will block.
	If limit was specified as 0, then limiting is turned off and maximal count is unspecified.

	Here are flags for config->flags:

	MSG_FL_LOCK_ON_ERROR
		If any memory error will occur on a queue, lock polling them as with MSG_LOCK_ON_LAST.

	MSG_FL_RCV_ERROR
		Let also errors to be in pending cache.

	MSG_FL_RCV_EMPTY
		Cache also empty message informations.
		Message is empty, when data pointer passed to msgsnd was NULL.

	MSG_FL_BLACKLIST
		PIDs specified in address starting with *pids_filter* are **blacklisted**,
		so they can't send a message to specified message queue.

	MSG_FL_WHITELIST
		Opposite of MSG_BLACKLIST. PIDs are **whitelisted**,
		so only they can send a message to specified message queue.

	MSG_FL_MEMORY_EXPAND
		Do not return an error when memory for a queue will overflow, but
		reserve new memory and map it past the queue if there is that possibility.
		Queue size as returned from *msgctl(msgid, MSG_GET_QSIZE, 0)* will be summarized
		with new reserved memory size.

## RETURN VALUE
	If success, 0 is returned, otherwise -1 and errno has one of errors specified below.

## ERROR
	ENOPERM		Memory referenced by *queue* is not write permitted
	EINVAL		*queue_end* points to byte placed lower than *queue_start*

## EXAMPLE
```c
	#include <aqua/msg.h>
	#include <aqua/context.h>
	#include <aqua/vmap.h>
	#include <stdio.h>

	#define _ERROR(x,...) { fprintf(stderr, x"\n", __VA_ARGS__); exit(1); }

	int main(void)
	{
		int err;
		void* queue_mem;
		const size_t psize = sysconf(_SC_PAGESIZE);
		const size_t queue_size = psize * 4;

		static struct aqua_msg_configuration queue_conf = {
			.flags = MSG_FL_LOCK_ON_ERROR
		};

		queue_mem = vmap(NULL, queue_size, PROT_READ | PROT_WRITE,
				VMAP_UNSHARE | VMAP_TERMINATE);
		
		if (queue_mem == NULL)
			_ERROR("Cannot allocate a memory for a queue: %m");

		err = msgset(10, queue_mem, queue_mem+queue_size, 1<<8, NULL);

		if (err == -1)
			_ERROR("Cannot set a queue: %m");

		struct aqua_msg_poll_stat poll_stat;

		while ((pending_count = msgpoll(10, &poll_stat, MSG_POLL_LOCK_ON_LAST)) > 0) {

			printf("Gotten a message.\n
				Size: %llu,\n
				Pending: %llu,\n
				Message start: %p\n\n",
				poll_stat.msgsize, pending_count, poll_stat.addr);

			if(pending_count == 0) {
				printf("This message was the last pending! Setting a queue back.\n
					It will let %lu blocked guests introduce themselves.\n\n",
					msgctl(10, MSG_GET_BLCK_REQ_COUNT));

				msgctl(10, MSG_SET_CUR_POINTER, queue_mem);
			}

			putc('\n');
		}

	}
```




### Copyright (C) 2019 Grzegorz Kociołek (Dark565), devildefu and Szczepan (Firstbober)
