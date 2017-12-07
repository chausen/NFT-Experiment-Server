import httplib

url = "localhost"
port = 8080

conn = httplib.HTTPConnection(url + ":" + port);

headers = {"ec": 1,
           "voltage": 1,
           "pH": 1,
           "rH": 1,
           "wTemp": 1,
           "aTemp": 1,
           "timestamp": 2017-12-07T13:30:25Z
           }

conn.request("POST", "/allMeasurements")


res = conn.getresponse()

print res

conn.close()
    


