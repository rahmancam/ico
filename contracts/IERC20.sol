// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

interface IERC20 {
    //totalSuppy - it returns the initial quantity of rolled out tokens
    function totalSupply() external view returns (uint256);

    //balanceOf - it returns the number of tokens hold by any particular address
    function balanceOf(address _owner) external view returns (uint256 balance);

    //transfer - it is to transfer the token from one account to other account
    function transfer(address _to, uint256 _value)
        external
        returns (bool success);

    //approve - owner approves a spender to use it's own token
    function approve(address _spender, uint256 _value)
        external
        returns (bool success);

    // transferFrom - once approved, it is used to transfer all or partial allowed/approved tokens to spender
    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) external returns (bool success);

    // allowance - it is to know the number of remaining approved tokens
    function allowance(address _owner, address _spender)
        external
        view
        returns (uint256 remaining);

    //transfer event -  it is used to log the transfer function activity like from account, to account and
    // how much token was transferred
    event Transfer(address indexed _From, address indexed _to, uint256 _value);

    // approval event - it is used inside approved function to log the activity of approved function
    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );
}
