## MSGPROC_RET(2)

## NAME
	msgproc_ret - Return from a asynchronous procedure

## SYNOPSIS
	```c

	void msgproc_ret(void);
	```

## DESCRIPTION
	Warning!
	This function may be called *only* without changing rbp, so direct from assembly as syscall!!

```as
mov rax, 21 //__AQUA_SYSNO_MSGPROC_RET
syscall
```

	You can call this using __asm__ in C. Never create new stack frames when you calling this function, because
	it uses rbp as a pointer to last byte of saved context.


	This syscall restores previous process context saved before calling installed message procedure.


## RETURN VALUE
	This syscall never returns


### Copyright (C) 2019 Grzegorz Kociołek (Dark565), devildefu and Szczepan (Firstbober)
