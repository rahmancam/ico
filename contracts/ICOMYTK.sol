// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./ERC20Token.sol";

contract ICOMYTK is ERC20Token {
    // define the admin of ICO
    address public administrator;

    // Recipient account
    address payable public recipient;

    // set price of token, 0.001 ether
    uint256 public tokenPrice = 1000000000000000;

    // harcap 500 ether = 500000000000000000000
    uint256 public icoTarget = 500000000000000000000;

    // define a state variable to track the funded amount
    uint256 public receivedFund;

    // maximum (10 ether) and minimum(0.001) investment allowed
    uint256 public maxInvestment = 10000000000000000000;
    uint256 public minInvestment = 1000000000000000;

    enum Status {inactive, active, stopped, completed}

    Status public icoStatus;

    uint256 public icoStartTime = block.timestamp;

    // 5 days
    uint256 public icoEndTime = block.timestamp + 432000;

    // trading start time
    uint256 public startTrading = icoEndTime + 432000;

    modifier isOwner() {
        require(msg.sender == administrator);
        _;
    }

    constructor(address payable _recepient) public {
        administrator = msg.sender;
        recipient = _recepient;
    }

    function setStopStatus() public isOwner {
        icoStatus = Status.stopped;
    }

    function setActiveStatus() public isOwner {
        icoStatus = Status.active;
    }

    function getIcoStatus() public view returns (Status) {
        if (icoStatus == Status.stopped) {
            return Status.stopped;
        } else if (
            block.timestamp >= icoStartTime && block.timestamp <= icoEndTime
        ) {
            return Status.active;
        } else if (block.timestamp < icoStartTime) {
            return Status.inactive;
        } else {
            return Status.completed;
        }
    }

    function Investing() public payable returns (bool) {
        icoStatus = getIcoStatus();

        // check ico status
        require(icoStatus == Status.active, "ICO is not active");

        // check for hard cap
        require(
            icoTarget >= receivedFund + msg.value,
            "Target Acheived. Investment not accepted"
        );

        // check for minimum and maximum investment
        require(msg.value >= minInvestment && msg.value <= minInvestment);

        uint256 tokens = msg.value / tokenPrice;

        //check for tokens
        require(_balances[_creator] >= tokens);

        _balances[msg.sender] += tokens;
        _balances[_creator] -= tokens;
        recipient.transfer(msg.value);
        receivedFund += msg.value;

        return true;
    }

    function burn() public isOwner returns (bool) {
        icoStatus = getIcoStatus();

        require(icoStatus == Status.completed, "ICO not complete");
        _balances[_creator] = 0;

        return true;
    }

    function transfer(address _to, uint256 _value)
        public
        override
        returns (bool success)
    {
        require(
            block.timestamp > startTrading,
            "Trading is not allowed currently"
        );
        super.transfer(_to, _value);
        return true;
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public override returns (bool success) {
        require(
            block.timestamp > startTrading,
            "Trading is not allowed currently"
        );
        super.transferFrom(_from, _to, _value);
        return true;
    }
}
