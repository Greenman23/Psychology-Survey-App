def do_menu(prompt, opts, opt_func, alt_func):
    print(prompt)
    print_opts(opts)
    val = get_int_response(-1, len(opts) - 1)
    if val == -1:
        alt_func()
    else:
        opt_func(opts[val])


def print_opts(opts):
    for opt, num in zip(opts, range(len(opts))):
        print(f"{num}:   {opt}")

# Error checking: https://stackoverflow.com/questions/8075877/converting-string-to-int-using-try-except-in-python/8075959
def get_int_response(lower, upper):
    while True: 
        val = input("Enter an integer value ")
        try:
            num_val = int(val)
            if(num_val >= lower and num_val <= upper):
                return num_val
            else:
                print(f"Enter value between {lower} and {upper}")
        except ValueError:
             print("Enter an integer value")

def get_str_response():
    return input(" ")


