# Overlapping routes
At my work (Channable) we use flask-restful to build our REST APIs.

Today I was debugging a bug where certain actions on our API wouldn't come through. After a long and boring debugging sessions
I realised the issue was a very trivial mistake in this piece of code:

```python
api.add_resource(ApiCategoriesResource, '/users/<int:user_id>/projects/<int:project_id>/apis/<int:api_id>/categories')
api.add_resource(ApiCategoriesAttributesResource, '/users/<int:user_id>/projects/<int:project_id>/apis/<int:api_id>/categories/<string:category_id>')
api.add_resource(ApiCategoriesDatastreamResource, '/users/<int:user_id>/projects/<int:project_id>/apis/<int:api_id>/categories/<string:category_id>/datastream')
api.add_resource(CategoriesResource, '/users/<int:user_id>/projects/<int:project_id>/<string:channel>/<int:channel_id>/categories')
api.add_resource(CategoriesCopyResource, '/users/<int:user_id>/projects/<int:project_id>/<string:channel>/<int:channel_id>/categories/copy')
api.add_resource(CategoriesSearchResource, '/users/<int:user_id>/projects/<int:project_id>/<string:channel>/<int:channel_id>/categories/search')
api.add_resource(CategoriesQueryResource, '/users/<int:user_id>/projects/<int:project_id>/<string:channel>/<int:channel_id>/categories/query')
api.add_resource(CategoriesGenerateResource, '/users/<int:user_id>/projects/<int:project_id>/<string:channel>/<int:channel_id>/categories/generate')
```

Can you spot it?


It resides in these two definitions:
```python
api.add_resource(ApiCategoriesResource, '/users/<int:user_id>/projects/<int:project_id>/apis/<int:api_id>/categories')
api.add_resource(CategoriesResource, '/users/<int:user_id>/projects/<int:project_id>/<string:channel_type>/<int:channel_id>/categories')
```

if   `channel_type == "apis"` then these two routes overlap! Thus it this request will be handled by whatever the underlying framework chooses!
Which is not very nice. 


Servant suffers from a similar problem:

```
TODO: example here
```




In Servis, we can prove statically, that no route can overlap. If such a definition is made, a compiler error is thrown



# Dependent routing
Sometimes, we want interdependencies in our routes. An example of a very common REST query:

```
/users?limit=100
```

If would be nice if we could verif at compile time that this route never returns more than 100 elements.  In haskell, this is currently not possible, because types can not depend on values, but in idris, we _can_ accomplish this by extending the Servant DSL with Pi-types.


# Explicit status codes
Currently, in servant there is no description of what status codes a resource can return. This could be added though.

In idris, we can add status codes to the DSL, and make sure that all paths of our handler return a status code such that.  `statuscode `elem` possibleStatusCodes`.  If we return a `401: Unauthorized` if our definition says :` statusCodes = [402, 404]`. Then this can be a compiler error.  This way, we keep our business logic in sync with the descriptions of our APIs


# A Kind for APIs
Because Servant wants to be extensible, the DSL lives in the open kind `*`.  One of the two open kinds in Haskell. (The other is `Constraint`).

This makes it possible for the user to easily make malformed api definitions that have no interpretation in any of the servant type families.

For example.  Both `(:>) :: * -> * -> *` and  `(->) :: * -> * -> *` .  So one could accidentally mixup `:>` and `->` whilst `->` (the type constructor for functions) is not part of the Servant DSL. so no type family will accept it, leading to an obscure error 

This is an erro that happens _A lot_ with servant uses. See https://www.reddit.com/r/haskell/comments/4uaef3/help_with_servantclient071/


This can be solved in both Haskell and Idris. In haskell we can do this by defining a closed kind for the DSL . The kind `API` would be introduced such that `(:>) :: API -> API -> API`.

In Idris, we do not distinct in types and kinds, so we introduce the datatype `API` that has a data constructor `(:>) : API -> API -> API` for example.

We lose the extensibility of servant. But I (and tel (https://github.com/tel/serv) argue that HTTP is well-defined enough that a library can give you all the bells and whistles needed to cover 99% of all API building needs. And that we can thus give up some extensibility for more safety and better error messages


