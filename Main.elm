module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (on, onClick)
import Recipe exposing (..)

-- MSG

type Msg
    = Activate Recipe
    | None

-- MODEL

type alias Model =
    { recipes: List Recipe
    , activeRecipe: Maybe Recipe
    }

type alias Recipe =
    { id: String
    , title: String
    , description: String
    , small_photo_src: String
    , photo_src: String
    }

initialModel : Model
initialModel =
    { recipes = recipes 
    , activeRecipe = Nothing
    }

-- UPDATE

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Activate recipe ->
            ( { model | activeRecipe = Just recipe, recipes = [] }, Cmd.none )

        None ->
            ( model , Cmd.none )

-- VIEW

view : Model -> Html Msg
view model =
    div [ class "recipes-container" ]
        [ div []
            (List.map recipeCard model.recipes),
            case model.activeRecipe of
                Nothing ->
                    div [] []
                Just recipe ->
                    div [] [text recipe.title]
        ]

recipeCard : Recipe -> Html Msg
recipeCard recipe =
    div [ class "recipe-card" ]
        [ img [ src recipe.photo_src, height 500, width 500, onClick (Activate recipe)] [] 
        , span [] [ text (toString recipe.title) ]]

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
