// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "./taskFactory.sol";

contract RemoveTask is TaskFactory{

    function removeTask(uint taskId) public checkRange(taskId){
        uint last = taskList.length - 1;
        if(last != taskId){
            taskList[taskId] = taskList[last];
        }
        taskList.pop();

    }
}