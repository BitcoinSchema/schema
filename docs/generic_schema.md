These are generic Schemas that can be used for many use cases.

?> More Schemas will be added as common use cases are identified and implemented.

### Payment

Payment is used to describe a payment sent from one identity to another. It is used by [BPP](https://github.com/icellan/bpp) when creating Content Paywalls.

##### OP_RETURN

```
MAP SET app <appname> type payment context tx tx <txId>
```

##### Optional Parameters

- Context
- ContextValue
- Subcontext
- Subcontext Value

<!--

### Image

(schema purpose, id, properties, model, version)

```json
{
  "image": {
    "property": "value"
  }
}
```

### Handle

(schema purpose, id, properties, model, version)

```json
{
  "handle": {
    "property": "value"
  }
}
```

### Profile

(schema purpose, id, properties, model, version)

````json
{
    "profile": {
     "property": "value"
    }
}
``` -->
