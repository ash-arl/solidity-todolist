// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "./taskFactory.sol";

contract TaskByStatus is TaskFactory{

    function ListByStatus(bool status)public view returns(Task[] memory){

        Task[] memory tasks = new Task[](taskList.length);
        uint j = 0;

        for(uint i = 0;i < taskList.length;i++){
            if(status == taskList[i].taskStatus)
                tasks[j++] = taskList[i];
        }
        return tasks;
    }
}