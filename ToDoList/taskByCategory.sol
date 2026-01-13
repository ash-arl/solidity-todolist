// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "./taskFactory.sol";

contract TaskByCategory is TaskFactory{

    function ListByCategory(string memory category)public view returns(Task[] memory){

        Task[] memory tasks = new Task[](taskList.length);
        uint j = 0;

        for(uint i = 0;i < taskList.length;i++){
            if(keccak256(abi.encodePacked(category)) == keccak256(abi.encodePacked(taskList[i].taskCategory)))
                tasks[j++] = taskList[i];
        }
        return tasks;
    }
}