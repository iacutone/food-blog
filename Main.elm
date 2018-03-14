module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (on, onClick)
import Recipe exposing (..)

-- MSG

type Msg
    = None

-- MODEL

type alias Model =
    { 
    recipes: List Recipe
    }

type alias Recipe =
    { id: String
    , description: String
    , photo_src: String
    }

initialModel : Model
initialModel =
    { recipes = [] }

-- UPDATE

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        None ->
            ( model , Cmd.none )

-- VIEW

view : Model -> Html Msg
view model =
    div []
        [ div []
            (List.map recipeCard recipes)
        ]

recipeCard : Recipe -> Html Msg
recipeCard recipe =
    div []
        [ img [ src recipe.photo_src ] [] 
        , span [] [ text recipe.description ]]

init : (Model, Cmd Msg)
init =
    ( initialModel, Cmd.none )

main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = (always Sub.none)
        }
