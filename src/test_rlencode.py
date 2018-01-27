import numpy as np
from numpy.random import randint

import pyximport; pyximport.install(reload_support=True, setup_args={'include_dirs':np.get_include()})

import rlencode

def test_input_encode(arr, on_value, indexed, axis, seed=0, print_test=False, print_iter=1000):
	try:
		rlencode.encode(arr, on_value, indexed, axis)
		if print_test == True:
			print(arr, on_value, indexed, axis, seed)
		if seed % print_iter == 0:
			print("Test iteration : " + str(seed))
	except Exception as err:
		print(seed, err)	

# catch error with input values and print all
# try test with generated values; catch errors; print errors + values
def test_encode(seed, print_iter=100000, arr_size=5):
	np.random.seed(seed)
	test_var_arr = randint(0, 2, arr_size, dtype=np.int64) # arr_size >= 4
	test_arr_length = np.power(2, np.sum(test_var_arr))
	
	if test_var_arr[0] == 0:
		dim_tuple = (int(test_arr_length/2), int(test_arr_length/2))
	else:
		dim_tuple = test_arr_length
		
	test_arr = randint(0, 2, dim_tuple)
	test_input_encode(test_arr, test_var_arr[1], test_var_arr[2], test_var_arr[3], seed=seed, print_iter=print_iter)

if __name__ == '__main__':
	test_input_encode(np.array([0,1,0,1,0,1,0,1]), 1, 1, 1, 7, True)
	test_input_encode(np.array([[0,1,0,1], [0,1,0,1]]), 1, 1, 0, 3, True)
	
	seed_ind = 1
	while True:
		test_encode(seed_ind)
		seed_ind += 1