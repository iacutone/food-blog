module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (on, onClick, onInput)
import Char exposing (fromCode)
import String exposing (fromChar)
import Json.Decode
import Markdown exposing (toHtml)
import Array exposing(..)
import Recipe exposing (..)

-- MSG

type Msg
    = Activate Recipe
    | RenderRecipeList
    | Filter String
    | ScrollEvent ScrollInfo
    | None

-- MODEL

type alias Model =
    { recipes: List Recipe
    , activeRecipe: Maybe Recipe
    , recipeCount: Int
    }

type alias Recipe =
    { id: String
    , title: String
    , description: String
    , small_photo_src: String
    , photo_src: String
    }

type alias ScrollInfo =
    { scrollHeight : Int
    , scrollTop : Int
    , offsetHeight : Int
    }

initialModel : Model
initialModel =
    { recipes = List.take 6 recipes 
    , activeRecipe = Nothing
    , recipeCount = 6
    }

-- UPDATE

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Activate recipe ->
            ( { model | activeRecipe = Just recipe, recipes = [] }, Cmd.none )

        RenderRecipeList ->
            ( { model | activeRecipe = Nothing, recipes = recipes }, Cmd.none )

        Filter query ->
            let
                filteredRecipes = filterRecipes model query
            in
                ( { model | recipes = filteredRecipes },  Cmd.none )            

        ScrollEvent { scrollHeight, scrollTop, offsetHeight } ->
            if (scrollHeight - scrollTop) <= offsetHeight then
                let
                    num = model.recipeCount + 3
                    recipeList =
                        Array.fromList recipes
                            |> Array.slice model.recipeCount num
                            |> Array.toList

                    appendedRecipes = appendRecipes recipeList model
                in
                    ( { model | recipes = appendedRecipes, recipeCount = num }, Cmd.none )
            else
                ( model , Cmd.none )

        None ->
            ( model , Cmd.none )

appendRecipes list model =
    if list == [] then
        model.recipes
    else
        model.recipes ++ list

-- VIEW

view : Model -> Html Msg
view model =
    div []
    [ filterRecipesInput model
    , div [] [
    recipeList model
    , case model.activeRecipe of
        Nothing ->
            div [] []
        Just recipe ->
            displayActiveRecipe recipe
    ]
    ]

recipeList : Model -> Html Msg
recipeList model =
    case model.activeRecipe of
        Nothing ->
            div [ class "recipes-container", onScroll ScrollEvent ] (List.map recipeCard model.recipes)
        Just recipe ->
            div [] []

recipeCard : Recipe -> Html Msg
recipeCard recipe =
        div [ class "recipe-card" ]
        [ img [ class "recipe-img", src recipe.small_photo_src, onClick (Activate recipe)] [] 
        , div [ class "card-title"] [ text recipe.title ]
        ]

displayActiveRecipe : Recipe -> Html Msg
displayActiveRecipe recipe =
    div [ class "active-recipe" ] 
    [ backButton
    , h1 [ class "active-recipe-title" ] [ text recipe.title ]
    , img [ class "active-recipe-img", src recipe.photo_src ] []
    , div [ class "active-recipe-description" ] [ text recipe.description ]
    ]

backButton : Html Msg
backButton =
    let
        closeIcon =
            10006
                |> Char.fromCode
                |> String.fromChar
    in
        button [ class "back-button", onClick RenderRecipeList ] [ text closeIcon ]

filterRecipesInput : Model -> Html Msg
filterRecipesInput model =
    case model.activeRecipe of
        Nothing ->
            div [ class "search-field" ] [
                input [ class "search-field", placeholder "... search", onInput Filter ] []
                ]
        Just recipe ->
            div [] []

filterRecipes : Model -> String -> List Recipe
filterRecipes model query =
    if query == "" then
        recipes
    else
        List.filter (\recipe -> String.contains query recipe.title) recipes

onScroll msg =
    on "scroll" (Json.Decode.map msg scrollInfoDecoder)

scrollInfoDecoder =
    Json.Decode.map3 ScrollInfo
        (Json.Decode.at [ "target", "scrollHeight" ] Json.Decode.int)
        (Json.Decode.at [ "target", "scrollTop" ] Json.Decode.int)
        (Json.Decode.at [ "target", "offsetHeight" ] Json.Decode.int)

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

