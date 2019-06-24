pragma solidity ^0.5.0;

import 'openzeppelin-solidity/contracts/token/ERC721/ERC721Full.sol';
import 'openzeppelin-solidity/contracts/token/ERC721/ERC721Mintable.sol';

contract CryptoMonsters is ERC721Full, ERC721Mintable {

    struct Monster {
        string name;
        uint level;
        uint attackPower;
        uint defensePower;
    }
    Monster[] public monsters;
    address public owner;

    constructor() public {
        //Only the owner can create crypto monster
        owner = msg.sender;
    }

    function createMonster(string memory _name, address _to) public {
        require(owner == msg.sender);
        uint id =  monsters.lengh;
        monsters.push(Monster(_name, 1, 100, 100));
        _mint();
    }

}
