// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "@openzeppelin/contracts/utils/Strings.sol";

contract TaskFactory {

    struct Task{
        string taskDescription;
        string taskCategory;
        uint8 taskPriority;
        uint32 taskDeadline; // To store time in seconds
        bool taskStatus;
    }

    Task[] internal taskList;
    uint taskCount = 0;

    modifier checkRange(uint taskId){
        require(taskId < taskCount, "Invalid Task");
        _;
    }

    function newTask(string memory taskDescription, string memory taskCategory, uint8 taskPriority, uint32 taskDeadline) public {
        string memory taskDesc = string(abi.encodePacked(Strings.toString(taskCount),"-",taskDescription));
        taskList.push(Task(taskDesc, taskCategory, taskPriority, taskDeadline, false));
        taskCount++;
    }

    function listTask() public view returns (string[] memory) {
        string[] memory tasks = new string[](taskList.length);

        for (uint i = 0; i < taskList.length; i++) {
            tasks[i] = taskList[i].taskDescription;
        }

        return tasks;
    }

    function callTask(uint taskId) public view checkRange(taskId) returns(Task memory){
        return taskList[taskId];
    }


    }