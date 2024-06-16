// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
contract WETH {
    string public name = "Wrapped Ether";
    string public symbol = "WETH";
    uint8 public decimals = 18;
    // 批准事件
    event Approval(address indexed src, address indexed delegateAds, uint256 amount);
    // 转账事件
    event Transfer(address indexed src, address indexed toAds, uint256 amount);
    // 存款事件
    event Deposit(address indexed toAds, uint256 amount);
    // 取款事件
    event Withdraw(address indexed src, uint256 amount);

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    // 存款方法
    function deposit() public payable {
        balanceOf[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    // 取款方法
    function withdraw(uint256 amount) public {
        require(balanceOf[msg.sender] >= amount);
        // 减少用户的 WETH 余额
        balanceOf[msg.sender] -= amount;
        // 将等量的 ETH 发送给用户
        payable(msg.sender).transfer(amount);
        emit Withdraw(msg.sender, amount);
    }

    // 查询总供应量函数
    function totalSupply() public view returns (uint256) {
        return address(this).balance;
    }

    // 允许用户授权另一个地址从自己的账户转移 WETH
    function approve(address delegateAds, uint256 amount) public returns (bool) {
        allowance[msg.sender][delegateAds] = amount;
        emit Approval(msg.sender, delegateAds, amount);
        return true;
    }

    // 转账函数
    function transfer(address toAds, uint256 amount) public returns (bool) {
        return transferFrom(msg.sender, toAds, amount);
    }
    // 从授权账户转账函数
    function transferFrom(
        address src,
        address toAds,
        uint256 amount
    ) public returns (bool) {
        require(balanceOf[src] >= amount);
        // 如果转出方不是调用者，需要检查授权额度
        if (src != msg.sender) {
            require(allowance[src][msg.sender] >= amount);
            allowance[src][msg.sender] -= amount;
        }
        // 减少转出方余额，增加接收方余额
        balanceOf[src] -= amount;
        balanceOf[toAds] += amount;
        emit Transfer(src, toAds, amount);
        return true;
    }
    fallback() external payable {
        deposit();
    }
    receive() external payable {
        deposit();
    }
}