// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "@openzeppelin/contracts/utils/Strings.sol";

contract TaskFactory {

    // Enter 0 for Low, 1 for Medium, 2 for High
    enum Priority {Low, Medium, High}

    struct Task{
        string taskDescription;
        string taskCategory;
        Priority taskPriority;
        uint32 taskDeadline; // To store time in seconds
        bool taskStatus;
    }

    Task[] internal taskList;
    uint taskCount = 0;

    string[] internal categories;

    modifier checkRange(uint taskId){
        require(taskId < taskCount, "Invalid Task");
        _;
    }

    function newTask(string memory taskDescription, string memory taskCategory, Priority taskPriority, uint32 taskDeadline) public {

        string memory taskDesc = string(abi.encodePacked(Strings.toString(taskCount),"-",taskDescription));
        taskList.push(Task(taskDesc, taskCategory, taskPriority, taskDeadline, false));
        taskCount++;

    }

    function newCategory(string memory taskCategory) internal{
        if(categories.length == 0) categories[0] = taskCategory;
        for(uint i = 0;i < categories.length; i++){
            require(keccak256(abi.encodePacked(categories[i])) == keccak256(abi.encodePacked(taskCategory)));
                categories.push(taskCategory);
        }
    }
    

    function listTask() public view returns (string[] memory) {
        string[] memory tasks = new string[](taskList.length);

        for (uint i = 0; i < taskList.length; i++) {
            tasks[i] = taskList[i].taskDescription;
        }

        return tasks;
    }

    function removeTask(uint taskId) public checkRange(taskId){
        uint last = taskList.length - 1;
        if(last != taskId){
            taskList[taskId] = taskList[last];
        }
        taskList.pop();

    }

    function ListByCategory(string memory category)public view returns(Task[] memory){

        Task[] memory tasks = new Task[](taskList.length);
        uint j = 0;

        for(uint i = 0;i < taskList.length;i++){
            if(keccak256(abi.encodePacked(category)) == keccak256(abi.encodePacked(taskList[i].taskCategory)))
                tasks[j++] = taskList[i];
        }
        return tasks;
    }

    function callTask(uint taskId) public view checkRange(taskId) returns(Task memory){
        return taskList[taskId];
    }


    }