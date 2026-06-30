# ETL_SimplePipeline


This ETL pipeline uses Snowflake for data storage, dbt for cleaning and transforming data, and Power BI for dashboards.


This ETL is based on cafe-store data. 
We have columns:
    'TRANSACTION_ID'
    'ITEMS'
    'PRICE_PER_UNIT'
    'QUANTITIES',
    'TOTAL_SPENT',
    'PAYMENT_METHOD', 
    'LOCATION', 
    'TRANSACTION_DATE' 


The star schema:

```mermaid
erDiagram
    FACT_TRANSACTION {
        int transaction_id PK
        int item_key FK
        int location_key FK
        int payment_key FK
        date transaction_date_key FK
        int quantity
    }

    DIM_ITEMS {
        int item_key PK
        varchar item_name
        varchar category
        varchar brand
        float unit_price
    }

    DIM_LOCATION {
        int location_key PK
        varchar store_name
        varchar city
        varchar region
        varchar country
    }

    DIM_PAYMENT {
        int payment_key PK
        varchar payment_method
        varchar payment_provider
        varchar card_type
    }

    DIM_TRANSACTION_DATE {
        date transaction_date_key FK
        int year
        int quarter
        int month
        int day
        boolean is_weekend
    }

    FACT_TRANSACTION }|--|| DIM_ITEMS : item_key
    FACT_TRANSACTION }|--|| DIM_LOCATION : location_key
    FACT_TRANSACTION }|--|| DIM_PAYMENT : payment_key
    FACT_TRANSACTION }|--|| DIM_TRANSACTION_DATE : transaction_date_key



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
