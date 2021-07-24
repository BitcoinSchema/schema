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

Post is meant to express a new piece of content to the network.

- B protocol is used for the content. This means the post could be anything from plain text, an image, some markdown, or even binary. Any file type can be expressed as a post.
- Attachments can be made in addition to the post content (see [Attachments])
- The Context and Subcontext properties are optional. They allow you to post within a specific context such as a geolocation. Some contexts require more than 1 level, such as commenting on a YouTube video. In the case of youtube we use a context name of "provider" and a value of "youtube". We then specify a subcontext name of "videoID" and set the value to the YouTube video ID our post is associated with. This pattern allows us to comment on anything in a flexible way that is machine readable.

#### OP_RETURN

```
B <content> <mediaType> <encoding> | MAP SET app <appame> type post | AIP paymail <pubkey> <signature>
```

#### Optional Parameters

- Context
- ContextValue
- Subcontext
- Subcontext Value

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
}
tx, err := bschema.CreatePost(post, utxos, changeAddress, privateKey)
```

### Reply

Replies are just Posts with a context of a transaction ID.

#### OP_RETURN

```
OP_FALSE OP_RETURN B <content> <mediaType> <encoding> | MAP SET app <appame> type post context tx tx <txid> | AIP paymail <pubkey> <signature>
```

#### go-bitcoin-schema

```go
reply := bschema.Post{
  MediaType:        MediaTypeTextMarkdown,
  Encoding:         EncodingUTF8,
  Content:          "# This is a markdown reply!",
}
tx, err := CreateReply(reply, replyTxID, utxos, changeAddress, privateKey)
```

### Repost

A repost is used to amplify an existing post, without reposting the actual content. Like with a post, it is possible to repost with a new context and/or subcontext. This allows you surface posts in multiple contexts. Imagine a post is made with a context of a UPC code (comment on a physical produt). Someone might then repost that comment with a context of 'url' and value = the company's web address. This would repost that comment against the company website, surfacing it in new apps such as metalens.

#### Optional Parameters

- Context
- ContextValue
- Subcontext
- Subcontext Value

#### OP_RETURN

```
MAP SET app <appame> type repost tx <txid> | AIP paymail <pubkey> <signature>
```

#### go-bitcoin-schema

```go
tx, err := CreateRepost(repostTxID, utxos, changeAddress, privateKey)
```

### Tags

Tags allow you to categorize content. Unlike context, which determines when / where the content should be rendered and with what view, tags are a general purpose tool for aiding with search and filtering posts based on their tag values.

Tags are added as an additional output, with the following format:

#### OP_RETURN

```
MAP ADD tags <tag1> <tag2> <tag3> ... | AIP paymail <pubkey> <signature>
```

#### go-bitcoin-schema

You can include tags on any post

```go
postContent := "# This is a post"
tags := []string{"tag1", "tag2", "tag3"}

post := Post{
  MediaType:  MediaTypeTextMarkdown,
  Encoding:   EncodingUTF8,
  Content:    postContent,
  Tags:       tags,
}
```

### Attachments

Attachments are included as additional OP_RETURN outputs using B protocol, signed with AIP.

#### OP_RETURN

Attachment 1:

```
B <attachment1Data> <mediaType> <encoding> | paymail <pubkey> <signature>
```

Attachment 2:

```
B <attachment2Data> <mediaType> <encoding> | paymail <pubkey> <signature>
```

#### go-bitcoinb-schema

```go
htmlAttachment := "<html><h1>This is a html attachment</h1></html>"
cssAttachment := "body { background-color: green; }"
postContent := "# This is a reply!"

post := Post{
  MediaType:  MediaTypeTextMarkdown,
  Encoding:   EncodingUTF8,
      Content:    postContent,
      Tags:       tags,
  Attachments: []b.B{{
    MediaType:  string(MediaTypeTextHTML),
    Encoding:   string(EncodingUTF8),
    Data:       b.Data{UTF8: htmlAttachment},
  },{
        MediaType: string(MediaTypeTestHTML),
        Encoding: string(EncodingUTF8),
        Data: b.Data{UTF8: cssAttachment}
  }},
}
```

<!-- ### Block

(schema purpose, id, properties, model, version)

```json
{
  "block": {
    "property": "value"
  }
}
``` -->

?> "MAP" is a placeholder for the Magic Attribute Protocol prefix, which is 1PuQa7K62MiKCtssSLKy1kh56WWU7MtUR5
