var CryptoMonsters = artifacts.require("CryptoMonsters");

let instance;

beforeEach( async () => {
  instance = await CryptoMonsters.deployed();

});

contract("CryptoMonsters", async () => {
    describe('createMonster', () => {
        it("Only sender can create monsters", async () => {
            let owner = instance.owner;
            assert.equal(owner, msg.sender, "owner is the msg.sender");
        });
    });


});