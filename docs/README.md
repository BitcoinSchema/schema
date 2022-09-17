## What is Bitcoin Schema?

The schemas are a set of 'types', each associated with a set of properties. This is a community driven register of types for standard use in applications. Schema.org provides a similar register, but this one is specifically designed with BitCoin enabled applications in mind, combining several data protocols.

## What protocols are used?

The protocols used in the models registered here are currently [B](https://github.com/unwriter/b), [MAP](https://github.com/rohenaz/map), [AIP](https://github.com/attilaaf/AUTHOR_IDENTITY_PROTOCOL), [BAP](https://github.com/icellan/bap) and BPP

## Why is Schema Important?

Bitcoin makes it possible to design communication systems in new ways that solve some of the biggest problems we currently encounter such as censorship, lack of data integrity, and poor incentive design. We can eliminate central control over the universe of content which continuing to respect the private ownership of individual platforms. We can delivers true ownership of data to the individuals contributing to these network instead of the companies operating as central databases for both user authentication and the content itself.

## How can I use Schema?

There are a number of tools available for both recording data types listed here to the blockchain, and parsing transactions to read and consume the associated content.

- [BMAP.js](https://github.com/rohenaz/bmap) - A JS library for parsing a number of specific Bitcoin data protocols.
- [Go Bitcoin Schema](https://github.com/BitcoinSchema/go-bmap) - Package for generating transactions that comply with several registered actions such as posts, likes, and follows.
- [Go BMAP](https://github.com/bitcoinschema/go-bmap) - Go implementation of bmap.js
- [go-bitcoinsv](https://gobitcoinsv.com) - A collection of packages for working with BSV in Golang. Many of the packages listed here are used to work with Bitcoin Schema payloads.
- [Map.sv](https://map.sv) - A simple wizard for generating application boilerplate that supports Bitcoin Schemas.

## Who is using Bitcoin Schema?

[Tonicpow](https://tonicpow.com), [Jamify](https://jamify.xyz), [BitChat](https://bitchat.allaboardbitcoin.com), [Hona](https://hona.app), [BlockPost](https://blockpost.network), [MetaLens](https://metalens.app) and many others. If you're using Bitcoin Schema in your application and would like to be listed here, contact us or submit a pull request [here](https://github.com/BitcoinSchema/schema)

?> _Note_: Currently Bitcoin Schema is made up of OP_RETURN based data protocols. In the future, we expect OP_PUSHDATA based protocols to emerge. As new standards are adopted, they will be incorporated into the models registered here, or new variants will be listed.
