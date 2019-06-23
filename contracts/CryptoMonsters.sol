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
    

}
