var CryptoMonsters = artifacts.require("CryptoMonsters");

let instance;

beforeEach( async () => {
  instance = await CryptoMonsters.deployed();

});

contract("CryptoMonsters", async accounts => {
    describe('createMonster', () => {
        it("Only sender can create monsters", async () => {

        });
    });


});