'use babel';

describe('ssh known_hosts grammar', () => {
  let grammar;

  beforeEach(() => {
    waitsForPromise(function() {
      return atom.packages.activatePackage("ssh-config");
    });

    grammar = atom.grammars.grammarForScopeName("source.ssh-known-hosts");
  });

  it('highlights an IP-address line', () => {
    const tokens = grammar.tokenizeLine("91.189.95.84 ssh-rsa AAAAB3NzaC1ycveryLongKEy2EAAAA=");

    expect(tokens[0]).toEqual({
      value: "91.189.95.84",
      scopes: ['variable.other']
    });
  });
});
