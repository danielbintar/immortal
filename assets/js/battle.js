export var Battle = { run: function() {

  let attackBtn         = document.querySelector("#battle-attack")
  let messagesContainer = document.querySelector("#battle-messages")
  let enemyHealth       = document.querySelector("#battle-enemy-health")
  let playerHealth      = document.querySelector("#battle-player-health")
  let room              = document.querySelector("#battle-room")

  let roomId  = room.innerHTML
  let channel = socket.channel("battle:p2p:" + roomId)

  attackBtn.addEventListener("click", event => {
    var body = {
      action: "attack",
      room_id: roomId
    }
    channel.push("action", {body: body})
  })

  channel.on("update", payload => {
    enemyHealth.innerHTML = payload.enemy.health
    playerHealth.innerHTML = payload.player.health

    let messageItem = document.createElement("li")
    messageItem.innerText = `${payload.message}`
    messagesContainer.appendChild(messageItem)
  })

  channel.join("data")
    .receive("ok", resp => { console.log("Joined successfully", resp) })
    .receive("error", resp => { console.log("Unable to join", resp) })
}}
