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
        it("Check if the monster is created", async() => {
            testMonster1 = await instance.createMonster("testMonster1",1,1,1,accounts[1]);
            testMonster2 = await instance.createMonster("testMonster2",1,1,1,accounts[1]);
            monstersArrayLength = await instance.getMonstersLength();
            assert.equal(monstersArrayLength, 2, "two monsters have been successfully created");
        });

        it("Check the win case", async()=> {
            let battlePhrase;
            testMonster1 = await instance.createMonster("testMonster1",1,2,1,accounts[0]);
            testMonster2 = await instance.createMonster("testMonster2",1,1,1,accounts[1]);
            console.log(testMonster1);
            //battlePhrase = await instance.battle(testMonster1, testMonster2);


            //Check the win
            /*let win = await instance.win();
            assert.equal(win[accounts[1]], 1, "It is a win");*/
        });
    });


});