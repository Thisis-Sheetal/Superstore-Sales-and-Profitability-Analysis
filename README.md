
Superstore Sales and Profitability Analysis
End-to-end analysis of the Sample Superstore dataset using Excel, MySQL and Power BI. The goal is to answer three business questions: are we growing and is it profitable, where is profit leaking, and how much does discounting cost

Dataset
Source: Sample Superstore (Tableau sample dataset)
Size: 9,994 order lines, 2014-01-03 to 2017-12-30
Columns: Row ID, Order ID, Order Date, Ship Date, Ship Mode, Customer ID, Customer Name, Segment, Country, City, State, Postal Code, Region, Product ID, Category, Sub-Category, Product Name, Sales, Quantity, Discount, Profit (plus a derived Discount Band column)
Headline totals: Sales 2.30M, Profit 286K, Margin 12.5%.

Tools
Tool	Used for
Excel	Data checks, duplicate check, discount bands, date conversion
MySQL	Profiling, cleaning log, summary queries, rank analysis, discount analysis
Power BI	Data model, DAX measures, 3-page dashboard

superstore-analysis/
├── data/            # source CSV
├── excel/           # workbook with checks and discount bands
├── sql/             # profiling, summary, rank and discount queries
├── powerbi/         # .pbix file
├── screenshots/     # dashboard page images
└── README.md
