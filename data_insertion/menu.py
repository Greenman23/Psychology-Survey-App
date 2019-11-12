def do_menu(prompt, opts,  low_val = -1):
    print(prompt)
    print_opts(opts)
    val = get_int_response(low_val, len(opts) - 1)
    return val


def print_opts(opts):
    for opt, num in zip(opts, range(len(opts))):
        print(f"{num}:   {str(opt)}")

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


