module View (root) where

import Events exposing (onInput, onEnter)
import Html exposing (..)
import Html.Events exposing (onClick, on, targetValue)
import Html.Attributes exposing (..)
import Signal exposing (message, forwardTo, Address)
import Types exposing (..)


root : Signal.Address Action -> Model -> Html
root address model =
  div
    [ style [ ( "margin", "20px 0" ) ] ]
    [ bootstrap
    , containerFluid
        [ inputForm address model
        , resultsList address model
        ]
    ]


inputForm address model =
  div
    []
    [ input
        [ type' "text"
        , placeholder "Search for an album..."
        , value model.query
        , onInput address QueryChange
        , onEnter address Query
        ]
        []
    , select
        [ on "change" targetValue (\value -> Signal.message address (QueryTypeChange value)) ]
        [ option [ value "artist" ] [ text "Artist" ]
        , option [ value "album" ] [ text "Album" ]
          -- , option [ value "track" ] [ text "Track" ]
          -- , option [ value "track" ] [ text "Track" ]
        ]
    ]


resultsList address model =
  let
    toEntry answer =
      div
        [ class "col-xs-2 col-md-3" ]
        [ resultView answer ]

    answers =
      model.answers
        |> List.drop ((model.currentPage - 1) * perPage)
        |> List.take perPage
  in
    row ((pagination address (List.length model.answers) model.currentPage) :: (List.map toEntry answers))


perPage =
  3


pagination : Signal.Address Action -> Int -> Int -> Html
pagination address count current =
  let
    attributes n =
      if n == current then
        [ class "active" ]
      else
        []

    page n =
      li (attributes n) [ a [ href "#", onClick address (ChangePage n) ] [ text (toString n) ] ]

    lastPage =
      floor ((toFloat count) / perPage)
  in
    nav
      []
      [ ul
          [ class "pagination" ]
          (List.map page [1..lastPage])
      ]


resultView : Answer -> Html
resultView answer =
  let
    images =
      case List.head answer.images of
        Just url ->
          [ img [ src url, style [ ( "width", "100%" ) ] ] [] ]

        Nothing ->
          []
  in
    div
      [ class "panel panel-info" ]
      [ div
          [ class "panel-heading" ]
          [ text "Album" ]
      , div
          [ class "panel-body"
          , style [ ( "height", "10rem" ) ]
          ]
          (text answer.name :: images)
      ]



-- Bootstrap.


containerFluid =
  div [ class "container-fluid" ]


row =
  div [ class "row" ]


bootstrap =
  node
    "link"
    [ href "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css"
    , rel "stylesheet"
    ]
    []
