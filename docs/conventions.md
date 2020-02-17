# Kernel Conventions
This markdown presents all conventions you should apply in your pull requests.
If your request doesn't have any of the presented convention, we won't accept it (even if the code is good), until you fix it.


## Coding style
### Formalities:
- Don't use C++ and other languages for kernel source code, **but C with C11 standard**
- Unless it is OS. Here you can write in each language you want and then our coding style obviously isn't required, unless it is C, because we honor C as the main language
- Don't write spaghetti code. What I mean? If you have a 10-20-line function, don't forcibly divide it into a few lesser ones, because later it makes a crap in the source
- Do not use ugly words
- Comment shortly what your functions do

### Naming:
- All function and structure names should be snake_case
- Names of value pragma definitions like `#define A 32` are UPPER_SNAKE_CASE
- Names of function pragma definitions are lower_snake_case

### Formatting:
- In functions, opened curly bracket is always under function declaration
- In scopes, like while, for, switch and structs, opened curly brackets are always after scope declaration
- Local variable in blocks are always declared on the beginning of the block
- If your function gets a lot of arguments, split it into multiple lines
- For previous point, put maximally double TAB in next argument lines instead of tabbing until you'll get position after '('
- Use TAB for scoping, instead of SPACE
- Use tab and indentation width of 8 chars. If you hardly think, that it is bad and you prefer your 4-char or lesser one, read [coding style of Linux](https://www.kernel.org/doc/html/v4.10/process/coding-style.html). They've described it well


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
Each file which refers to the kernel goes to the /kernel and each file which refers to user space (what is OS) goes out of this.  
There are architecture directories (as shown below) and we don't merge kernel and OS code into one architecture directory.  
Kernel tree is completely different. For example we have /arch/amd64/ and /kernel/arch/amd64/, not /arch/amd64/kernel/.  
Similarly kernel has completely different makefile, but after all main makefile in root is connected with both: system's and kernel's.  
Kernel API\* headers are in /kernel/arch/.../includes/.

### General rules
- There is /docs directory for kernel general documentation
- Name source files and directories in snake_case
- Headers are in .h extension and source files in .c. Don't name them .H,.hc and other trash, because it won't look good
- *Headers and source code are in the same directories*

### Kernel rules
- If you put code or files for specific architecture, place it in /kernel/arch/.../
- If you put code or files for all architectures (like kernel fonts), place it in /kernel/arch/noarch/
- All code for the kernel is in /kernel

### OS rules
- Code for driver programs is in /arch/.../drivers\*\*
- Code for user programs, libraries and includes are in /arch/.../{bin,lib,include}

## Other
- If you want to extend the build script, know that it is written with usage of my Xbuilder build system. Don't change it to any other one in your requests
- \*Kernel API - here, all definitions needed to call syscalls
- \*\*Driver programs are in OS subdirectory instead of kernel, because of policy of the system. It has micro kernel and drivers are just in the user-space
