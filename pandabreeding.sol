pragma solidity ^0.5.1;

import "./pandamining.sol";

/// @title A contract responsible for breeding Pandas
/// @author ZTube
contract PandaBreeding is PandaMining {

	/// @notice Breed a new Panda with two parents
	/// @param _name The name of the new Panda
	/// @param _parent1Id The id of the first parent
	/// @param _parent2Id The id of the second parent
	function breedPandas(string calldata _name, uint _parent1Id, uint _parent2Id) external ownsPanda(_parent1Id) ownsPanda(_parent2Id) {
		Panda memory parent1 = pandas[_parent1Id];
		Panda memory parent2 = pandas[_parent2Id];

		require(parent1.gen == parent2.gen);

		uint32 dna = _generateDNA(_name, parent1.dna, parent2.dna);
		uint32 gen = uint32(parent1.gen + 1);

		_createPanda(_name, dna, 1, gen, _parent1Id, _parent2Id);
	}
}
