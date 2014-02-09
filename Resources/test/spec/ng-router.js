(function() {
  describe('cypress.Route', function() {
    var route, token, tokenText;
    route = null;
    token = null;
    tokenText = null;
    beforeEach(function() {
      token = ['variable', '.', '...', '_format'];
      tokenText = ['text', 'test'];
      return route = new cypress.Route();
    });
    it('should have a setName', function() {
      return expect(route.setName).toBeDefined;
    });
    it('should have a setData', function() {
      return expect(route.setData).toBeDefined;
    });
    it('should have a setName method that set the name variable', function() {
      route.setName('test');
      return expect(route.name).toEqual('test');
    });
    it('should have a setData method that set the data variable', function() {
      route.setData('test');
      return expect(route.data).toEqual('test');
    });
    describe('hasDefault', function() {
      return it('should respond true for default present', function() {
        route.setData({
          defaults: {
            _format: null
          }
        });
        return expect(route.hasDefault('_format')).toBeTruthy();
      });
    });
    describe('extractTokens', function() {
      it('should respond an empty string without tokens', function() {
        return expect(route.extractTokens([])).toEqual('');
      });
      it('should concatenate tokens', function() {
        route.setData({
          defaults: {}
        });
        return expect(route.extractTokens([token])).toEqual('.:_format');
      });
      it('should not add tokens that have default to null', function() {
        route.setData({
          defaults: {
            _format: null
          }
        });
        expect(route.extractTokens([token])).toEqual('');
        route.setData({
          defaults: {
            _format: false
          }
        });
        expect(route.extractTokens([token])).not.toEqual('');
        route.setData({
          defaults: {
            _format: ''
          }
        });
        return expect(route.extractTokens([token])).not.toEqual('');
      });
      return it('should concatenate the tokens', function() {
        route.setData({
          defaults: {}
        });
        return expect(route.extractTokens([token, tokenText])).toEqual('test.:_format');
      });
    });
    return describe('getResource', function() {
      it('should respond / without tokens', function() {
        route.setData({});
        return expect(route.getResource()).toBe('/');
      });
      return it('should respond an url with tokens', function() {
        route.setData({
          defaults: {},
          tokens: [token, tokenText]
        });
        return expect(route.getResource()).not.toBe('/');
      });
    });
  });

}).call(this);
