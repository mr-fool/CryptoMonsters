var CryptoMonsters = artifacts.require("CryptoMonsters");

let instance;

beforeEach( async () => {
    instance = await CryptoMonsters.deployed();
  
  });

contract("CryptoMonsters", async accounts  => {
    
    describe('createMonster', () => {
        it("Only sender can create monsters", async () => {
            
            let owner = await instance.owner();
            assert.equal(owner, accounts[0], "owner is the msg.sender");
        });

        it("Check if the attackPower is set correctly", async() => {
            let createMonster;
            try{
                createMonster = await instance.createMonster("testMonster",0,1,1,accounts[1]);
            }
            catch(error){
                assert.ok(error.message.indexOf('revert')>=0, 'attackPower check works');
            }
        });
    });


});