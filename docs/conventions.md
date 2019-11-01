# Kernel Conventions
This markdown presents all conventions you should apply in your pull requests.
If your request doesn't have any of the presented convention, we won't accept it (even if code is good), until you fix it.


## Coding style
### Formalities:
- Don't use C++ and other languages for kernel source code, **but C with C11 standard**
- Unless it is OS. Here you can write in each language you want and then (!) our coding style isn't required, exclude C. We honor C
- Don't write spaghetti code, what I mean is, create as little as you can useless labels, which you can merge into one function
- Do not use ugly words
- Comment briefly what your functions do

### Naming:
- All function and struct names should be snake_case
- Names of definitions are always UPPER_CASE

### Formatting:
- In functions, opened curly bracket is always under function declaration
- In scopes, like while, for, switch and even structs, opened curly bracket is always after scope declaration
- Local variable in functions are always declared on the beginning of the function definition
- If your function gets a lot of arguments, split it into multiple lines
- For previous point, put maximally double TAB in next argument lines instead of tabbing until you'll get position after '('
- Use TAB for scoping, instead of SPACE


### Example:

```c
void check_whether_day_is_good(struct the_world_current_time *tm,
		int possibility_of_good_day,
		int possibility_of_bad_day)
{
	float sum_poss = (float)(possibility_of_good_day + possibility_of_bad_day);

	if ((float)(possibility_of_good_day / sum_poss) >= 0.5) {
		printk("Day %s is seriously very good! Congrats! :)\n", 
			world_time_to_global_string(tm));

		raise_kernel_panic(NULL); // ( ͡° ͜ʖ ͡°)
	}
}
```

## Directory and file grouping
### Note
Aqua code is divided into 2 subtrees: kernel and operating system.  
Operating system is placed in root directory and kernel is its integral part. Its whole data is in /kernel/.  
Each file which refers to the kernel goes to /kernel and each file which refers to user space (what is OS) goes out of this.  
There are architecture directories (as shown below) and we don't merge kernel and OS code into one architecture directory.  
Kernel tree is completely different. For example we have /arch/x86/ and /kernel/arch/x86/, not /arch/x86/kernel/.  
Similarly kernel has completely different makefile, but after all main makefile in root is connected with both: system's and kernel's.  
Kernel API\* headers are in /kernel/arch/.../includes/.

### General rules
- There is /docs directory for kernel general documentation
- Name source files and directories in snake_case
- Headers are in .h extension and source files in .c. Don't name them .H,.hc and other trash, because it won't look good
- *Headers and source code are in the same directories*

### Kernel rules
- If you put code or files (like kernel native fonts) for specific architecture, place it in /kernel/arch/.../
- If you put code or files for all architectures, place it in /kernel/arch/noarch/
- All code for the kernel is in /kernel

### OS rules
- Code for driver programs is in /arch/.../drivers\*\*
- Code for user programs, libraries and includes are in /arch/.../{bin,lib,include}

## Other
- If you want to extend build script, know that it is written in gnu/autotools. Don't change it to any other in your request
- \*Kernel API - here, all definitions needed to call syscalls
- \*\*Driver programs are in OS subdirectory instead of kernel, because of policy of the system. It has microkernel and drivers are just user space
