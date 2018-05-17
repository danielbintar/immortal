export var Chat = { run: function() {
  let channel = socket.channel("chat:all")

  let chatInput         = document.querySelector("#chat-input")
  let messagesContainer = document.querySelector("#chat-messages")

  chatInput.addEventListener("keypress", event => {
    if(event.keyCode === 13){
      channel.push("new_msg", {body: chatInput.value})
      chatInput.value = ""
    }
  })

  channel.on("new_msg", payload => {
    let messageItem = document.createElement("li")
    messageItem.innerText = `${payload.body}`
    messagesContainer.appendChild(messageItem)
    messagesContainer.scrollTop = messagesContainer.scrollHeight;
  })

  channel.join()
    .receive("ok", resp => { console.log("Joined successfully", resp) })
    .receive("error", resp => { console.log("Unable to join", resp) })
}}
