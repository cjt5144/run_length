from distutils.core import setup
from distutils.extension import Extension
from Cython.Build import cythonize
import numpy

extensions = [
	Extension(
		"ctrlencode",
		["src/rlencode.pyx"],
		include_dirs=[numpy.get_include()]
	)
]

setup(
	name = "CT 01 Mask Run Length Encoder",
	ext_modules = cythonize(
		# 'src/rlencode.pyx',
		# include_path = [numpy.get_include()]
		extensions
		)
)