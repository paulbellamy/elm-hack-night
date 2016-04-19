module State (..) where

import Effects exposing (Effects, Never)
import Events exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Json exposing ((:=))
import Signal exposing (message, forwardTo, Address)
import Task
import Types exposing (..)
import Rest


init : ( Model, Effects Action )
init =
  ( { query = ""
    , queryType = "artist"
    , answers = []
    , currentPage = 1
    }
  , Effects.none
  )


update : Action -> Model -> ( Model, Effects Action )
update action model =
  case action of
    QueryChange newQuery ->
      ( { model | query = newQuery }
      , Effects.none
      )

    QueryTypeChange newType ->
      ( { model | queryType = newType }
      , Rest.search model.query newType
      )

    Query ->
      ( model
      , Rest.search model.query model.queryType
      )

    RegisterAnswers maybeAnswers ->
      ( { model | answers = (Maybe.withDefault [] maybeAnswers), currentPage = 1 }
      , Effects.none
      )

    ChangePage page ->
      ( { model | currentPage = page }
      , Effects.none
      )
