pragma solidity ^0.5.1;

/// @notice Manage the ownership of this contract
import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/ownership/Ownable.sol";

/// @title A contract responsible for creating a Panda
/// @author ZTube
contract PandaFactory is Ownable {

	struct Panda {
		string name;
		uint32 dna;
		uint32 age;
		uint32 gen;
		uint256 parent1;
		uint256 parent2;
		uint32 winCount;
		uint32 looseCount;
	}

	Panda[] public pandas;

	mapping(uint => address) pandaOwner;
	mapping(address => uint) pandaCount;

	event PandaCreated(uint256 id, string name, uint32 gen, uint32 dna, address indexed owner, uint256 indexed parent1Id, uint256 indexed parent2Id);

	/// @notice Initializes the contract with some pandas owned by the sender
	constructor() public {
		_createPanda("Genesis", 0xff000000, 1, 1, 0, 0);
		_createPanda("Pandawan", 0xef000000, 1, 1, 0, 0);
		_createPanda("Chocolii", 0xef123456, 1, 1, 0, 0);
		_createPanda("Amanda", 0xefffffff, 1, 1, 0, 0);
	}


	/// @notice Abstract function to create a Panda and keep track of owner and count
	/// @param _name The name of the Panda
	/// @param _dna The Panda's dna (defines its looks)
	/// @param _age The Panda's age (similar to level)
	/// @param _gen The Panda's generation
	/// @param _parent1Id The Panda's first parent
	/// @param _parent2Id The Panda's second parent
	function _createPanda(string memory _name, uint32 _dna, uint32 _age, uint32 _gen, uint _parent1Id, uint _parent2Id) internal {
		Panda memory panda = Panda(_name, _dna, _age, _gen, _parent1Id, _parent2Id, 0, 0);

		uint id = pandas.push(panda) - 1;
		pandaOwner[id] = msg.sender;
		pandaCount[msg.sender]++;

		emit PandaCreated(id, _name, _gen, _dna, msg.sender, _parent1Id, _parent2Id);
	}


	/// @notice Create a Panda (only for owner of the contract)
	/// @param _name The name of the Panda
	/// @param _dna The desired dna
	function createPanda(string calldata _name, uint32 _dna) external onlyOwner() {
		_createPanda(_name, _dna, 1, 1, 0, 0);
	}


	/// @notice Get all the pandas an address owns
	/// @param _owner The address of the owner
	/// @return ownedPandas All the pandas the address owns
	function getPandasOfOwner(address _owner) external view returns (uint[] memory) {
		uint[] memory ownedPandas = new uint[](pandaCount[_owner]);
		uint counter = 0;

		for(uint pandaId=0; pandaId < pandas.length; pandaId++) {
			if(pandaOwner[pandaId] == _owner){
				ownedPandas[counter] = pandaId;
				counter++;
			}
		}

		return ownedPandas;
	}


	/// @notice Generates a new dna based on the Pandas name and its parents
	/// @param _name The name of the Panda
	/// @param _parent1dna dna of the first parent
	/// @param _parent2dna dna of the second parent
	/// @return dna The generated dna
	function _generateDNA(string memory _name, uint _parent1dna, uint _parent2dna) internal pure returns(uint32) {
		uint32 dna = uint32(uint(keccak256(abi.encodePacked(_name, _parent1dna, _parent2dna))));
		return dna;
	}


	modifier ownsPanda(uint _pandaId) {
		require(pandaOwner[_pandaId] == msg.sender);
		_;
	}
}
