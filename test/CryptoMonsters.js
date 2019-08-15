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

        it("Check the win and lost case", async()=> {
            let battlePhrase;

            let testMonster3 = await instance.createMonster("testMonster3", 1 , 2, 1, accounts[0]);
            let testMonster3Id = testMonster3.logs[1].args._MonsterID.toNumber();
            //console.log(testMonster3Id);

            let testMonster4 = await instance.createMonster("testMonster4", 1 , 1, 1, accounts[1]);            
            let testMonster4Id = testMonster4.logs[1].args._MonsterID.toNumber();
            //console.log(testMonster4Id);
            battlePhrase = await instance.battle(testMonster3Id, testMonster4Id);


            //Check the win
            let win = await instance.win.call(accounts[0]);
            assert.equal(win, 1, "It is a win");

            //Check the lost
            let lost = await instance.lost.call(accounts[1]);
            assert.equal(lost, 1, "It is a lost");
        });
        it("get stats check", async() => {
            let stats = await instance.getStats(3);
            console.log(stats);
        });
        it("get stats check using experimental features", async() => {
            let testMonster5 = await instance.createMonster("testMonster5", 1 , 1, 1, accounts[1]);
            let monstersCount = await instance.monstersCount();
            let stats = await instance.getStatsExperimental(monstersCount -1);
            console.log(stats);
        });
    });


});