var CryptoMonsters = artifacts.require("CryptoMonsters");

let instance;

beforeEach( async () => {
    instance = await CryptoMonsters.deployed();
  
  });

contract("CryptoMonsters", async accounts  => {
    
    describe('createMonster', () => {
        it("Only sender can create monsters", async () => {
            let createMonsters = await instance.createMonster("testMonster",1,1,1,accounts[1]);
            let owner = await instance.owner();
            assert.equal(owner, accounts[0], "owner is the msg.sender");
        });
    });


});