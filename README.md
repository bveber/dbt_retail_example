# Why are we here?

The purpose of this project is for me (a Machine Learning Engineer) to gain more practical experience
with DBT (and several other tools) while creating a functional demo/tutorial in a domain I have some experience in.

# What are we doing?

The ultimate goal of this project is to provide time-series forecasts using a
[publicly available dataset](https://data.iowa.gov/Sales-Distribution/Iowa-Liquor-Sales/m3tr-qhgy)
from the state of Iowa that documents all transactions between liquor stores and vendors.
This repo currenlty provides monthly-level forecasts for product-categories at each store.
In theory, this could be useful to individual liquor stores to understand future demand in order to make more
intelligent purchasing decisions or for vendors to be better prepared for future orders. Ultimately, this
level of granularity was chosen arbitrarily, potentially trading-off some practical utililty for
data that is easier to work with.

# How does it work?

We are using [DBT](https://www.getdbt.com/product/what-is-dbt/) to define a number of transformations
required to prepare raw transactional data for a many-models time-series forecasting implementation.
The source data for this project is available as a public-facing
[BigQuery table](https://console.cloud.google.com/marketplace/details/iowa-department-of-commerce/iowa-liquor-sales),
therefore this project uses the [dbt-bigquery adapter](https://docs.getdbt.com/reference/warehouse-setups/bigquery-setup).
The raw data is transformed via BigQuery tables and views before a
[python model](https://docs.getdbt.com/docs/build/python-models) uses a package called
[dart](https://unit8co.github.io/darts/) to generate the time-series forecasts. The python models are run in the backend using
[Dataproc Serverless](https://cloud.google.com/dataproc-serverless/docs) via a custom container defined
at `dockerfiles/minimal_python_ts` and are materialized as BigQuery tables.

With that product soup out of the way, let's dig into some important details.

## DBT

DBT's website sums up their product quite succinctly: "dbt™ is a SQL-first transformation workflow
that lets teams quickly and collaboratively deploy analytics code following software engineering best practices
like modularity, portability, CI/CD, and documentation". This tool is an easy-to-use option for teams looking
to optimize and version-manage their data transformation pipelines that provides a common interface for
Data Engineers, Analysts, Machine Learning Engineers and Data Scientists.

### Models

The key component of DBT is the `model`. Models are generally SQL-based transformation and are placed in
the `/models` directory

### Project configuration

This is the primary configuration for your DBT project. Learn more about it [here](https://docs.getdbt.com/reference/dbt_project.yml)

### Project structure

For information on best practice for how to structure your models directory review the following docs:

- [DBT best practices](https://docs.getdbt.com/guides/best-practices/how-we-structure/1-guide-overview)
- [Staging vs Intermediate vs Mart Models in dbt](https://towardsdatascience.com/staging-intermediate-mart-models-dbt-2a759ecc1db1)

### dbt-bigquery adapter

DBT offers a number of connectors (Redshift, Databricks, Bigquery, etc.) but we will be using the
BigQuery adapter for this project since the source data is already conveniently available in BigQuery. Review the
[docs](https://docs.getdbt.com/reference/warehouse-setups/bigquery-setup) in order to setup this adapter and learn
more about it.

### python model

In DBT the most commonly used models are SQL-based transformations. Many Data Engineers and Analysts might
only ever need this type of model. However, many ML pipelines require some amount of python processing.
This can be done using the [python model](https://docs.getdbt.com/docs/build/python-models).
DBT allows users to define python transformation via Spark jobs. With our BigQuery adapter
we use [Google Dataproc](https://cloud.google.com/dataproc) to run our jobs.

#### pandas_udf

## Dataproc backend

In Googles words: "Dataproc is a fully managed and highly scalable service for running Apache Hadoop,
Apache Spark, Apache Flink, Presto, and 30+ open source tools and frameworks. Use Dataproc for
data lake modernization, ETL, and secure data science, at scale, integrated with Google Cloud,
at a fraction of the cost." They offer two modes of operation; fully-managed cluster or serverless.

### Dataproc cluster

Google offers the ability to create and maintain a full cluster for running your spark jobs
and the documentation can be found [here](https://cloud.google.com/dataproc/docs/guides/create-cluster).
But who wants to maintain a clusters? We both know you're going to forget to turn it off and curse the
$10 bill you rack up while it sits idle overnight. For that reason this project has not been tested
with a managed cluster.

### Dataproc serverless

Google offers the ability to spin up resources on demand for executing your spark jobs
and the documentation can be found [here](https://cloud.google.com/dataproc-serverless/docs).
Because of the intermittent execution of this project the serverless option is ideal. This
product comes with a standard runtime that comes with unknown versions of the packages
listed [here](https://cloud.google.com/dataproc-serverless/docs/guides/custom-containers#dockerfile).
For this project we need additional packages for forecasting so we can't use the standard runtime
and will use custom containers instead.

#### Custom containers

Google allows you to use a [custom container](https://cloud.google.com/dataproc-serverless/docs/guides/custom-containers)
to execute your Dataproc Serverless jobs, enabling us to use our required forecasting packges. The docs show an example
container and make a number of recommendations, but none of it is helpful. Ultimately, a stripped down image,
containing the darts package and pyspark is used in this project. The images need to be build and pushed to
[Artifact Repository](https://cloud.google.com/artifact-registry) for us to use it with our python models.

Note: as of dbt-biguery version 1.5.0b4 custom containers are not supported. However, this is possible using
this [fork](https://github.com/bveber/custom-container-dataproc-serverless). Hopefully, it will be merged
into the source code as a resolution to [this issue](https://github.com/dbt-labs/dbt-bigquery/issues/642).

## Data Science

This project is done from the perspective of a Machine Learning Engineer, so the Data Science likely leaves a lot
to be desired but this should serve as a good introduction to time-series forecasting. For this project, the forecasts
are made monthly for all combinations stores and product-categories. This fits nicely with the spark runtime
as it allows us to aggregate data at the store/product-category level, then fit and predict with time-series
in each partition.

### darts

According to their website: "Darts is a Python library for user-friendly forecasting and anomaly detection on
time series. It contains a variety of models, from classics such as ARIMA to deep neural networks. The forecasting
models can all be used in the same way, using fit() and predict() functions, similar to scikit-learn. The library
also makes it easy to backtest models, combine the predictions of several models, and take external data into account."

### Google Colab experimentation

### pandas_udf

# How to do this at home

## Install dbt

## Setup Google Cloud Project

## Setup DBT project environment

### DBT environment

### Build and push runtime container

## Build your datasets

## Marvel in your success!

# Likely next steps

## Improve project requirements

## Additional data

### Likely data in any other similar scenario

#### Store closures

#### Richer product data

## More DS experimentation

### Better imputation

### Different models

### Model promotion

## Scale up forecasting

### Resources:

- Learn more about [the data](https://data.iowa.gov/Sales-Distribution/Iowa-Liquor-Sales/m3tr-qhgy)
- Learn more about [data preparation for time-series forecasting](https://towardsdatascience.com/preparing-data-for-time-series-analysis-cd6f080e6836)
- Learn more about [DBT](https://www.getdbt.com/product/what-is-dbt/)
- Learn more about [dbt-bigquery]()
- Learn more about [Google BigQuery]()
- Learn more about [Google Dataproc Serverless]()
- Learn more about [Google Colab]()
- Learn more about [darts]()
- Learn more about [Prophet]()
- Learn more about [pypark pandas_udf]()
