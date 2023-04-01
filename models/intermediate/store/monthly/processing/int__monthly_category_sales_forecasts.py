import pandas as pd
from darts.models.forecasting.prophet_model import Prophet
from darts import TimeSeries
from pyspark.sql.functions import unix_timestamp, col


def fit_and_predict(df):
    ts = TimeSeries.from_dataframe(df, "sales_month", "total_sales")
    model = Prophet(
        {
            "name": "annual",  # (name of the seasonality component),
            "seasonal_periods": 12,  # (nr of steps composing a season),
            "fourier_order": 2,  # (number of Fourier components to use),
        },
        suppress_stdout_stderror=True,
    )
    model.fit(ts)
    prediction = model.predict(6, num_samples=1000).median()
    preds_dict = {
        "store_number": df["store_number"].iloc[0],
        "category": df["category"].iloc[0],
        "sales_month": [],
        "forecast": [],
    }
    for i in range(len(prediction)):
        preds_dict["sales_month"].append(prediction.time_index.date[i])
        preds_dict["forecast"].append(prediction.values()[i][0])
    output_df = pd.DataFrame(preds_dict)
    return output_df


def model(dbt, session):
    dbt.config(
        materialized="table",
        dataproc_container="us-central1-docker.pkg.dev/dbt-retail-example/dataproc-runtimes/minimal_python_ts:0.1",
    )

    my_sql_model_df = dbt.ref(
        "int__monthly_category_sales_filled_missing_dates_filtered"
    )

    final_df = (
        my_sql_model_df.withColumn(
            "sales_month",
            unix_timestamp(col("sales_month"), "yyyy-MM-dd").cast("timestamp"),
        )
        .groupBy(["store_number", "category"])
        .applyInPandas(
            fit_and_predict,
            "store_number string, category string, forecast double, sales_month date",
        )
    )

    return final_df
