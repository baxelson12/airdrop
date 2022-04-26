const { ethers } = require("hardhat");
const { expect } = require("chai");

describe("Airdrop contract", () => {
  let Airdrop;
  let owner;

  describe("Functionalities", () => {
    beforeEach(async () => {
      owner = (await ethers.getSigners())[0];
      const AirdropFactory = await ethers.getContractFactory("Airdrop");
      Airdrop = await AirdropFactory.deploy();
    });

    it("Should set / get URIs", async () => {
      await Airdrop.createToken("first");
      await Airdrop.createToken("second");
      await Airdrop.setTokenURI(1, "modified");

      expect(await Airdrop.uri(0)).to.equal("first");
      expect(await Airdrop.uri(1)).to.equal("modified");
    });

    it("Should set contract metadata", async () => {
      const sample = { hello: "World", goodbye: "Moon" };
      await Airdrop.setContractURI(JSON.stringify(sample));

      expect(await Airdrop.contractURI()).to.equal(JSON.stringify(sample));
    });

    it("Should airdrop some tokens", async () => {
      const receivers = [
        "0x5B38Da6a701c568545dCfcB03FcB875f56beddC4",
        "0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2",
        "0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db",
      ];
      const ids = [0, 0, 0];
      const quantities = [1, 1, 1];
      const datas = ["0x0000", "0x0000", "0x0000"];

      await Airdrop.airdrop(receivers, ids, quantities, datas);
      expect(await Airdrop.balanceOf(receivers[1], 0)).to.equal(1);
    });
  });
});
