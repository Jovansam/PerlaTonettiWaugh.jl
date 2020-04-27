
### How to access the SLBD

Overall information on the SLBD is [here](https://www.census.gov/programs-surveys/ces/data/public-use-data/synthetic-longitudinal-business-database.html) with the link to the application here:

- [Apply for SLBD access.](https://www.census.gov/programs-surveys/ces/data/public-use-data/synthetic-longitudinal-business-database/access-the-synlbd.html)

Once this process is approved. Below are the instructions to log into the server:

Cornell's instructions on how to get setup:
[http://www.vrdc.cornell.edu/sds/first-login/](http://www.vrdc.cornell.edu/sds/first-login/)

Code bock for the file:
[http://www2.ncrn.cornell.edu/ced2ar-web/codebooks/synlbd](http://www2.ncrn.cornell.edu/ced2ar-web/codebooks/synlbd)

How to get setup.

- Install the ``nomachine`` application. This is found here
 [https://www2.vrdc.cornell.edu/news/synthetic-data-server/step-3-setting-up-access-to-sds/](https://www2.vrdc.cornell.edu/news/synthetic-data-server/step-3-setting-up-access-to-sds/)

- You need to downlad a configuration. This configuration is at the spot above. Open it and put it some place (say on the desktop). When you open up nomachine, there is a way to import this configuration. Once you do that, an login will appear asking for a user idea, and password. Use those above.

---
### The programs and how to access them.  

The file directory is organized in the following way, the path ``rdcprojects/tr/tr00612/programs/users`` will take you to folder that contains folders for each user. My user name is ``spec676``. Opening this folder will display two subfolders with one of them being ``PTW_AER``

In  ``rdcprojects/tr/tr00612/programs/users/spec676/PTW_AER`` is the code that constructs the moments from the SLBD. It contains the following STATA ``.do`` files.

  - ``trmatrix_g20_loop.do`` computes the transition matrix moments. It does everything. It pulls the appropriate SLBD files and then constructs the transition matrix for each year and then reports the time averaged cells for each part of the transition matrix.  It uses the file ``quartile.do``. The output is ``temp_trmatrix_g20.dta`` which contains the transition matrix for each year in the SLBD.

  - ``quartile_code.do`` computes the quartile positions of establishments in each year.

  - ``entry_loop.do`` computes the entry rate moment. Again it does everything, pulls the SLBD files, computes the fraction on employment that is associated with entrants, then averages this across all years.
