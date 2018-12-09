port module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as D
import Json.Encode as E


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- MODEL


type alias Flags =
    List Message


type alias Message =
    { name : String
    , body : String
    }


type alias Model =
    { username : String
    , userMessage : String
    , chatMessages : List Message
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { username = ""
      , userMessage = ""
      , chatMessages = flags
      }
    , Cmd.none
    )


decodeFlags =
    D.decodeString (D.array decodeMessage)



-- UPDATE


type Msg
    = UserName String
    | UserMessage String
    | SendMessage
    | RecieveMessage E.Value


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UserName content ->
            ( { model | username = content }, Cmd.none )

        UserMessage content ->
            ( { model | userMessage = content }, Cmd.none )

        SendMessage ->
            ( { model
                | userMessage = ""
              }
            , outgoingMessage
                (E.object [ ( "name", E.string model.username ), ( "body", E.string model.userMessage ) ])
            )

        RecieveMessage value ->
            let
                result =
                    D.decodeValue decodeMessage value
            in
            case result of
                Ok message ->
                    ( { model | chatMessages = model.chatMessages ++ [ message ] }, Cmd.none )

                _ ->
                    ( model, Cmd.none )


port outgoingMessage : E.Value -> Cmd msg


port incomingMessage : (E.Value -> msg) -> Sub msg


decodeMessage : D.Decoder Message
decodeMessage =
    D.map2 Message
        (D.field "name" D.string)
        (D.field "body" D.string)



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    incomingMessage RecieveMessage



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "flex justify-center min-h-half-screen pt-6 border" ]
        [ div [ class "w-full max-w-xs mr-6" ]
            [ Html.form
                [ onSubmit SendMessage
                , class "bg-white shadow-md rounded px-8 pt-6 pb-8 mb-4"
                ]
                [ input
                    [ onInput UserName
                    , value model.username
                    , class "shadow appearance-none border rounded w-full py-2 px-3 text-grey-darker leading-tight focus:outline-none focus:shadow-outline mb-4"
                    , type_ "text"
                    , placeholder "Username"
                    ]
                    []
                , input
                    [ onInput UserMessage
                    , value model.userMessage
                    , class "shadow appearance-none border rounded w-full py-2 px-3 text-grey-darker leading-tight focus:outline-none focus:shadow-outline mb-4"
                    , type_ "text"
                    , placeholder "Message"
                    ]
                    []
                , button
                    [ class "bg-white hover:bg-indigo-lighter border border-indigo-lighter text-indigo font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline"
                    , type_ "submit"
                    ]
                    [ text "send" ]
                ]
            ]
        , div [ class "w-full max-w-xs" ]
            [ div
                [ class "shadow appearance-none border rounded w-full py-2 px-3 text-grey-darker leading-tight mb-4 h-chat overflow-y-auto" ]
                (List.map viewChatMessages model.chatMessages)
            ]
        ]


viewChatMessages : Message -> Html Msg
viewChatMessages message =
    p [ class "mb-2 p-2 border-b" ] [ text (message.name ++ " : " ++ message.body) ]
