pragma solidity ^0.4.15;
import "./Factory.sol";
import "./MultiSigWallet.sol";


/// @title Multisignature wallet factory - Allows creation of multisig wallet.
/// @author Stefan George - <stefan.george@consensys.net>
contract MultiSigWalletFactory is Factory {
	address public _toSend;
	uint256 _price;

	modifier onlyOwner() {
		require(_toSend == msg.sender);
		_;
	}

    constructor(address toSend, uint256 price) public {
		require(msg.sender != 0x0);
		require(toSend != 0x0);
		_toSend = toSend;
		_price = price;
	}

    /*
     * Public functions
     */
    /// @dev Allows verified creation of multisignature wallet.
    /// @param _owners List of initial owners.
    /// @param _required Number of required confirmations.
    /// @return Returns wallet address.
    function create(address[] _owners, uint _required)
        public
        payable
        returns (address wallet)
    {
        require(msg.value >= _price);
        wallet = new MultiSigWallet(_owners, _required);
        register(wallet);
        sendMoney();
    }

    function setPrice(uint256 newprice) public onlyOwner {
		require(newprice > 0);
		_price = newprice;
	}

    function sendMoney() public {
		_toSend.transfer(this.balance);
	}

  /// @dev Returns price.
  /// @return uint256.
  function getPrice()
      public
      constant
      returns (uint256)
  {
      return _price;
  }
}
