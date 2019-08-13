pragma solidity ^0.5.1;

import "./pandafactory.sol";

contract PandaMining is PandaFactory {

	uint difficulty = 7;

	event PandaMined(string name, uint nonce, uint hash);


	function minePanda(string calldata _name, uint _nonce) external {
		uint hash;
		bool valid;
		(hash, valid) = _proofOfWork(_name, _nonce);

		require(valid);

		emit PandaMined(_name, _nonce, hash);

		uint32 dna = _generateDNA(_name, 0, 0);
		_createPanda(_name, dna, 1, 1, 0, 0);
	}


	function _proofOfWork(string memory _name, uint _nonce) private view returns (uint, bool) {
		bytes memory packed = abi.encodePacked(_name, _nonce, msg.sender, pandaCount[msg.sender]);
		uint hash = uint(keccak256(packed));

		return (hash, (hash % (16 ** difficulty) == 0x00));
	}
}
