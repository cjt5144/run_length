import numpy as np
cimport numpy as np
DTYPE = np.int
ctypedef np.int_t DTYPE_t

def encode(np.ndarray arr, int on_value=1, int indexed=1, axis=1):
	"""
	This Python function encodes a [indexed]-indexed value mask over the input 1D numpy ndarray arr. The value captured\
	 in the mask specified with the on_value argument.

	Args:
	-----
		arr np.ndarray[DTYPE_t, ndim=1] : 1D or flattened mask of int32 values where on_value belongs in the set, set(arr).
			The input array in flattened along axis and passed to encode1d.
		on_value int : The value to capture in the run length.
		indexed : The start indexing of the output run length.

	Returns:
	--------
		np.ndarray : run length encoding of arr
	"""
	if axis == 0:
		order = 'C'
	elif axis == 1:
		order = 'F'
	else:
		raise ValueError("[-] ValueError - axis value [{}] unrecognized.".format(axis))
		
	if arr.ndim > 1:
		arr = arr.flatten(order=order)
	
	return encode1d(arr, on_value, indexed)
	
def batch_encode(np.ndarray arr, int indexed=1, int axis=1, int to_string=False, str sep=" "):
	"""
	See encode docstring for argument details.

	arr dimensions : [BATCH, x, y] (input dimension of arr) -> [BATCH, x * y]

	Args:
	-----
		to_string bool : Whether to convert each run length encoding into a string in preparation of file output.
		sep string : The separator use between numbers of run length encodings.
	"""
	if axis == 0:
		order = 'C'
	else:
		order = 'F'
		
	cdef int batch_size = arr.shape[0]
	cdef int i
	
	if arr.ndim == 3:
		arr = arr.reshape(-1, arr.shape[1] * arr.shape[2], order=order) # Does not work!!! (YET)
		enc = [encode1d(arr[i], indexed, axis) for i in range(batch_size)]
		# enc = ( np.vectorize(encode1d)(arr, indexed, axis) ).tolist
		
		if to_string == False:
			return enc
		else:
			return [sep.join(np.vectorize(str)(s)) for s in enc]
	else:
		raise IndexError
		
cdef np.ndarray[DTYPE_t, ndim=1] encode1d(np.ndarray[DTYPE_t, ndim=1] arr, int on_value, int indexed):
	"""
	This C function encodes a [indexed]-indexed value mask over the input 1D numpy ndarray arr. The value captured\
	 in the mask specified with the on_value argument.
 
	Args:
	-----
		arr np.ndarray[DTYPE_t, ndim=1] : 1D or flattened mask of int32 values where on_value belongs in the set, set(arr).
		on_value int : The value to capture in the run length.
		indexed : The start indexing of the output run length.

	Returns:
	--------
		np.ndarray : run length encoding of arr
	"""
	if arr is None:
		raise ValueError("'arr' cannot be NONE.")
	assert arr.dtype == DTYPE
	
	# The worst case scenario is an odd length with every other value == on_value, starting with index 0 (i.e. [1,0,1,0,1] -> [1, 1, 3, 1, 5, 1]).
	# l + 1 numbers are needed to describe this run length.
	cdef int l = arr.size
	if l % 2 == 1:
		_l = l + 1
	cdef np.ndarray[DTYPE_t, ndim=1] enc = np.zeros(_l, dtype=DTYPE)
		
	cdef int x, run_length, run = 0, run_start, cnt = 0
	
	for x in range(l):
		if arr[x] == on_value and run == 0:
			run += 1
			run_start = x + indexed
		elif arr[x] == on_value:
			run += 1
		elif run > 0 and arr[x] != on_value:
			enc[cnt] = run_start
			enc[cnt+1] = run
			run = 0
			run_start = 0
			cnt += 2
	if run > 0:
		# Adds remaining encodings in buffer to enc
		# If encodings in buffer, add buffer to enc
		enc[cnt] = run_start
		enc[cnt+1] = run
		cnt += 2
	
	# Return resized enc array of length cnt
	cdef np.ndarray[DTYPE_t, ndim=1] x_enc = np.zeros(cnt, dtype=DTYPE)
	for x in range(cnt):
		x_enc[x] = enc[x]
			
	return x_enc

if __name__ == '__main__':
	pass
