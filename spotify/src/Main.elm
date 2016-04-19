module Main (..) where

import Effects exposing (Never)
import StartApp
import Html
import Types
import State
import Task exposing (Task)
import View


app : StartApp.App Types.Model
app =
  StartApp.start
    { init = State.init
    , update = State.update
    , view = View.root
    , inputs = []
    }


main : Signal Html.Html
main =
  app.html


port tasks : Signal (Task Never ())
port tasks =
  app.tasks
