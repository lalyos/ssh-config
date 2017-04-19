describe "ssh grammars", ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage("ssh-config")

  describe "known_hosts", ->
    beforeEach ->
      grammar = atom.grammars.grammarForScopeName("source.ssh-known-hosts")

    it 'highlights an IP-address line', ->
      {tokens} = grammar.tokenizeLine("91.189.95.84 ssh-rsa AAAsecretAAA=")

      expect(tokens[0]).toEqual
        value: '91.189.95.84',
        scopes: [ 'source.ssh-known-hosts', 'constant.other' ]
      expect(tokens[1]).toEqual
        value: 'ssh-rsa',
        scopes: [ 'source.ssh-known-hosts', 'constant.language' ]
      expect(tokens[2]).toEqual
        value: 'AAAsecretAAA=',
        scopes: [ 'source.ssh-known-hosts', 'string.unquoted' ]
