-- Build order. One .read line per model file, run top to bottom, so a model
-- has to come after anything it selects from. Add a line for each file you
-- create in models/.
--
-- If you get the order wrong you'll see "Table with name ... does not exist",
-- which tells you what needs to move up.

.read models/silver_brands.sql
