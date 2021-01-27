// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./IERC20.sol";

contract ERC20Token is IERC20 {
    mapping(address => uint256) public _balances;

    // approval
    mapping(address => mapping(address => uint256)) _allowed;

    // name, symbol, decimals
    string public name = "MyToken";
    string public symbol = "MYTK";
    uint256 public decimals = 0;

    // uint256 - initial supply
    uint256 public _totalSupply;

    // address - creator's address
    address public _creator;

    constructor() public {
        _creator = msg.sender;
        _totalSupply = 50000;
        _balances[_creator] = _totalSupply;
    }

    function totalSupply() external view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address _owner) external view returns (uint256 balance) {
        return _balances[_owner];
    }

    function transfer(address _to, uint256 _value)
        public
        returns (bool success)
    {
        require(_value > 0 && _balances[msg.sender] >= _value);
        _balances[_to] += _value;
        _balances[msg.sender] -= _value;

        emit Transfer(msg.sender, _to, _value);

        return true;
    }

    function approve(address _spender, uint256 _value)
        external
        returns (bool success)
    {
        require(_value > 0 && _balances[msg.sender] >= _value);

        _allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public returns (bool success) {
        require(
            _value > 0 &&
                _balances[_from] >= _value &&
                _allowed[_from][_to] >= _value &&
                msg.sender == _to
        );
        _balances[_to] += _value;
        _balances[_from] -= _value;

        _allowed[_from][_to] -= _value;
        emit Transfer(_from, _to, _value);

        return true;
    }

    function allowance(address _owner, address _spender)
        external
        view
        returns (uint256 remaining)
    {
        return _allowed[_owner][_spender];
    }
}
