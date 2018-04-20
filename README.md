# Swift JSONRPC Client

A simple Swift JSONRPC client. 

## Requirements

* [SwiftyJSON 3.1.4](https://github.com/SwiftyJSON/SwiftyJSON)

## Usage

The example usage is using [SwiftHTTP
3.0.0](https://github.com/daltoniam/SwiftHTTP).

```Swift
// create an instance of the client
let client = JSONRPCClient()

// add a call (or calls) to some RPC method
client.query(id: 0, method: "some-method", params: ["some", "params"])

// encode the parameters
guard let params = client.encode() else {
    fatalError("No RPC method queried in client.")
}

// using SwiftHTTP+PostAny
HTTP.postAny("https://mydomain/api/rpc", params: params) { response in

    if response.statusCode == 200 {
        
        // create a SwiftyJSON object to be decoded
        let json = JSON(data: response.data)

        // decode the JSONRPC message(s)
        let results = client.decode(json) { exception: JSONRPCException in
            // handle the RPC error
        }

        // do something with the results
    }
}
```
