module Types (..) where


type alias Answer =
  { name : String
  , images : List String
  }


type alias Model =
  { query : String
  , queryType : String
  , answers : List Answer
  , currentPage : Int
  }


type Action
  = QueryChange String
  | QueryTypeChange String
  | Query
  | RegisterAnswers (Maybe (List Answer))
  | ChangePage Int
