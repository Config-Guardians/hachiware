# https://pypi.org/project/sseclient
from sseclient import SSEClient
from json import loads
import pprint

messages = SSEClient("http://localhost:4000/sse")
pp = pprint.PrettyPrinter(indent=2)

for msg in messages:
    if msg.data:
        print("ID: ", msg.id)
        print("Event: ", msg.event)
        print("Data: ")
        pp.pprint(loads(msg.data))
