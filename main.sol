// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract SkateRush {
    uint256 public raceIdCounter;
    uint256 public playerIdCounter;

    struct Player {
        address wallet;
        uint8 skill; // от 1 до 10
        uint256 racesJoined;
    }

    struct Race {
        uint256 id;
        uint256 maxPlayers;
        address[] players;
        bool started;
        bool finished;
        address winner;
    }

    mapping(address => Player) public players;
    mapping(uint256 => Race) public races;

    event PlayerRegistered(address player, uint8 skill);
    event RaceCreated(uint256 raceId, uint256 maxPlayers);
    event JoinedRace(uint256 raceId, address player);
    event RaceStarted(uint256 raceId);
    event RaceFinished(uint256 raceId, address winner);

    modifier onlyRegistered() {
        require(players[msg.sender].wallet != address(0), "Not registered");
        _;
    }

    function register(uint8 _skill) external {
        require(players[msg.sender].wallet == address(0), "Already registered");
        require(_skill >= 1 && _skill <= 10, "Skill must be 1-10");

        players[msg.sender] = Player(msg.sender, _skill, 0);
        emit PlayerRegistered(msg.sender, _skill);
    }

    function createRace(uint256 _maxPlayers) external onlyRegistered {
        require(_maxPlayers >= 2 && _maxPlayers <= 10, "Invalid player count");

        raceIdCounter++;
        Race storage newRace = races[raceIdCounter];
        newRace.id = raceIdCounter;
        newRace.maxPlayers = _maxPlayers;

        emit RaceCreated(raceIdCounter, _maxPlayers);
    }

    function joinRace(uint256 _raceId) external onlyRegistered {
        Race storage race = races[_raceId];
        require(!race.started, "Race already started");
        require(race.players.length < race.maxPlayers, "Race full");

        // Проверка, не добавлен ли уже игрок
        for (uint i = 0; i < race.players.length; i++) {
            require(race.players[i] != msg.sender, "Already joined");
        }

        race.players.push(msg.sender);
        players[msg.sender].racesJoined++;

        emit JoinedRace(_raceId, msg.sender);

        // Автостарт гонки, если достигнут лимит
        if (race.players.length == race.maxPlayers) {
            startRace(_raceId);
        }
    }

    function startRace(uint256 _raceId) internal {
        Race storage race = races[_raceId];
        require(!race.started, "Already started");
        require(race.players.length >= 2, "Not enough players");

        race.started = true;
        emit RaceStarted(_raceId);

        // Завершаем гонку сразу (можно усложнить позже)
        finishRace(_raceId);
    }

    function finishRace(uint256 _raceId) internal {
        Race storage race = races[_raceId];
        require(!race.finished, "Already finished");

        uint256 highestScore = 0;
        address winner;

        for (uint i = 0; i < race.players.length; i++) {
            address p = race.players[i];
            uint8 skill = players[p].skill;

            // Простой рандом: skill + псевдослучайное значение
            uint256 score = uint256(keccak256(abi.encodePacked(block.timestamp, p, _raceId))) % 10;
            score += skill;

            if (score > highestScore) {
                highestScore = score;
                winner = p;
            }
        }

        race.finished = true;
        race.winner = winner;

        emit RaceFinished(_raceId, winner);
    }

    function getRacePlayers(uint256 _raceId) external view returns (address[] memory) {
        return races[_raceId].players;
    }

    function getWinner(uint256 _raceId) external view returns (address) {
        require(races[_raceId].finished, "Race not finished");
        return races[_raceId].winner;
    }
}
