pragma solidity ^0.5.0;

import 'openzeppelin-solidity/contracts/token/ERC721/ERC721Full.sol';
import 'openzeppelin-solidity/contracts/token/ERC721/ERC721Mintable.sol';

contract CryptoMonsters is ERC721Full, ERC721Mintable {

    struct Monster {
        string name;
        uint256 level;
        uint256 attackPower;
        uint256 defensePower;
    }
    Monster[] public monsters; //    mapping (address => Monsters) monsters;
    address public owner;

    constructor() public {
        //Only the owner can create crypto monster
        owner = msg.sender;
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
        uint256 id =  monsters.length;
        monsters.push(Monster(_name, _level, _attackPower, _defensePower));
        _mint(_to, id);
    }

    function battle(uint256 _monsterId, uint256 _targetId) onlyOwnerOf(_monsterId) public {
        Monster storage monster1 = monsters[_monsterId];
        Monster storage monster2 = monsters[_targetId];
    }
}
