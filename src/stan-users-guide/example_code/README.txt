The example_code/ directory contains end-to-end Python and R wrappers for Stan programs referenced in the Stan User's Guide.

The general intention is to simulate data in the interface language, compile/call the relevant Stan program and report the results. The results are shown to support that the generating parameters for the model have been fit properly. Demonstation of proper fit include at least one of:

1) Inspection that the estimate + one standard deviation includes the generating parameter.

2) Demonstration that that predictions are in line with generating data with examples.

Each subdirectory contains one run.R and one run.py which will compile/run all the .stan programs in the subdirectory. The rough organizing principle is that the generated data + minor transformations are the same across all the .stan programs and the type of model is fixed. For example `simple_linear_regression` covers several different .stan models that cover single and multi-predictor use-cases. The goal is to facilitate comparison of different ways to achieve the same result as described in the Stan User's Guide. 

The user's guide contains links to the mentioned .stan programs and the subdirectory in the form of 'my_model.stan' and a link to the embedding directory that contains the 'run.R', 'run.py'. There is no reverse linking from .stan programs to the user's guide for simplicity given that one .stan program may be referenced by multiple sections of the user's guide. 

=====

Maintenence standards:

All code should demonstrate good coding practices and pass relevant linters:

1) Stan programs should adhere to the 'Stan Program Style Guide' in the user's manual. There is a simple linter available at: https://github.com/breckbaldwin/stan_linter.git

2) The run.py should adhere to the style guide at:https://www.python.org/dev/peps/pep-0008. The linter currently being used is pylint.

3) The run.R should adhere to Hadley Wickham's style guide at http://adv-r.had.co.nz/Style.html. RStudio implements `rlint` which is accessed by the menu Code>Show Diagnistics. The linter output shows up in the Markers tab on the output window.

The `test_run_all_runs.py` runs both the python and R versions of the run programs and will fail if any of the `run.*` programs fail. There is no checking if the output is correct, just whether the programs completed without errors being thrown. To run:

>cd <path to repo>/docs/src/stan-users-guide/example_code
>python test_run_all_runs.py

If a run.* program fails a message appears, 'End to end test FAIL', then scroll back up and see the last 'Testing: <dir>/run.*', the <dir> indicates the failed R or python run.* code.

To run an individual run.* file supply the path as an argument, e.g. if `simple_linear_regression/run.R` is failing:

>python test_run_all_runs.py simple_linear_regression/run.R

will run just that run.R program.


