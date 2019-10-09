# Kernel Conventions
This markdown presents all conventions you should apply in your pull requests.
If your request doesn't have any of the presented convention, we won't accept it (even if code is good), until you fix it.


## Coding style
### Formalities:
- Don't use C++ and other languages for kernel source code, **but C with C11 standard**
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
- For previous point, put double TAB in next argument lines instead of tabbing until you'll get position after '('
- Use TAB for scoping, instead of SPACE


### Example:

```c
void check_whether_day_is_good(struct the_world_current_time *tm,
		int possibility_of_good_day,
		int possibility_of_bad_day)
{
	float sum_poss = (float)(possibility_of_good_day + possibility_of_bad_day);

	if ((float)(possibility_of_good_day / sum_poss) >= 0.5) {
		printk("Congrats! Day %s is seriously very good! Congrats! :)\n", 
			world_time_to_global_string(tm));

		raise_kernel_panic(NULL); // ( ͡° ͜ʖ ͡°)
	}
}
```

## Directory and file grouping
- If you put code or files (like kernel native fonts) for specific architecture, place it in /source/arch/{architecture}/
- If you put code or files for all architectures, place it in /source/arch/noarch/
- Code for the kernel is in /source/arch/.../kernel
- Code for driver modules is in /source/arch/.../drivers
- Code for general kernel modules is in /source/arch/.../ next to kernel
- There is /Documentation directory for necessary info. It is beginned with big letter to make it easier to see
- Name source files and directories in snake_case
- Headers are in .h extension and source files in .c. Don't name them .H,.hc and other trash, because it won't look good
- *Headers and source code are in the same directories*

## Other
- If you want to extend build script, know that it is written in gnu/autotools. Don't change it to any other in your request.
