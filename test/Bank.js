const { expect } = require("chai");
// import { expect } from "chai"
describe("Bank", function () {
  let Bank, bank, owner, addr1;

  beforeEach(async function () {
    Bank = await ethers.getContractFactory("Bank");
    [owner, addr1, ...addrs] = await ethers.getSigners();
    bank = await Bank.deploy({ value: ethers.utils.parseEther("1") });
    await bank.deployed();
  });

  it("Should deploy with the correct owner", async function () {
    expect(await bank.owner()).to.equal(owner.address);
  });

  it("Should receive funds", async function () {
    await addr1.sendTransaction({ to: bank.address, value: ethers.utils.parseEther("1") });
    expect(await bank.getBalance()).to.equal(ethers.utils.parseEther("2"));
  });

  it("Should allow owner to withdraw", async function () {
    await bank.withdraw();
    expect(await bank.getBalance()).to.equal(0);
  });

  it("Should emit events on deposit and withdraw", async function () {
    await expect(addr1.sendTransaction({ to: bank.address, value: ethers.utils.parseEther("1") }))
      .to.emit(bank, "Deposit")
      .withArgs(addr1.address, ethers.utils.parseEther("1"));

    await expect(bank.withdraw())
      .to.emit(bank, "Withdraw")
      .withArgs(ethers.utils.parseEther("2"));
  });
});
