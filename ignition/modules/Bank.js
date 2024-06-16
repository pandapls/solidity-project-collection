const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("BankModule", (m) => {
  // 部署 Bank 合约
  const Bank = m.contract("Bank", [],);

  // 返回 Bank 合约实例
  return { Bank };
});


// m.contract("Bank", {
//   from: deployer,
//   value: ethers.utils.parseEther("1"),
//   args: ["MyBank"], // 构造函数参数
//   gas: 5000000, // 自定义的 gas 限制
//   gasPrice: ethers.utils.parseUnits("20", "gwei"), // 自定义的 gas 价格
//   nonce: 1, // 自定义的 nonce 值
//   libraries: {
//     SafeMath: "0x1234567890123456789012345678901234567890" // 链接库
//   }
// });