module Rest (..) where

import Effects exposing (Effects, Never)
import Types exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode exposing ((:=), Decoder)
import Signal exposing (message, forwardTo, Address)
import Task
import Types exposing (..)


search : String -> String -> Effects Action
search query itemType =
  Http.get decodeAnswers (searchUrl query itemType)
    |> Task.toMaybe
    |> Task.map RegisterAnswers
    |> Effects.task


searchUrl : String -> String -> String
searchUrl query itemType =
  Http.url
    "https://api.spotify.com/v1/search"
    [ ( "q", query )
    , ( "type", itemType )
    ]


decodeAnswers : Decoder (List Answer)
decodeAnswers =
  let
    albumName =
      Decode.map Answer ("name" := Decode.string)

    albumImage =
      Decode.at [ "url" ] Decode.string

    albumImages =
      Decode.list albumImage

    album =
      Decode.object2 Answer ("name" := Decode.string) ("images" := albumImages)
  in
    Decode.oneOf
      [ (Decode.at [ "albums", "items" ] (Decode.list album))
      , (Decode.at [ "artists", "items" ] (Decode.list album))
      ]
