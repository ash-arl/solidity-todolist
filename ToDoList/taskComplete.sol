// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "./taskFactory.sol";

contract CompleteStatus is TaskFactory{
    
    function taskStatusChange(uint taskId) public checkRange(taskId) returns(Task memory){

        taskList[taskId].taskStatus = !taskList[taskId].taskStatus;

        return taskList[taskId];

    }

}