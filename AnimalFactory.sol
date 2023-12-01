// SPDX-License-Identifier: MIT
pragma solidity >=0.6.12 <0.9.0;

contract AnimalFactory {
    uint256 public dnaDigits = 16; // 宠物DNA位数
    uint256 public dnaLength = 10**dnaDigits;

    struct Animal {
        string name;
        uint256 dna;
    }

    Animal[] public animals;

    event NewAnimal(uint256 animalId, string name, uint256 dna);

    // 孵化宠物函数
    function hatchAnimal(string memory name, uint256 dna) public {
        animals.push(Animal(name, dna));
        uint256 animalId = animals.length - 1;
        emit NewAnimal(animalId, name, dna);
    }

    function _createAnimal(string memory _name, uint256 _dna) internal {
        animals.push(Animal(_name, _dna));
        uint256 animalId = animals.length - 1;
        emit NewAnimal(animalId, _name, _dna);
    }

    function _generateRandomDna(string memory _str) private view returns (uint256) {
        uint256 rand = uint256(keccak256(abi.encodePacked(_str)));
        return rand % dnaLength;
    }

    function createRandomAnimal(string memory _name) public {
        uint256 randDna = _generateRandomDna(_name);
        _createAnimal(_name, randDna);
    }
}
