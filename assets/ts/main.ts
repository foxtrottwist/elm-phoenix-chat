import 'phoenix_html'
import '../css/main.css'
// @ts-ignore currently ignoring [ts 2307] for Elm import
import { Elm } from '../elm/src/Main.elm'
import { Socket as PhoenixSocket } from 'phoenix'

fetch('/api/messages')
  .then(data => data.json())
  .then(data => {
    const app = Elm.Main.init({
      node: document.getElementById('elm-node'),
      flags: data.data,
    })

    const socket = new PhoenixSocket('/socket', {})
    socket.connect()
    const channel = socket.channel('privet:lobby', {})
    channel.join()

    interface IMessage {
      name: string
      body: string
    }

    app.ports.outgoingMessage.subscribe((message: IMessage) => {
      channel.push('shout', message)
    })

    channel.on('shout', (broadcastMessage: IMessage) => {
      app.ports.incomingMessage.send(broadcastMessage)
    })
  })
