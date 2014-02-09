'use strict'

window.cypress = {}

class cypress.Route
    setName: (name) ->
        @name = name

    setData: (data) ->
        @data = data

    getResource: ->
        out = ''
        if @data.tokens?
            out = @extractTokens(@data.tokens)
        if out == ''
            out = '/'
        out

    getHost: ->
        if @data.hosttokens.length > 0
            @extractTokens(@data.hosttokens)

    extractTokens: (tokens = []) ->
        out = ''
        tokens.forEach (token) =>
            switch token[0]
                when 'variable'
                    if @hasDefault(token[3]) and @getDefault(token[3]) == null
                        return
                    out = "#{token[1]}:#{token[3]}" + out
                when 'text' then out = token[1] + out
        out

    hasDefault: (property) ->
        @data.defaults.hasOwnProperty property

    getDefault: (property) ->
        @data.defaults[property]

class cypress.NgRouter
    @routes = []

    @setData: (configs) ->
        @baseUrl = configs.base_url
        @prefix = configs.prefix
        @host = configs.host
        @scheme = configs.scheme

        for key of configs.routes
            route = new cypress.Route()
            route.setName key
            route.setData configs.routes[key]
            @routes.push route

    generateResourceUrl: (routeName) ->
        path = @findRoute(routeName)?.getResource()
        host = @findRoute(routeName)?.getHost()
        "#{cypress.NgRouter.scheme}://#{host}#{cypress.NgRouter.baseUrl}#{path}"

    findRoute: (routeName) ->
        matchedRoute = null
        cypress.NgRouter.routes.forEach (route) ->
            if route.name == routeName
                matchedRoute = route
        return matchedRoute

window.NgRouting = new cypress.NgRouter()
