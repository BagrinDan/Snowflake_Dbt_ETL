# ETL_SimplePipeline

This ETL pipeline uses Snowflake for data storage, dbt for cleaning and transforming data, and Power BI for dashboards.

This ETL is based on cafe-store data. We have columns: 'TRANSACTION_ID', 'ITEMS', 'PRICE_PER_UNIT', 'QUANTITIES', 'TOTAL_SPENT', 'PAYMENT_METHOD', 'LOCATION', 'TRANSACTION_DATE'.

The star schema:

```mermaid
erDiagram
    FACT_TRANSACTION {
        varchar transaction_id
        varchar item_id FK
        varchar payment_method_id FK
        varchar location_id FK
        varchar transaction_date_id FK
        float price_per_unit
        int quantities
        float total_spent
    }

    DIM_ITEMS {
        varchar item_id PK
        varchar items
    }

    DIM_LOCATION {
        varchar location_id PK
        varchar location
    }

    DIM_PAYMENT {
        varchar payment_method_id PK
        varchar payment_method
    }

    DIM_TRANSACTION_DATE {
        varchar transaction_date_id PK
        varchar transaction_date
    }

    FACT_TRANSACTION }|--|| DIM_ITEMS : item_id
    FACT_TRANSACTION }|--|| DIM_LOCATION : location_id
    FACT_TRANSACTION }|--|| DIM_PAYMENT : payment_method_id
    FACT_TRANSACTION }|--|| DIM_TRANSACTION_DATE : transaction_date_id
```


PowerBI Dashboards:
![alt text](images/sales_dashboard.png)
![alt text](images/sales_dashboard(top2).png)
![alt text](images/takeaway_vs_store.png)
![alt text](images/sales_per_day.png)



How's done:
Initial data:
![alt text](images/init_data.png)

Data info:
![alt text](images/data_info.png)

We can restore some data. For example:
![alt text](images/item_prices.png)

We have some unique prices, like salad and tea. Both have distinct price. We can restore ERROR and UNKNOWN atributes base on that.

Also we can restore quantities, price_per_unit and total_spent if we have atleast two of them not null.

At the final we have:
![alt text](images/cleaned_data.png)

Location, Payment-method and transaction_date will remain unknown, because is imposible to restore this kind of data.


Medalion arhitecture (Snowflake):


PowerBI dashboard:
