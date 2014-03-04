describe 'cypress.Route', ->
    route = null
    token = null
    tokenText = null
    beforeEach ->
        token = ['variable', '.', '...', '_format']
        tokenText = ['text', 'test']
        route = new cypress.Route()

    it 'should have a setName', ->
        expect(route.setName).toBeDefined

    it 'should have a setData', ->
        expect(route.setData).toBeDefined

    it 'should have a setName method that set the name variable', ->
        route.setName 'test'
        expect(route.name).toEqual 'test'

    it 'should have a setData method that set the data variable', ->
        route.setData 'test'
        expect(route.data).toEqual 'test'

    describe 'hasDefault', ->
        it 'should respond true for default present', ->
            route.setData { defaults: { _format: null } }
            expect(route.hasDefault('_format')).toBeTruthy()

    describe 'extractTokens', ->
        it 'should respond an empty string without tokens', ->
            expect(route.extractTokens []).toEqual ''

        it 'should concatenate tokens', ->
            route.setData { defaults: {  } }
            expect(route.extractTokens [token]).toEqual '.:_format'

        it 'should not add tokens that have default to null', ->
            route.setData { defaults: { _format: null } }
            expect(route.extractTokens [token]).toEqual ''
            route.setData { defaults: { _format: false } }
            expect(route.extractTokens [token]).not.toEqual ''
            route.setData { defaults: { _format: '' } }
            expect(route.extractTokens [token]).not.toEqual ''

        it 'should concatenate the tokens', ->
            route.setData { defaults: { } }
            expect(route.extractTokens [token, tokenText]).toEqual 'test.:_format'

    describe 'getResource', ->
        it 'should respond / without tokens', ->
            route.setData {}
            expect(route.getResource()).toBe '/'

        it 'should respond an url with tokens', ->
            route.setData {defaults: {}, tokens: [token, tokenText]}
            expect(route.getResource()).not.toBe '/'

    describe 'getHost', ->
        it 'should respond a tokenized host', ->
            route.setData {defaults: {}, hosttokens: [token]}
            expect(route.getHost()).toBe '.:_format'

        it 'should respond a default host without tokens', ->
            route.setData {defaults: {}, hosttokens: []}
            route.setDefaultHost 'test.dev'
            expect(route.getHost()).toBe 'test.dev'