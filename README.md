# CTRLEncode

A fast python run length encoder written using Cython. The package takes a python numpy 1D, 2D, or 3D (batch) array of 0/1 masks for conversion to
a run length encoding. Batch encodings can be output as a list of string or list of numpy ndarrays. Concatenate string output to a list of training example
names to save to an output file.

## Getting Starting

The direction below provide information on usage, installing, and testing the python package.

### Prerequisites

Numpy is required for the installation and usage of this package. For more information on installing numpy, please visit [the scipy homepage](https://scipy.org/).

### Building and Installing

Install ctrlencode by:

1. downloading the repository.
2. unziping the archive file.
3. changing the working directory to the unzipped archive folder.
4. running:

```
python setup.py install
```
5. testing the installation by typing:

```
python
```

```python
import ctrlencode
```

### Testing

Open the jupyter notebook using:

```
jupyter notebook
```

Run the jupyter notebook tests run_length_test.ipynb.

Run the stress test inside the test module by running:

```
python test_rlencode.py
```

## Deployment

For using on installed system , import the package by running:

```python
import ctrlencode
```

For using without installing run:

```python
import pyximport; pyximport.install(reload_support=True, setup_args={'include_dirs':np.get_include()})

import rlencode
```

## Built With

[Cython](https://cython.org/)

## Author

Christopher J. Thompson

This project is licensed under the MIT License - see the [LICENSE.txt](LICENSE.txt) file for details

## Acknowledgements

The Cython Team

Steve Byrnes on StackOverflow for help solving the [pyximport numpy library problem](https://stackoverflow.com/questions/14657375/cython-fatal-error-numpy-arrayobject-h-no-such-file-or-directory)
