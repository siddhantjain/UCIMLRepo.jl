UCI Machine Learning Repository
===============================

A Julia package for UCI ML repositories
-----------------------------------------------------------------------

UC Irvine Machine Learning Repository is one the most popular collection of datasets that are avalaible for free. 

This Package provides functions for the user to easily download from the website directly into a DataFrame. 

Additionaly, another function allows the user to view the accompanying metadata about the dataset.

## Installation

```julia
julia> Pkg.clone("git://github.com/siddhantjain/UCIMLRepo.jl.git")
```
note: There are some errors that have been reported so far when trying to run this package on a windows machine. This space will be updated as and when the errors are cleared for windows machine

## Exported Functions

Two functions are available

	1. ucirepodata("DataSetName")
	2. uciRepoinfo("DataSetName")

## Basic Examples

Obtain a DataFrame with the entire iris data set

```julia
using UCIMLRepo
df = UCIRepoData("iris") 
```

Alternatively, you may mention the exact link of the dataset to be loaded. There is an optional argument that you need to set to false to do so.

```julia
using UCIMLRepo
df = ucirepodata("http://archive.ics.uci.edu/ml/machine-learning-databases/iris/iris.data",false) 
```

### Fetching information on the dataset

print on STDOUT all the relevant information regarding the dataset 

```julia
using UCIMLRepo
ucirepoinfo("iris") 
```
As before the exact link may be mentioned for more information on the dataset
```julia
using ucimlrepo
ucirepoinfo("http://archive.ics.uci.edu/ml/machine-learning-databases/iris/iris.names", false)
```

## TO DO

* Add functionality to parse the output from ucirepoinfo and automatically name the attributes in the DataFrame

* Add functionality to have a seperate datatype for each attribute in the dataset based on the output from ucirepoinfo

* Better error handling routines

* ~~Allow for user to enter the url of the dataset~~

 



