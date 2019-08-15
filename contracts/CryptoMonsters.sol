pragma solidity ^0.5.0;
// Enable the ABI v2 Coder
pragma experimental ABIEncoderV2;

import 'openzeppelin-solidity/contracts/token/ERC721/ERC721Full.sol';
import 'openzeppelin-solidity/contracts/token/ERC721/ERC721Mintable.sol';

contract CryptoMonsters is ERC721Full, ERC721Mintable {
    
    event MonsterCreated(uint256 _MonsterID);

    struct Monster {
        string name;
        uint256 level;
        uint256 attackPower;
        uint256 defensePower;
        address monsterOwner;
        uint256 id;
    }

    Monster[] public monsters; 
    address public owner;
    mapping(bytes32 => bool) public usedNames;

    //Counter
    mapping (address => uint256) public win;
    mapping (address => uint256) public draw;
    mapping (address => uint256) public lost;

    //Cool down counter
    mapping (address => uint256) public coolTime;

    constructor(string memory _name , string memory _symbol) public ERC721Full(_name, _symbol) {
        //Only the owner can create crypto monster
        owner = msg.sender;
    }

    function getMonstersLength() public view returns (uint256) {
        return monsters.length;
    }
    /**
   * @dev Guarantees msg.sender is owner of the given token
   * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
   */
    modifier onlyOwnerOf(uint256 _tokenId) {
        require(ownerOf(_tokenId) == msg.sender);
        _;
    }

    function createMonster(string memory _name, uint256 _level, uint256 _attackPower,uint256 _defensePower, address _to) public {
        require(owner == msg.sender);

        //Monster stats requirements
        require(_level >= 1);
        require(_attackPower >= 1);
        require(_defensePower >= 1);

        uint256 id =  monsters.length;

        monsters.push(Monster({name: _name, level: _level,  attackPower: _attackPower,  defensePower: _defensePower, monsterOwner: _to , id: id}));
        //Mark off monster name
        usedNames[keccak256(abi.encodePacked(_name))] = true;
        _mint(_to, id);
        emit MonsterCreated(id);
    }

    function battle(uint256 _monsterId, uint256 _targetId) onlyOwnerOf(_monsterId) public {
        Monster storage monster1 = monsters[_monsterId];
        Monster storage monster2 = monsters[_targetId];
        
        //Win Case
        if(monster1.attackPower > monster2.defensePower) {
            monster1.level += 1;
            monster1.attackPower += 10;
            monster1.defensePower += 10;
            win[ownerOf(_monsterId)]++;
            lost[ownerOf(_targetId)]++;
        }
        //Draw Case
        else if(monster1.attackPower == monster2.defensePower) {
        
            monster2.defensePower += 10;
            draw[ownerOf(_monsterId)]++;
            draw[ownerOf(_targetId)]++;

        }
        //Lost Case
        else {
            monster2.level += 1;
            monster2.attackPower += 10;
            lost[ownerOf(_monsterId)]++;
            win[ownerOf(_targetId)]++;
        }
    }

    function fusion(uint256 _monsterId1, uint256 _monsterId2, string memory _fusionMonsterName ) public {
        //Anymore that owns the monstercan fuse the monster
        require(uint160(msg.sender) == uint160(monsters[_monsterId1].monsterOwner) & uint160(monsters[_monsterId2].monsterOwner));
        //Require both monsters to have a combine level of 5 or above
        require(monsters[_monsterId1].level + monsters[_monsterId2].level >= 5);
        //Checking to see if the monster name already exist or not
        require(!usedNames[keccak256(abi.encodePacked(_fusionMonsterName))]);

        //Calculating fusion Monster stats
        uint256 _fusionMonsterAttackPower;
        if ( monsters[_monsterId1].attackPower <= monsters[_monsterId2].attackPower ) {
            _fusionMonsterAttackPower = monsters[_monsterId1].attackPower + 10;
        }
        else {
            _fusionMonsterAttackPower = monsters[_monsterId2].attackPower + 10;
        }

        uint256 _fusionMonsterDefensePower;
        if ( monsters[_monsterId1].defensePower <= monsters[_monsterId2].defensePower ) {
            _fusionMonsterDefensePower = monsters[_monsterId1].defensePower + 10;
        }
        else {
            _fusionMonsterDefensePower = monsters[_monsterId2].defensePower + 10;
        }

        uint256 _fusionMonsterLevel;
        if ( monsters[_monsterId1].level <= monsters[_monsterId2].level ) {
            _fusionMonsterLevel = monsters[_monsterId1].level + 1;
        }
        else {
            _fusionMonsterLevel = monsters[_monsterId2].level + 1;
        }

        createMonster(_fusionMonsterName, _fusionMonsterLevel, _fusionMonsterAttackPower, _fusionMonsterDefensePower, msg.sender);
        
        //30 mins before the user can fuse again
        coolTime[msg.sender] = block.timestamp + 1800;
        require(block.timestamp >= coolTime[msg.sender]);
    }

    function monstersCount() external view returns (uint256 length) {
        return monsters.length;
    }

    function getStats(uint256 _id) external view
        returns (
            string memory name,
            uint256 level,
            uint256 attackPower,
            uint256 defensePower,
            address monsterOwner
        )
        {
        Monster storage stats = monsters[_id];

        // if this variable is 0 then it's not gestating
        name = string(stats.name);
        level = uint256(stats.level);
        attackPower = uint256(stats.attackPower);
        defensePower = uint256(stats.defensePower);
        monsterOwner = address(stats.monsterOwner);
    }

    function getStatsExperimental(uint256 _id) external view returns (Monster memory) {
        return monsters[_id];
    }
}
