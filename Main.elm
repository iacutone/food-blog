module Main exposing (Model, Msg(..), Recipe, appendRecipes, displayActiveRecipe, filterRecipes, filterRecipesInput, init, main, recipeCard, recipeList, update, view)

import Array exposing (..)
import Browser
import Browser.Navigation as Nav
import Char exposing (fromCode)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (on, onClick, onInput)
import Json.Decode
import Markdown exposing (toHtml)
import Recipe
import String exposing (fromChar)
import Url



-- MSG


type Msg
    = Filter String
    | LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | None


type UrlRequest
    = Internal Url.Url
    | External String


type Recipe
    = Recipe



-- MODEL


type alias Model =
    { recipes : List Recipe.Recipe
    , activeRecipe : Maybe Recipe.Recipe
    , recipeCount : Int
    , key : Nav.Key
    , url : Url.Url
    }



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Filter query ->
            let
                filteredRecipes =
                    filterRecipes model query
            in
            ( { model | recipes = filteredRecipes }, Cmd.none )

        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    case url.path of
                        "/" ->
                            ( { model | activeRecipe = Nothing }, Nav.pushUrl model.key (Url.toString url) )

                        _ ->
                            let
                                recipe =
                                    List.head
                                        (List.filter
                                            (\r ->
                                                r.path == url.path
                                            )
                                            Recipe.recipes
                                        )
                            in
                            case recipe of
                                Just r ->
                                    ( { model | activeRecipe = Just r }, Nav.pushUrl model.key (Url.toString url) )

                                Nothing ->
                                    ( { model | activeRecipe = Nothing }, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            case url.fragment of
                Just f ->
                    let
                        recipe =
                            List.head
                                (List.filter (\r -> r.path == "/#" ++ f)
                                    Recipe.recipes
                                )
                    in
                    case recipe of
                        Just r ->
                            ( { model | activeRecipe = Just r, url = url }, Cmd.none )

                        Nothing ->
                            ( { model | activeRecipe = Nothing }, Cmd.none )

                Nothing ->
                    ( { model | activeRecipe = Nothing }, Cmd.none )

        None ->
            ( model, Cmd.none )


appendRecipes list model =
    if list == [] then
        model.recipes

    else
        model.recipes ++ list



-- VIEW


view : Model -> Browser.Document Msg
view model =
    { title = "Recipes"
    , body =
        [ h1 [ class "title" ] [ text "Recipes" ]
        , div []
            [ filterRecipesInput model
            , div []
                [ recipeList model
                , case model.activeRecipe of
                    Nothing ->
                        div [] []

                    Just recipe ->
                        displayActiveRecipe recipe
                ]
            ]
        ]
    }


recipeList : Model -> Html Msg
recipeList model =
    case model.activeRecipe of
        Nothing ->
            div [ class "recipes-container" ]
                (List.map
                    recipeCard
                    model.recipes
                )

        Just recipe ->
            div [] []


recipeCard : Recipe.Recipe -> Html Msg
recipeCard recipe =
    a [ href recipe.path, class "recipe-card" ]
        [ img [ class "recipe-img", src recipe.small_photo_src ] []
        , div [ class "card-title" ] [ text recipe.title ]
        , case recipe.tags of
            Nothing ->
                div [] []

            Just tags ->
                div []
                    (List.map
                        displayTag
                        tags
                    )
        ]


displayActiveRecipe : Recipe.Recipe -> Html Msg
displayActiveRecipe recipe =
    div [ class "active-recipe" ]
        [ h1 [ class "active-recipe-title" ] [ text recipe.title ]
        , img [ class "active-recipe-img", src recipe.photo_src ] []
        , Markdown.toHtml [ class "active-recipe-description" ] recipe.description
        ]


displayTag : String -> Html Msg
displayTag tag =
    small [ class "card-tags" ] [ text tag ]


filterRecipesInput : Model -> Html Msg
filterRecipesInput model =
    case model.activeRecipe of
        Nothing ->
            div [ class "search-field" ]
                [ input [ class "search-field", placeholder "Search for a recipe", onInput Filter ] []
                ]

        Just recipe ->
            div [] []


filterRecipes : Model -> String -> List Recipe.Recipe
filterRecipes model query =
    if query == "" then
        Recipe.recipes

    else
        List.filter (\recipe -> String.contains query recipe.title) Recipe.recipes


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- MAIN


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    ( initialModel key url, Cmd.none )


initialModel key url =
    { recipes = List.take 6 Recipe.recipes
    , activeRecipe = Nothing
    , recipeCount = 6
    , key = key
    , url = url
    }


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }
