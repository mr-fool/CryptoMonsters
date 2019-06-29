pragma solidity ^0.5.0;

import 'openzeppelin-solidity/contracts/token/ERC721/ERC721Full.sol';
import 'openzeppelin-solidity/contracts/token/ERC721/ERC721Mintable.sol';

contract CryptoMonsters is ERC721Full, ERC721Mintable {

    struct Monster {
        string name;
        uint256 level;
        uint256 attackPower;
        uint256 defensePower;
        address monsterOwner;
    }

    Monster[] public monsters; 
    address public owner;
    mapping(bytes32 => bool) public usedName;


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

        monsters.push(Monster(_name, _level, _attackPower, _defensePower, _to));
        //Mark off monster name
        usedName[keccak256(abi.encodePacked(name))] = true;
        _mint(_to, id);
    }

    function battle(uint256 _monsterId, uint256 _targetId) onlyOwnerOf(_monsterId) public {
        Monster storage monster1 = monsters[_monsterId];
        Monster storage monster2 = monsters[_targetId];
        
        if(monster1.attackPower >= monster2.attackPower) {
            monster1.level += 1;
            monster1.attackPower += 10;

        }
        else {
            monster2.level += 1;
            monster2.attackPower += 10;
        }
    }
    function fusion(uint256 _monsterId1, uint256 _monsterId2, string memory _fusionMonsterName ) public{
        //Anymore that owns the monstercan fuse the monster
        require(uint160(msg.sender) == uint160(monsters[_monsterId1].monsterOwner) & uint160(monsters[_monsterId2].monsterOwner));
        //Require both monsters to have a combine level of 5 or above
        require(monsters[_monsterId1].level + monsters[_monsterId2].level >= 5);
        //Checking to see if the monster name already exist or not
        require(!usedNames[keccak256(abi.encodePacked(_fusionMonsterName))]);
    }
}
