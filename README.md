# Data Engineer case: Cheffelo

Congratulations on making it through to this stage of the interview process. In this stage we are looking to learn more about your technical skillset, in particular your data modelling abilities as this will be a key part of the role.

## How to complete the case

- **Time.** You can use up to 5 hours
- **AI is ok to use.** We use Claude across the team, so work how you normally work. We'll ask what you used it for, where you overruled it, and whether you understand what it did.
- **Plain SQL.** You write `.sql` files and run them against a database on your own machine. See Setup below for what we recommend.

## Setup

You'll need a SQL database running locally to build your model in. Any database will do, but **we recommend DuckDB** and the files in this repo are set up for it.

DuckDB suits this case well. The whole database is a single file, there's no server to start or credentials to manage, and it reads the CSVs straight off disk so there's no load step to write.

Install the command line tool:

**macOS**

```bash
brew install duckdb
```

**Windows**

```powershell
winget install DuckDB.cli
```

Then, from inside your case folder, this builds your models:

```bash
duckdb cheffelo.duckdb -c ".read build.sql"
```

Run it again whenever you change something. The same command works on every OS.

To poke around the data interactively:

```bash
duckdb -ui cheffelo.duckdb
```

That opens a SQL editor and a browsable list of everything in the database in your browser. It holds the database file open while it runs, so quit it before your next build or the build will fail on a lock.

### If you'd rather use something else

Postgres, MySQL, SQLite, SQL Server — if you already have something running and would prefer to work in it, that's completely fine. We care about the model, not the engine. Whatever you use, tell us how to run it in your submission.

### If you can't get anything running

Don't let setup eat your five hours. If you can't get a database working on your machine, or you'd rather not install one, then skip it and present the model and SQL you would have built instead — a diagram, a few slides, a document, whatever gets the design across.

If you have any issues with your setup, please contact me at stephen.allwright@cheffelo.com.

## How the project fits together

```
de-take-home-test/
├── build.sql     the build order, one line per model file
├── models/       your models go here
├── queries/      the three queries we've asked for
└── data/         the source CSVs
```

**Models.** A model is a `.sql` file that creates a view or a table:

```sql
create or replace view silver_brands as
select cast(brand_id as integer) as brand_id, brand_name
from read_csv('data/raw_brands.csv');
```

Note on `read_csv()`. This is a DuckDB-specific function that reads a CSV file from disk, so there's no load step to worry about. Once a model exists, later models select from it by name like any other table.

**Build order.** `build.sql` is a list of `.read` lines that run top to bottom, so a model has to come after anything it selects from. Add a line for each file you create. Get it wrong and you'll see `Table with name ... does not exist`, which tells you what to move.

**Worked example.** `models/silver_brands.sql` shows the mechanics. It demonstrates how a file becomes a model; it is not a suggestion about how you should structure things or how many layers you should have. Delete it if you like.

## Background

We deliver meal kits across four brands in four countries. Customers subscribe and get a box each week. They also set preferences: allergens, tastes, and concepts like vegetarian.

Everything hangs off the menu week, which is the week the food gets eaten. That's a different thing from the week the order was placed.

## The data

We have provided seven CSVs in the `data` folder. This is your bronze layer, raw and untouched. It behaves like source data.

|File|What's in it|
|---|---|
|`raw_brands.csv`|Our four brands, with country, currency and VAT rate|
|`raw_customers.csv`|Customers, their brand, and when they signed up|
|`raw_customer_preferences.csv`|Which preferences each customer has held, and when|
|`raw_preferences.csv`|Preference lookup: allergen, taste, concept|
|`raw_orders.csv`|Order headers: menu week, order date, delivery date, status|
|`raw_order_lines.csv`|Order lines: recipe, quantity, price including VAT|
|`raw_recipes.csv`|Recipes: name, cuisine, main protein|

## Task 1: build the model

We would like you to build a dimensional data model that makes it possible to answer, amongst others, these following questions:

1. **Weekly revenue excluding VAT, by brand and menu week.** Finance checks this every Monday.
2. **Revenue by preference type.** Marketing wants to know how much comes from customers with allergen preferences, versus taste, versus concept.
3. **Number of orders per main protein.** Menu & Supply use this to plan sourcing for upcoming menus.

In addition to the underlying dimensional model, we would also like you to write the three queries that answer these questions. There are stub files waiting for them in `queries/`.

## Task 2: design rationale

Now that you have created your model, we would like to hear about why you did what you did. Please create a document where you answer the following questions:

- What is your design rationale behind the models you created?
- What issues do you potentially see with this model?
- If you could have access to more data, what would you add to the model?
- What assumptions did you make when designing it?
- What would you do with more time?

## Sending it back

Send a repo or a zip with your models, the three queries and the rationale to stephen.allwright@cheffelo.com. We'll want to run it ourselves, so please make sure it works from a clean checkout and tell us the command.

If you went the diagram route instead, send that in place of the models, along with the three queries and the rationale.
