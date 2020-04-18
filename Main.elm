module Main exposing (Model, Msg(..), Recipe, ScrollInfo, appendRecipes, backButton, displayActiveRecipe, filterRecipes, filterRecipesInput, init, main, onScroll, recipeCard, recipeList, scrollInfoDecoder, update, view)

-- import Browser exposing (UrlRequest(..))

import Array exposing (..)
import Browser
import Browser.Navigation as Nav
import Char exposing (fromCode)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (on, onClick, onInput)
import Json.Decode
import Markdown exposing (toHtml)
import Recipe exposing (..)
import String exposing (fromChar)
import Url



-- MSG


type Msg
    = Activate Recipe
    | RenderRecipeList
    | Filter String
    | ScrollEvent ScrollInfo
    | LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | None


type Page
    = Index



-- MODEL


type alias Model =
    { recipes : List Recipe
    , activeRecipe : Maybe Recipe
    , recipeCount : Int
    , key : Nav.Key
    , url : Url.Url
    }


type alias Recipe =
    { id : String
    , title : String
    , description : String
    , small_photo_src : String
    , photo_src : String
    }


type alias ScrollInfo =
    { scrollHeight : Int
    , scrollTop : Int
    , offsetHeight : Int
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
                filteredRecipes =
                    filterRecipes model query
            in
            ( { model | recipes = filteredRecipes }, Cmd.none )

        ScrollEvent { scrollHeight, scrollTop, offsetHeight } ->
            if (scrollHeight - scrollTop) <= offsetHeight then
                let
                    num =
                        model.recipeCount + 3

                    lisfOfRecipes =
                        Array.fromList recipes
                            |> Array.slice model.recipeCount num
                            |> Array.toList

                    appendedRecipes =
                        appendRecipes lisfOfRecipes model
                in
                ( { model | recipes = appendedRecipes, recipeCount = num }, Cmd.none )

            else
                ( model, Cmd.none )

        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            ( { model | url = url }
            , Cmd.none
            )

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
        [ h1 [ class "title" ] [ text "Recipes by EV" ]
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
            div [ class "recipes-container", onScroll ScrollEvent ] (List.map recipeCard model.recipes)

        Just recipe ->
            div [] []


recipeCard : Recipe -> Html Msg
recipeCard recipe =
    div [ class "recipe-card" ]
        [ img [ class "recipe-img", src recipe.small_photo_src, onClick (Activate recipe) ] []
        , div [ class "card-title" ] [ text recipe.title ]
        ]


displayActiveRecipe : Recipe -> Html Msg
displayActiveRecipe recipe =
    div [ class "active-recipe" ]
        [ backButton
        , h1 [ class "active-recipe-title" ] [ text recipe.title ]
        , img [ class "active-recipe-img", src recipe.photo_src ] []
        , Markdown.toHtml [ class "active-recipe-description" ] recipe.description
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
            div [ class "search-field" ]
                [ input [ class "search-field", placeholder "... search", onInput Filter ] []
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



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- MAIN


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    ( initialModel key url, Cmd.none )


initialModel key url =
    { recipes = List.take 6 recipes
    , activeRecipe = Nothing
    , recipeCount = 6
    , key = key
    , url = url
    }



-- init : ( Model, Cmd Msg )
-- init =
--     ( initialModel, Cmd.none )
-- initialModel : Model
-- initialModel =
--     { recipes = List.take 6 recipes
--     , activeRecipe = Nothing
--     , recipeCount = 6
--     }


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



-- { init = \() -> init
-- , update = update
-- , subscriptions = always Sub.none
-- , view = view
-- , onUrlChange = ChangedUrl
-- , onUrlRequest = ClickedLink
-- }
