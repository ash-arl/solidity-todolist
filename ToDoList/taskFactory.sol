// SPDX-License-Identifier: MIT
pragma solidity ^ 0.8.30;

import "@openzeppelin/contracts/utils/Strings.sol";

contract TodoList {

  //Priority level  for the user's tasks 
  // Enter  0 for Low, 1 for Medium, 2 for High priorities
  enum Priority { Low, Medium, High } address public owner;

  //Struct for tasks
  struct Task {
    uint id;
    string taskDescription;
    string taskCategory;
    Priority taskPriority;
    uint64 taskDeadline;
    bool taskStatus;
  }

  mapping(address => Task[]) private userTasks;
  mapping(address => string[]) private userCategories;
  mapping(address => uint[]) private taksCounter;
  
  constructor() { owner = msg.sender; }

  modifier onlyOwner() {
    require(msg.sender == owner, "Not authorized");
    _;
  }

  modifier checkRange(uint taskId) {
    require(taskId < taskList.length, "Invalid Task");
    _;
  }

  

  Task[] internal taskList;
  string[] internal categories;

  function newTask(string memory taskDescription, string memory taskCategory,
                   Priority taskPriority, uint64 taskDeadline) public onlyOwner(){

    listCategories(taskCategory); 

    string memory taskDesc = string(abi.encodePacked(
        Strings.toString(taskList.length), "-", taskDescription));

    taskList.push(
        Task(taskDesc, taskCategory, taskPriority, taskDeadline, false));
  }

// Keeps a track of the cateogries the user has created for easy accessibility.
  function listCategories(string memory taskCategory) internal onlyOwner(){
    for (uint i = 0; i < categories.length; i++) {
      if (keccak256(bytes(categories[i])) == keccak256(bytes(taskCategory))) {
        return;
      }
    }
    categories.push(taskCategory);
  }

//lists the tasks
  function listTask() public view returns(string[] memory) {
    string[] memory tasks = new string[](taskList.length);

    for (uint i = 0; i < taskList.length; i++) {
      tasks[i] = taskList[i].taskDescription;
    }

    return tasks;
  }

// to remove a task
  function removeTask(uint taskId) public checkRange(taskId) onlyOwner(){
    uint last = taskList.length - 1;
    if (last != taskId) {
      taskList[taskId] = taskList[last];
    }
    taskList.pop();
  }

  // lists the task by their category
  function ListByCategory(string memory category) public view returns(Task[] memory) {
    uint count = 0;

    for (uint i = 0; i < taskList.length; i++) {
      if (keccak256(bytes(category)) ==
          keccak256(bytes(taskList[i].taskCategory))) {
        count++;
      }
    }

    Task[] memory tasks = new Task[](count);
    uint j = 0;

    for (uint i = 0; i < taskList.length; i++) {
      if (keccak256(bytes(category)) ==
          keccak256(bytes(taskList[i].taskCategory))) {
        tasks[j++] = taskList[i];
      }
    }

    return tasks;
  }

  // lists the task by their status
  function ListByStatus(bool status) public view returns(Task[] memory) {
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

  function listByPriority() public view returns (Task[] memory) {
    Task[] memory tasks = new Task[](taskList.length);

    // Copy storage to  memory in oredr to save gas
    for (uint i = 0; i < taskList.length; i++) {
        tasks[i] = taskList[i];
    }

    if (tasks.length == 0) return tasks;

    uint low = 0;
    uint mid = 0;
    uint high = tasks.length - 1;

    // O(n) algorithm for fast sort
    while (mid <= high) {
        if (tasks[mid].taskPriority == Priority.High) {
            (tasks[mid], tasks[low]) = (tasks[low], tasks[mid]);
            mid++;
            low++;
        }
        else if (tasks[mid].taskPriority == Priority.Medium) {
            mid++;
        }
        else {
            (tasks[mid], tasks[high]) = (tasks[high], tasks[mid]);
            high--;
        }
    }

    return tasks;
}


  function taskStatusChange(uint taskId) public checkRange(taskId) onlyOwner() returns(Task memory) {
    taskList[taskId].taskStatus = !taskList[taskId].taskStatus;

    return taskList[taskId];
  }

  function callTask(uint taskId) public view checkRange(taskId) returns(Task memory) {
    return taskList[taskId];
  }

  function editTaskDescription(uint taskId, string memory newDescription) public checkRange(taskId) onlyOwner(){
    taskList[taskId].taskDescription = newDescription;
}

function getCategories() public view returns (string[] memory) {
    return categories;
}


}