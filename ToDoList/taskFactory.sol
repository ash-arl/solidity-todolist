// SPDX-License-Identifier: MIT
pragma solidity ^ 0.8.30;

contract TodoList {

  //Priority level  for the user's tasks 
  // Enter  0 for Low, 1 for Medium, 2 for High priorities
  enum Priority { Low, Medium, High }

  //Struct for tasks
  struct Task {
    uint id;
    string taskDescription;
    string taskCategory;
    string taskDueDate;
    Priority taskPriority;
    bool taskStatus;
  }

  //user based mapping 
  mapping(address => Task[]) private userTasks;
  mapping(address => string[]) private userCategories;
  mapping(address => uint) private taskCounter;

  modifier checkRange(uint taskId) {
    require(taskId < userTasks[msg.sender].length, "Invalid Task");
    _;
  }

  //function that will store all the categories for future use
  function listCategories(address user, string memory taskCategory) internal{
    string[] storage categories = userCategories[user];
    for (uint i = 0; i < categories.length; i++) {
      if (keccak256(bytes(categories[i])) == keccak256(bytes(taskCategory))) {
        return;
      }
    }
    categories.push(taskCategory);
  }

  //function to add new task
  function newTask(string memory taskDescription, string memory taskCategory, string memory taskDueDate,
                   Priority taskPriority) public{

    listCategories(msg.sender, taskCategory); 

    userTasks[msg.sender].push(Task({id : taskCounter[msg.sender], taskDescription : taskDescription, taskCategory :
    taskCategory, taskDueDate : taskDueDate, taskPriority : taskPriority, taskStatus : false}));

    taskCounter[msg.sender]++;
  }

  //this function which will change the status of the task 
  function taskStatusChange(uint taskId) public checkRange(taskId) returns(Task memory) {
    userTasks[msg.sender][taskId].taskStatus = !userTasks[msg.sender][taskId].taskStatus;

    return userTasks[msg.sender][taskId];
  }

  //this function lets user change the description of their task by selecting a task ID
  function editTaskDescription(uint taskId, string memory newDescription) public checkRange(taskId){
    userTasks[msg.sender][taskId].taskDescription = newDescription;
}

  //this function lets a user to remove a task by the task ID
  function removeTask(uint taskId) public checkRange(taskId) {
    uint last = userTasks[msg.sender].length - 1;
    if (last != taskId) {
      userTasks[msg.sender][taskId] = userTasks[msg.sender][last];
      userTasks[msg.sender][taskId].id = taskId;
    }
    userTasks[msg.sender].pop();
  }

  //lists the tasks 
  function listTask() public view returns(Task[] memory) {
    return userTasks[msg.sender];
  }
  
  
  function callTask(uint taskId) public view checkRange(taskId) returns(Task memory) {
    return userTasks[msg.sender][taskId];
  }

  // lists the task by their status
  function ListByStatus(bool status) public view returns(Task[] memory) {
    uint count = 0;

    for (uint i = 0; i < userTasks[msg.sender].length; i++) {
      if (status == userTasks[msg.sender][i].taskStatus) {
        count++;
      }
    }

    Task[] memory filteredTasks = new Task[](count);
    uint j = 0;

    for (uint i = 0; i < userTasks[msg.sender].length; i++) {
      if (status == userTasks[msg.sender][i].taskStatus) {
        filteredTasks[j++] = userTasks[msg.sender][i];
      }
    }

    return filteredTasks;
  }

  // lists the task by their category
  function ListByCategory(string memory category) public view returns(Task[] memory) {
    uint count = 0;

    for (uint i = 0; i < userTasks[msg.sender].length; i++) {
      if (keccak256(bytes(category)) ==
          keccak256(bytes(userTasks[msg.sender][i].taskCategory))) {
        count++;
      }
    }

    Task[] memory tasks = new Task[](count);
    uint j = 0;

    for (uint i = 0; i < userTasks[msg.sender].length; i++) {
      if (keccak256(bytes(category)) ==
          keccak256(bytes(userTasks[msg.sender][i].taskCategory))) {
        tasks[j++] = userTasks[msg.sender][i];
      }
    }

    return tasks;
  }

  

  function listByPriority() public view returns (Task[] memory) {
    Task[] memory tasks = new Task[](userTasks[msg.sender].length);

    // Copy storage to  memory in oredr to save gas
    for (uint i = 0; i < userTasks[msg.sender].length; i++) {
        tasks[i] = userTasks[msg.sender][i];
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


function getCategories() public view returns (string[] memory) {
    return userCategories[msg.sender];
}


}