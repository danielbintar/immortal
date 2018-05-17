export let Game = { run: function() {
  let ctx = null;
  let tile = new Dimension(40, 40);
  let map = new Dimension(20, 20);
  let lastFrameTime = 0;

  function Dimension(width, height) {
    this.width = width;
    this.height = height;
  }

  function Coordinate(x, y) {
    this.x = x;
    this.y = y;
  }

  Coordinate.prototype.round = function() {
    this.x = Math.round(this.x);
    this.y = Math.round(this.y); 
  }

  Coordinate.prototype.placeAt = function(x, y) {
    this.x = x;
    this.y = y;
  }

  function TileType (colour, floorType, sprites) {
    this.colour = colour;
    this.floorType = floorType;
    this.sprites = sprites;
  }

  function Character() {
    this.tileFrom = new Coordinate(1, 1);
    this.tileTo = new Coordinate(1, 1);
    this.dimension = new Dimension(30, 30);
    this.position = new Coordinate(45, 45);
    this.timeMoved = 0;
    this.delayMove = 200;

    this.idle = true;
    this.direction = directions.up
    this.direction_counter = 0;

    this.sprites = {}
    this.sprites[directions.up] = [
      {x: 0, y: 600, w: 150, h: 200},
      {x: 150, y: 600, w: 150, h: 200},
      {x: 300, y: 600, w: 150, h: 200},
      {x: 450, y: 600, w: 150, h: 200}
    ];
    this.sprites[directions.right] = [
      {x: 0, y: 200, w: 150, h: 200},
      {x: 150, y: 200, w: 150, h: 200},
      {x: 300, y: 200, w: 150, h: 200},
      {x: 450, y: 200, w: 150, h: 200}
    ];
    this.sprites[directions.down] = [
      {x: 0, y: 0, w: 150, h: 200},
      {x: 150, y: 0, w: 150, h: 200},
      {x: 300, y: 0, w: 150, h: 200},
      {x: 450, y: 0, w: 150, h: 200}
    ];
    this.sprites[directions.left] = [
      {x: 0, y: 400, w: 150, h: 200},
      {x: 150, y: 400, w: 150, h: 200},
      {x: 300, y: 400, w: 150, h: 200},
      {x: 450, y: 400, w: 150, h: 200}
    ];
  }

  Character.prototype.moving = function() {
    this.direction_counter++;
    if(this.direction_counter > 3)this.direction_counter = 0;
  }

  Character.prototype.placeAt = function(x, y) {
    this.tileFrom.placeAt(x, y);
    this.tileTo.placeAt(x, y);
    this.position.placeAt(
      ((tile.width * x) + ((tile.width - this.dimension.width) / 2)),
      ((tile.height * y) + ((tile.height - this.dimension.height) / 2))
    );
  }

  Character.prototype.processMovement = function(t) {
    if(this.tileFrom.x == this.tileTo.x && this.tileFrom.y == this.tileTo.y) {
      this.idle = true;
      return false;
    }
    
    this.idle = false;


    if((t - this.timeMoved) >= this.delayMove)this.placeAt(this.tileTo.x, this.tileTo.y);
    else {
      this.position.placeAt(
        (this.tileFrom.x * tile.width) + ((tile.width - this.dimension.width) / 2),
        (this.tileFrom.y * tile.height) + ((tile.height - this.dimension.height) / 2), 
      );

      if(this.tileTo.x != this.tileFrom.x) {
        let diff = (tile.width / this.delayMove) * (t - this.timeMoved);
        this.position.x += (this.tileTo.x < this.tileFrom.x) ? -diff : diff;
      }

      if(this.tileTo.y != this.tileFrom.y) {
        let diff = (tile.height / this.delayMove) * (t - this.timeMoved);
        this.position.y += (this.tileTo.y < this.tileFrom.y) ? -diff : diff;
      }

      this.position.round()
    }
    return true;
  }

  let currentSecond = 0, frameCount = 0, frameLastSecond = 0;

  let tileset = null, tilesetUrl = "/images/tileset.png", tilesetLoaded = false;
  let playerset = null, playersetUrl = "/images/playerset.png", playersetLoaded = false;

  let floorTypes = {
    solid : 0,
    path  : 1,
    water : 2
  };

  let tileTypes = {
    0 : new TileType("#685b48", floorTypes.solid, [{x: 0, y: 0, w: 40, h: 40}]),
    1 : new TileType("#5aa457", floorTypes.path, [{x: 40, y: 0, w: 40, h: 40}]),
    2 : new TileType("#e8bd7a", floorTypes.path, [{x: 80, y: 0, w: 40, h: 40}]),
    3 : new TileType("#286625", floorTypes.solid, [{x: 120, y: 0, w: 40, h: 40}]),
    4 : new TileType("#678fd9", floorTypes.water, [{x: 160, y: 0, w: 40, h: 40}]),
  };

  let directions = {
    up : 0,
    right : 1,
    down : 2,
    left : 3
  }

  let keysDown = {
    37 : false,
    38 : false,
    39 : false,
    40 : false,
  };

  let player = new Character();

  let gameMap = [
    [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
    [0,1,0,0,0,0,0,3,3,3,0,0,0,0,0,0,0,0,0,0],
    [0,1,3,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0],
    [0,1,3,4,4,4,4,1,1,1,0,0,0,0,0,0,0,0,0,0],
    [0,1,4,4,4,4,4,1,1,1,0,0,0,0,0,0,0,0,0,0],
    [0,1,4,4,1,1,1,1,3,3,0,0,0,0,0,0,0,0,0,0],
    [0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0],
    [0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
    [0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
    [0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
    [0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
    [0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
    [0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
    [0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
  ]

  let viewPort = {
    screen    : new Dimension(0, 0),
    startTile : new Coordinate(0, 0),
    endTile   : new Coordinate(0, 0),
    offset    : new Coordinate(0, 0),

    update    : function(px, py) {
      this.offset.placeAt(
        Math.floor((this.screen.width / 2) - px),
        Math.floor((this.screen.height / 2) - py),
      );

      let tempTile = new Coordinate(
        Math.floor(px / tile.width),
        Math.floor(py / tile.height)
      );

      this.startTile.placeAt(
        tempTile.x - 1 - Math.ceil((this.screen.width / 2) / tile.width),
        tempTile.y - 1 - Math.ceil((this.screen.height / 2) / tile.height)
      );
      if(this.startTile.x < 0)this.startTile.x = 0;
      if(this.startTile.y < 0)this.startTile.y = 0;

      this.endTile.placeAt(
        tempTile.x + 1 + Math.ceil((this.screen.width / 2) / tile.width),
        tempTile.y + 1 + Math.ceil((this.screen.height / 2) / tile.height)
      );
      if(this.endTile.x > map.width)this.endTile.x = map.width - 1;
      if(this.endTile.y > map.height)this.endTile.y = map.height - 1;
    }
  }

  window.onload = function() {
    ctx = document.getElementById("game").getContext("2d");
    requestAnimationFrame(drawGame);
    ctx.font = "bold 10pt sans-serif";

    window.addEventListener("keydown", function(e) {
      if(e.keyCode >= 37 && e.keyCode <= 40 && player.idle) {
        keysDown[e.keyCode] = true;
      }
    });

    window.addEventListener("keyup", function(e) {
      if(e.keyCode >= 37 && e.keyCode <= 40) {
        keysDown[e.keyCode] = false;
      }
    });

    viewPort.screen = new Dimension(
      document.getElementById("game").width,
      document.getElementById("game").height,
    );

    tileset = new Image();
    tileset.onerror = function() {
      ctx = null;
      alert("Failed to load tileset");
    }
    tileset.onload = function() {
      tilesetLoaded = true;
    }
    tileset.src = tilesetUrl;

    playerset = new Image();
    playerset.onerror = function() {
      ctx = null;
      alert("Failed to load playerset");
    }
    playerset.onload = function() {
      playersetLoaded = true;
    }
    playerset.src = playersetUrl;
  }

  function isValidPosition(x, y) {
    return x >= 0 && y >= 0 && x < 40 && y < 40 && tileTypes[gameMap[y][x]].floorType == floorTypes.path;
  }

  function drawGame() {
    if(ctx == null)return;
    if(!tilesetLoaded || !playerset) {
      requestAnimationFrame(drawGame);
      return;
    }

    let currentFrameTime = Date.now();
    let timeElapsed = currentFrameTime - lastFrameTime;

    let sec = Math.floor(Date.now()/1000);
    if(sec != currentSecond) {
      currentSecond = sec;
      frameLastSecond = frameCount;
      frameCount = 1;
    }
    else frameCount++;

    if(!player.processMovement(currentFrameTime)) {
      if(keysDown[38] && isValidPosition(player.tileTo.x, player.tileTo.y - 1)) {
        player.tileTo.y -= 1;
        player.timeMoved = currentFrameTime;
        if(player.direction == directions.up)player.moving();
        else {
          player.direction = directions.up;
          player.direction_counter = 0;
        }
      }
      if(keysDown[40] && isValidPosition(player.tileTo.x, player.tileTo.y + 1)) {
        player.tileTo.y += 1;
        player.timeMoved = currentFrameTime;
        if(player.direction == directions.down)player.moving();
        else {
          player.direction = directions.down;
          player.direction_counter = 0;
        }
      }
      if(keysDown[37] && isValidPosition(player.tileTo.x - 1, player.tileTo.y)) {
        player.tileTo.x -= 1;
        player.timeMoved = currentFrameTime;
        if(player.direction == directions.left)player.moving();
        else {
          player.direction = directions.left;
          player.direction_counter = 0;
        }
      }
      if(keysDown[39] && isValidPosition(player.tileTo.x + 1, player.tileTo.y)) {
        player.tileTo.x += 1;
        player.timeMoved = currentFrameTime;
        if(player.direction == directions.right)player.moving();
        else {
          player.direction = directions.right;
          player.direction_counter = 0;
        }
      }
    }

    viewPort.update(
      player.position.x + (player.dimension.width / 2),
      player.position.y + (player.dimension.height / 2)
    );

    ctx.fillStyle = "#000000";
    ctx.fillRect(0, 0, viewPort.screen.width, viewPort.screen.height);

    for(let y = viewPort.startTile.y; y < viewPort.endTile.y; y++) {
      for(let x = viewPort.startTile.x; x < viewPort.endTile.x; x++) {
        let tempTile = tileTypes[gameMap[y][x]];
        ctx.drawImage(
          tileset,
          tempTile.sprites[0].x, tempTile.sprites[0].y, tempTile.sprites[0].w, tempTile.sprites[0].h,
          viewPort.offset.x + (x * tile.width), viewPort.offset.y + (y * tile.height),
          tile.width, tile.height
        );
      }
    }

    let sprite = player.sprites[player.direction];
    ctx.drawImage(
      playerset,
      sprite[player.direction_counter].x, sprite[player.direction_counter].y,
      sprite[player.direction_counter].w, sprite[player.direction_counter].h,
      viewPort.offset.x + player.position.x,
      viewPort.offset.y + player.position.y,
      player.dimension.width, player.dimension.height
    );

    ctx.fillStyle = "#ff0000";
    ctx.fillText("FPS: " + frameLastSecond, 10, 20);

    lastFrameTime = currentFrameTime;
    requestAnimationFrame(drawGame);
  }

}}
