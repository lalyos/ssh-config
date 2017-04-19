describe "ssh grammars", ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage("ssh-config")

  describe "known_hosts", ->
    # FIXME: For the host scopes, maybe use the same as the keys in the JSON grammar?
    hostScopes = [ 'source.ssh-known-hosts', 'constant.other' ]
    encryptionScopes = [ 'source.ssh-known-hosts', 'constant.language' ]
    keyScopes = [ 'source.ssh-known-hosts', 'string.unquoted' ]

    beforeEach ->
      grammar = atom.grammars.grammarForScopeName("source.ssh-known-hosts")

    it 'highlights an IP-address line', ->
      {tokens} = grammar.tokenizeLine("91.189.95.84 ssh-rsa AAAsecretAAA=")

      expect(tokens[0]).toEqual value: '91.189.95.84', scopes: hostScopes
      expect(tokens[1]).toEqual value: 'ssh-rsa', scopes: encryptionScopes
      expect(tokens[2]).toEqual value: 'AAAsecretAAA=', scopes: keyScopes
      expect(tokens[3]).toBe undefined

    it 'highlights a hostname line', ->
      {tokens} = grammar.tokenizeLine("shell.sf.net ssh-rsa AAAsecretAAA=")

      expect(tokens[0]).toEqual value: 'shell.sf.net', scopes: hostScopes
      expect(tokens[1]).toEqual value: 'ssh-rsa', scopes: encryptionScopes
      expect(tokens[2]).toEqual value: 'AAAsecretAAA=', scopes: keyScopes
      expect(tokens[3]).toBe undefined

    it 'highlights a hostname and IP line', ->
      {tokens} = grammar.tokenizeLine("github.com,192.30.252.131 ssh-rsa AAAsecretAAA=")

      expect(tokens[0]).toEqual value: 'github.com,192.30.252.131', scopes: hostScopes
      expect(tokens[1]).toEqual value: 'ssh-rsa', scopes: encryptionScopes
      expect(tokens[2]).toEqual value: 'AAAsecretAAA=', scopes: keyScopes
      expect(tokens[3]).toBe undefined

    it 'highlights a hashed hosts line', ->
      {tokens} = grammar.tokenizeLine("|1|cK3CRo=|AJ4CpiDdU= ssh-rsa AAAsecretAAA=")

      expect(tokens[0]).toEqual value: '|1|cK3CRo=|AJ4CpiDdU=', scopes: hostScopes
      expect(tokens[1]).toEqual value: 'ssh-rsa', scopes: encryptionScopes
      expect(tokens[2]).toEqual value: 'AAAsecretAAA=', scopes: keyScopes
      expect(tokens[3]).toBe undefined
