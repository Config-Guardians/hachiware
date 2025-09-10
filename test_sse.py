# https://pypi.org/project/sseclient
from sseclient import SSEClient

messages = SSEClient("http://localhost:4000/sse")

for msg in messages:
    print("ID: ", msg.id)
    print("Event: ", msg.event)
    print("Data: ", msg.data)
