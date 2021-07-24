## Social Schemas

These schemas are the building blocks for building social networking apps.

### Like

Used to express positive sentiment about a post, transaction, or any other global identifier.

#### OP_RETURN

```
MAP SET app <appame> type like tx <txid> | AIP paymail <pubkey> <signature>
```

#### go-bitcoin-schema

```go
tx, err := CreateLike(likeTxID, utxos, changeAddress, privateKey)
```

### Unlike

Used to undo a like

#### OP_RETURN

```
MAP SET app <appame> type unlike tx <txid> | AIP paymail <pubkey> <signature>
```

#### go-bitcoin-schema

```
tx, err := CreateUnlike(unlikeTxID, utxos, changeAddress, privateKey)
```

### Follow

Used to express a relationship between two identities.

#### OP_RETURN

```
MAP SET app <appame> type follow idKey <pubkey> | AIP paymail <pubkey> <signature>
```

#### go-bitcoin-schema

```go
tx, err := CreateFollow(followIdKey, utxos, changeAddress, privateKey)

```

### Unfollow

Used to express a relationship between two identities.

#### OP_RETURN

```
MAP SET app <appame> type unfollow idKey <pubkey> | AIP paymail <pubkey> <signature>
```

#### go-bitcoin-schema

```go
tx, err := CreateUnfollow(unfollowIdKey, utxos, changeAddress, privateKey)

```

### Post

#### OP_RETURN

```
B <content> <mediaType> <encoding> | MAP SET app <appame> type post | AIP paymail <pubkey> <signature>
```

#### go-bitcoin-schema

```go
// identity key of the user you are requesting
post := bschema.Post{
  MediaType:        MediaTypeTextMarkdown,
  Encoding:         EncodingUTF8,
  Content:          "# Hello small world!",
  Context:          ContextProvider,
  ContextValue:     "youtube",
  Subcontext:       ContextVideoID,
  SubcontextValue:  "IdNs8eVGbBs",
  Tags:             []string{"testing", "awesome"},
}
tx, err := bschema.CreatePost(post, utxos, changeAddress, privateKey)
```

### Reply

### Repost

### Tags

### Attachments

### Block

(schema purpose, id, properties, model, version)

```json
{
  "block": {
    "property": "value"
  }
}
```

### Comment

(schema purpose, id, properties, model, version)

```json
{
  "comment": {
    "property": "value"
  }
}
```

?> "MAP" is a placeholder for the Magic Attribute Protocol prefix, which is 1PuQa7K62MiKCtssSLKy1kh56WWU7MtUR5
