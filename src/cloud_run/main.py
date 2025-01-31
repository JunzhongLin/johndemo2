# main.py

# import apiutils  # This is the module we shall published as a internal package
import os
import json
from google.cloud import bigquery, pubsub_v1
from typing import List
from concurrent import futures
from typing import Callable


def get_locations() -> List[str]:
    """get the locations from the locations materialized view table in bigquery"""
    client = bigquery.Client(location=os.environ.get("LOCATION"))
    query = """
    SELECT location
    FROM `{}`
    """.format(
        os.environ.get("LOCATIONS_MATERIALIZED_VIEW")
    )
    query_job = client.query(query)
    rows = query_job.result()
    return [row.location for row in rows]


def get_weather(locations: List[str]) -> dict:
    """we shall call the weather API here, but for now we shall return a dummy data"""
    weather_data = {}
    for location in locations:
        weather_data[location] = {"temperature": 25, "precipitation": 10}
    return weather_data


def get_customer_data() -> bigquery.table.RowIterator:
    """call query to the customers table in bigquery, return a row generator
    TODO: Consider to use dataflow to parrallelize process
    """
    client = bigquery.Client(location=os.environ.get("LOCATION"))
    query = """
    SELECT customer_id, name, location, mail, input
    FROM `{}`
    """.format(
        os.environ.get("CUSTOMERS_TABLE")
    )
    query_job = client.query(query)
    rows = query_job.result()
    return rows


def publish_to_pubsub(message: dict) -> pubsub_v1.publisher.futures.Future:
    """publish the data to pubsub"""
    publisher = pubsub_v1.PublisherClient()

    topic_path = publisher.topic_path(
        os.environ.get("PROJECT_ID"), os.environ.get("TOPIC_NAME")
    )
    data = json.dumps(message).encode("utf-8")
    publish_future = publisher.publish(topic_path, data)
    # Non-blocking. Publish failures are handled in the callback function.
    publish_future.add_done_callback(get_pubsub_callback(publish_future, data))
    return publish_future


def get_pubsub_callback(
    publish_future: pubsub_v1.publisher.futures.Future, data: str
) -> Callable[[pubsub_v1.publisher.futures.Future], None]:
    """get the callback function for pubsub"""

    def callback(publish_future: pubsub_v1.publisher.futures.Future) -> None:
        try:
            # Wait 60 seconds for the publish call to succeed.
            print(publish_future.result(timeout=60))
        except futures.TimeoutError:
            print(f"Publishing {data} timed out.")

    return callback


def main() -> None:
    locations = get_locations()
    weather_data = get_weather(locations)
    publish_futures = []
    msg_counter = 0
    msg_chunk_size = os.environ.get("MSG_CHUNK_SIZE")
    for row in get_customer_data():
        try:
            customer = dict(row)
            customer["weather"] = weather_data[customer["location"]]
            publish_to_pubsub(customer)
            publish_futures.append(publish_to_pubsub(customer))
        except Exception as e:
            print(f"Failed to publish msg immediately with Error: {e}")
        finally:
            msg_counter += 1
            if msg_counter % msg_chunk_size == 0:
                # wait for the previous chunk to complete
                futures.wait(publish_futures, return_when=futures.ALL_COMPLETED)
                publish_futures = []
    futures.wait(publish_futures, return_when=futures.ALL_COMPLETED)


if __name__ == "__main__":
    main()
