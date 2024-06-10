import azure.functions as func
import datetime
import json
import logging
import psycopg2

app = func.FunctionApp()

@app.timer_trigger(
    schedule="0 */1 * * * *",
    # schedule="0 0 0 1 12 2100",
    arg_name="myTimer",
    run_on_startup=True,
    use_monitor=False,
)
def test(myTimer: func.TimerRequest) -> None:
    logging.info("stats")

