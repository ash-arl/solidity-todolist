// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "@openzeppelin/contracts/utils/Strings.sol";

contract TaskFactory {

    // Enter 0 for Low, 1 for Medium, 2 for High
    enum Priority {Low, Medium, High}
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    modifier checkRange(uint taskId){
        require(taskId < taskList.length, "Invalid Task");
        _;
    }

    struct Task{
        string taskDescription;
        string taskCategory;
        Priority taskPriority;
        uint64 taskDeadline; // To store time in seconds
        bool taskStatus;
    }

    Task[] internal taskList;   
    string[] internal categories;

    function newTask(string memory taskDescription, string memory taskCategory, Priority taskPriority, uint64 taskDeadline) public {

        string memory taskDesc = string(abi.encodePacked(Strings.toString(taskList.length),"-",taskDescription));
        taskList.push(Task(taskDesc, taskCategory, taskPriority, taskDeadline, false));

    }

    //Keeps a track of the cateogries the user has created for easy accessibility.
    function listCategories(string memory taskCategory) internal {
    for (uint i = 0; i < categories.length; i++) {
        if (keccak256(bytes(categories[i])) == keccak256(bytes(taskCategory))) {
            return; // already exists
            }
        }
        categories.push(taskCategory);
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

    //outputs tasks by category
    function ListByCategory(string memory category) public view returns (Task[] memory) {
    uint count = 0;

    for (uint i = 0; i < taskList.length; i++) {
        if (keccak256(bytes(category)) == keccak256(bytes(taskList[i].taskCategory))) {
            count++;
        }
    }

    Task[] memory tasks = new Task[](count);
    uint j = 0;

    for (uint i = 0; i < taskList.length; i++) {
        if (keccak256(bytes(category)) == keccak256(bytes(taskList[i].taskCategory))) {
            tasks[j++] = taskList[i];
        }
    }

    return tasks;
}

    function ListByStatus(bool status) public view returns (Task[] memory) {
    uint count = 0;

    for (uint i = 0; i < taskList.length; i++) {
        if (status == taskList[i].taskStatus) {
            count++;
        }
    }

    Task[] memory tasks = new Task[](count);
    uint j = 0;

    for (uint i = 0; i < taskList.length; i++) {
        if (status == taskList[i].taskStatus) {
            tasks[j++] = taskList[i];
        }
    }

    return tasks;
}

    function taskStatusChange(uint taskId) public checkRange(taskId) returns(Task memory){

        taskList[taskId].taskStatus = !taskList[taskId].taskStatus;

        return taskList[taskId];

    }

    function callTask(uint taskId) public view checkRange(taskId) returns(Task memory){
        return taskList[taskId];
    }


    }