import pandas as pd
from darts.models.forecasting.exponential_smoothing import ExponentialSmoothing
from darts import TimeSeries
from pyspark.sql.functions import unix_timestamp, col


def fit_and_predict(df):
    print(f"df shape: {df.shape}")
    print(f"df dtypes: {df.dtypes}")
    ts = TimeSeries.from_dataframe(df, "sales_month", "total_gallons")
    model = ExponentialSmoothing()
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
    print(f"preds_dict: {preds_dict}")
    output_df = pd.DataFrame(preds_dict)
    print(f"output_df:\n{output_df}")
    return output_df


def model(dbt, session):
    dbt.config(
        materialized="table",
        dataproc_container="us-central1-docker.pkg.dev/dbt-retail-example/dataproc-runtimes/minimal_python_ts:0.1",
    )

    my_sql_model_df = dbt.ref(
        "int__monthly_category_sales_filled_missing_dates_filtered"
    )
    print(f"input df schema: {my_sql_model_df.schema}")

    final_df = (
        my_sql_model_df.withColumn(
            "sales_month",
            unix_timestamp(col("sales_month"), "yyyy-MM-dd").cast("timestamp"),
        )
        .groupBy(["store_number", "category"])
        .applyInPandas(
            fit_and_predict,
            "store_number string, category string, sales_month date, forecast double",
        )
    )
    print(f"output df columns: {final_df.columns}")
    print(f"input df record count: {final_df.count()}")
    print(f"output df schema: {final_df.schema}")

    return final_df
