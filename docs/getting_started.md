## Examples

### JavaScript

First, we'll demonstrate creating a new transaction containing some data according to a Bitcoion Schema. For this example, we will create a new "like". Likes refer to an existing transaction by its transaction ID.

Here, we use RelayOne Javascript API to create the transaction. This is very similar to creating the tx using MoneyButton, and is simplified for demonstration purposes.

```js
// Initialize payload object
let payload = {
  outputs: []
}

// Create data payload for Like Schema
const dataPayload = [
  '1PuQa7K62MiKCtssSLKy1kh56WWU7MtUR5', // MAP Prefix
  'SET',
  'app',
  appName,
  'type',
  'like',
  'tx',
  <liking_txid>
];

// Create a script from the data payload
const s = Script.fromSafeDataArray(
  dataPayload.map((d) => {
    return Buffer.from(d);
  })
);

// Add the script to our outputs
payload.outputs = [
  {
    script: s.toAsmString(),
  },
];

// Add tip / change outputs
let toOuts = [
  { to: <tipAddress>, amount: <tipAmount>, currency: <currency> },
  { to: <changeAddress>, amount: <changeAmount>, currency: <currency>}
];

// Combine the outputs
payload.outputs = [...payload.outputs.concat(toOuts)];

// Broadcast the transaction
let response = await relayOne.send(payload);
```

### Go

A library is available for doing this automatically with Go called [go-bitcoin-schema](https://github.com/bitcoinschema/go-bitcoin-schema). Creating a like is as simple as:

```go
import "github.com/bitcoinschema/go-bitcoin-schema"
```

```go
tx, err := CreateUnlike(unlikeTxID, utxos, changeAddress, privateKey)
if err != nil {
  // handle error
}

// do something with tx...
```

## Getting help

[TonicPow](https://tonicpow.com) maintains an [#open-social](https://join.slack.com/t/tonicpow/shared_invite/zt-mlccqx28-IEabvOGPx_QLyFJJbWE3hQ) Slack channel dedicated to supporting on-chain social network development.
