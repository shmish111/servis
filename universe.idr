
Map : Type -> Type -> Type
Map k v = List (k, v)

data Path : Type where
  Const : String -> Path
  Segment : String -> Type -> Path

data Handler : Type where

data Verb : Type where
  GET : Verb
  PUT : Verb
  POST : Verb
  DELETE : Verb

data Api : Type where
  Endpoint : Map Verb Handler -> Api
  -- OneOf    : List Api -> Api  TODO implement
  (:>)     : Path -> Api -> Api

infixr 5 :>

data ApiUser

--  "GET /users/1"
userApi : Api
userApi = Segment "userId" Int :> Endpoint [(GET, ?api)]


interpretApi : Api -> Type
interpretApi a = Int -> IO ApiUser

getFromDatabase : Int -> IO ApiUser
getFromDatabase = ?magichappenshere

-- here is where the magic happens!!!
handleUserApi : interpretApi (userApi)
handleUserApi = getFromDatabase

{-data Path : Type where
  Const    : String -> Path
  Capture  : String -> Type -> Path
  Wildcard : Path


data Handler : Type where
  Outputs : Body -> Handler
    -- ^ TODO: StatusCodes?
  CaptureBody : ContentType -> Type -> Handler

data Output : Type where
  Respond : SortedMap HeaderName Type -> Body -> Output

data Body : Type where
  HasBody : ContentType -> Type -> Body

data ContentType : Type where
  JSON : ContentType


api : Api
api =
  OneOf
    ["users" :> Capture "userId" Int :> Endpoint handlers]

handlers : SortedMap Verb Handler
handlers =
  fromList
    [ (GET, getHandler)
    , (PPUT, putHandler)
    ]

getHandler : Handler
getHandler = Outputs User
-}
