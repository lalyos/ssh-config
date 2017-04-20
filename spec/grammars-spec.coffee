describe "ssh grammars", ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage("ssh-config")

  describe "known_hosts", ->
    hostScopes = [ 'source.ssh-known-hosts', 'meta.ssh-key-line.ssh-known-hosts', 'constant.other' ]
    encryptionScopes = [ 'source.ssh-known-hosts', 'meta.ssh-key-line.ssh-known-hosts', 'keyword.other' ]
    keyScopes = [ 'source.ssh-known-hosts', 'meta.ssh-key-line.ssh-known-hosts', 'string.unquoted' ]
    commentScopes = [ 'source.ssh-known-hosts', 'meta.ssh-key-line.ssh-known-hosts', 'comment.line' ]

    beforeEach ->
      grammar = atom.grammars.grammarForScopeName("source.ssh-known-hosts")

    it 'highlights an IP-address line', ->
      {tokens} = grammar.tokenizeLine("91.189.95.84 ssh-rsa AAAsecretAAA=")

      expect(tokens[0]).toEqual value: '91.189.95.84', scopes: hostScopes
      expect(tokens[2]).toEqual value: 'ssh-rsa', scopes: encryptionScopes
      expect(tokens[4]).toEqual value: 'AAAsecretAAA=', scopes: keyScopes
      expect(tokens[5]).toBe undefined

    it 'highlights a hostname line', ->
      {tokens} = grammar.tokenizeLine("shell.sf.net ssh-rsa AAAsecretAAA=")

      expect(tokens[0]).toEqual value: 'shell.sf.net', scopes: hostScopes
      expect(tokens[2]).toEqual value: 'ssh-rsa', scopes: encryptionScopes
      expect(tokens[4]).toEqual value: 'AAAsecretAAA=', scopes: keyScopes
      expect(tokens[5]).toBe undefined

    it 'highlights a hostname and IP line', ->
      {tokens} = grammar.tokenizeLine("github.com,192.30.252.131 ssh-rsa AAAsecretAAA=")

      expect(tokens[0]).toEqual value: 'github.com,192.30.252.131', scopes: hostScopes
      expect(tokens[2]).toEqual value: 'ssh-rsa', scopes: encryptionScopes
      expect(tokens[4]).toEqual value: 'AAAsecretAAA=', scopes: keyScopes
      expect(tokens[5]).toBe undefined

    it 'highlights a hashed hosts line', ->
      {tokens} = grammar.tokenizeLine("|1|cK3CRo=|AJ4CpiDdU= ssh-rsa AAAsecretAAA=")

      expect(tokens[0]).toEqual value: '|1|cK3CRo=|AJ4CpiDdU=', scopes: hostScopes
      expect(tokens[2]).toEqual value: 'ssh-rsa', scopes: encryptionScopes
      expect(tokens[4]).toEqual value: 'AAAsecretAAA=', scopes: keyScopes
      expect(tokens[5]).toBe undefined

    it 'highlights end-of-line comments', ->
      {tokens} = grammar.tokenizeLine("shell.sf.net ssh-rsa AAAsecretAAA= End of line comment")

      expect(tokens[0]).toEqual value: 'shell.sf.net', scopes: hostScopes
      expect(tokens[2]).toEqual value: 'ssh-rsa', scopes: encryptionScopes
      expect(tokens[4]).toEqual value: 'AAAsecretAAA=', scopes: keyScopes
      expect(tokens[6]).toEqual value: 'End of line comment', scopes: commentScopes
      expect(tokens[7]).toBe undefined
