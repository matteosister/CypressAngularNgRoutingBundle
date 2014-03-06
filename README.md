#AngularNgRoutingBundle

[![Build Status](https://travis-ci.org/matteosister/CypressAngularNgRoutingBundle.png?branch=master)](https://travis-ci.org/matteosister/CypressAngularNgRoutingBundle)

A Symfony2 bundle to expose your routing in [Angular.js resource format](http://docs.angularjs.org/api/ngResource.$resource)

This bundle depends on [FOSJsRoutingBundle](https://github.com/FriendsOfSymfony/FOSJsRoutingBundle)

##Installation

``` json
{
    "require": {
        "cypresslab/angular-ng-routing-bundle": "~1.0"
    }
}
```

and enable the bundle in the kernel. Remember to publish assets with:

```
$ php app/console assets:install --symlink web #change this to your requirements
```

##Usage

Follow the [docs of FOSJsRoutingBundle](https://github.com/FriendsOfSymfony/FOSJsRoutingBundle/blob/master/Resources/doc/index.md)

You will add, at some point in your views, something like:

``` html+jinja
<script src="{{ asset('bundles/fosjsrouting/js/router.js') }}"></script>
<script src="{{ path('fos_js_routing_js', {"callback": "fos.Router.setData"}) }}"></script>
```

Just add these two more lines

``` html+jinja
<script src="{{ asset('bundles/cypressangularngrouting/ng-router.js') }}"></script>
<script src="{{ path('fos_js_routing_js', {"callback": "cypress.NgRouter.setData"}) }}"></script>
```

This will register in the global namespace an object named **NgRouting**

You can use it like this:

``` javascript
var url = NgRouting.generateResourceUrl('api_saves_get_documents');
// url now is something like: /app_dev.php/saves/:id
var resource = $resource(url, { id: 2 }, { 'create': { method: 'PUT' } })
```
