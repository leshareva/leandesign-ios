/**
 * Copyright 2015 Google Inc. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
'use strict';

// Initializes FriendlyChat.
function FriendlyChat() {
  this.checkSetup();

  // Shortcuts to DOM Elements.
  this.messageList = document.getElementById('messages');
  this.messageForm = document.getElementById('message-form');
  this.messageInput = document.getElementById('message');
  this.submitButton = document.getElementById('submit');
  this.submitImageButton = document.getElementById('submitImage');
  this.imageForm = document.getElementById('image-form');
  this.mediaCapture = document.getElementById('mediaCapture');
  this.userPic = document.getElementById('user-pic');
  this.userName = document.getElementById('user-name');
  this.signInButton = document.getElementById('sign-in');
  this.signOutButton = document.getElementById('sign-out');
  this.signInSnackbar = document.getElementById('must-signin-snackbar');
  this.taskList = document.getElementById('tasks');
  this.taskStockList = document.getElementById('tasksStock');
  this.taskCont = document.querySelector('#tasks');
  this.messageListClear = document.querySelector('#messages');
 
 
  //awarness
  this.taskIdLabel = document.getElementsByClassName('aboutTask__id');
  this.awarnessField = document.getElementById('awarnessField');
  this.priceField = document.getElementById('priceField');
  this.btnSend = document.getElementById('btnSend');
 
  this.chatContainer = document.getElementById('messages-card-container');
  
  //sctoks controllers
  this.stockButton = document.getElementById('stock');
  this.allTasks = document.getElementById('all-tasks');
  this.stockContainer = document.getElementById('stock-container');
  
  // Saves message on form submit.
  this.messageForm.addEventListener('submit', this.saveMessage.bind(this));
  this.signOutButton.addEventListener('click', this.signOut.bind(this));
  this.signInButton.addEventListener('click', this.signIn.bind(this));

  // Toggle for the button.
  var buttonTogglingHandler = this.toggleButton.bind(this);
  this.messageInput.addEventListener('keyup', buttonTogglingHandler);
  this.messageInput.addEventListener('change', buttonTogglingHandler);
  this.stockButton.addEventListener('click', function() {
    this.openStock();
  }.bind(this));



  

  // Events for image upload.
  this.submitImageButton.addEventListener('click', function() {
    this.mediaCapture.click();
  }.bind(this));
  this.mediaCapture.addEventListener('change', this.saveImageMessage.bind(this));

  this.initFirebase();
  
  this.taskCont.addEventListener("click", function(event) {
	 		event.stopPropagation();
			var taskId = event.target.id;
			this.messageListClear.innerHTML = '';
			this.closeStock();
			this.sendAwarness(taskId);
			this.loadMessages(taskId); 
	}.bind(this));
	
	
}



// Sets up shortcuts to Firebase features and initiate firebase auth.
// Sets up shortcuts to Firebase features and initiate firebase auth.
FriendlyChat.prototype.initFirebase = function() {
  // Shortcuts to Firebase SDK features.
  this.auth = firebase.auth();
  this.database = firebase.database();
  this.storage = firebase.storage();
  // Initiates Firebase auth and listen to auth state changes.
  this.auth.onAuthStateChanged(this.onAuthStateChanged.bind(this));
};


 
 
 
//слушаем клик на кнопку отправить 
this.btnSend.addEventListener('click', e => {

var div = document.querySelector('.aboutTask__id').getAttribute("id");

var awareness = awarnessField.value;
var price = priceField.value;

var postData = {
	    awarness: awareness,
	    price: price,
	    // toId: designerId
	  };    	
   	
return firebase.database().ref('tasks').child(div).update(postData);
  
 });
 
 
FriendlyChat.prototype.sendAwarness  = function(id) {
	var div = document.querySelector('.aboutTask__id');
	div.setAttribute("id", id);
	console.log(id);
}; 
 
 
//open stock-window
FriendlyChat.prototype.openStock = function() {
	
	if(this.chatContainer.style.display == 'block') {
          this.chatContainer.style.display = 'none';
          this.stockContainer.style.display = 'block';
       } else {
          this.chatContainer.style.display = 'block';
          this.stockContainer.style.display = 'none';      
	};
// 	this.chatContainer = document.getElementById('messages-card-container');
} 

//open stock-window
FriendlyChat.prototype.closeStock = function() {
	if(this.chatContainer.style.display == 'none') {
          this.chatContainer.style.display = 'block';
          this.stockContainer.style.display = 'none';
       }
} 


FriendlyChat.prototype.loadAllTasks = function() {
	// Reference to the /messages/ database path.
	var setTask = function(data) {
    var val = data.val();
    this.displayAllTasks(data.key, val.taskId, val.text, val.status, val.imageUrl, val.toId);
  }.bind(this);
	this.tasksRef.on('child_added', setTask);
}


FriendlyChat.prototype.displayAllTasks = function(key, toId, text, status, imageUrl)  {
		var container = document.createElement("div");
		container.innerHTML = FriendlyChat.STOCK_TASK_TEMPLATE;
		var div = container.firstChild;
		div.querySelector('.get-task').setAttribute("id", key);
	  	this.allTasks.appendChild(div);	 
	  	div.querySelector('.taskText').textContent = text;
	  	div.querySelector('.taskStatus').textContent = status;
	  	
	  		  	 
 };	




//Меняем стутс задачи и назначаем ее не дизайнера
function changeTaskStatus() {
	var taskId = event.target.id;
	var postData = {
	    status: "На оценке",
	    price: "2000",
	  };
	
	//скрываем сток задач и открываем чат
	var stockContainer = document.getElementById('stock-container');
	var	chatContainer = document.getElementById('messages-card-container');
	
	if(chatContainer.style.display == 'none') {
         chatContainer.style.display = 'block';
         stockContainer.style.display = 'none';
       }
       
	return firebase.database().ref().child('tasks').child(taskId).update(postData); 
};

// Loads chat messages history and listens for upcoming ones.
FriendlyChat.prototype.loadTasks = function() {
  // Reference to the /messages/ database path.
  this.tasksRef = this.database.ref('tasks');
  // Make sure we remove all previous listeners.
  this.tasksRef.off();
  var designerId = this.auth.currentUser.uid;
  // Loads the last 12 messages and listen for new ones.
  var setTask = function(data) {
    var val = data.val();
    this.displayTasks(data.key, val.taskId, val.text, val.status, val.imageUrl, val.toId);
   
  }.bind(this);
  this.tasksRef.orderByChild("toId").equalTo(designerId).on('child_added', setTask);
//  this.tasksRef.orderByChild("toId").equalTo(designerId).limitToLast(3).on('child_changed', setTask);
//   this.tasksRef.limitToLast(12).on('child_changed', setTask); 
};


// Template for stock-messages.
FriendlyChat.STOCK_TASK_TEMPLATE =
   '<div class="taskContainer">' +
      '<div class="taskText"></div>' +
      '<div class="taskStatus"></div>' +
      '<div class="get-task" onclick="changeTaskStatus()">Взять задачу</div>'+	    
    '</div>';






 

// Loads chat messages history and listens for upcoming ones.
FriendlyChat.prototype.loadMessages = function(taskId) {
	
  // Reference to the /messages/ database path.
  this.messagesRef = this.database.ref('tasks').child(taskId).child('messages');
  // Make sure we remove all previous listeners.
  this.messagesRef.off();

  // Loads the last 12 messages and listen for new ones.
  var setMessage = function(data) {
    var val = data.val();
    this.displayMessage(data.key, val.name, val.text, val.photoUrl, val.imageUrl);
  }.bind(this);
  this.messagesRef.limitToLast(12).on('child_added', setMessage);
 //  this.messagesRef.limitToLast(12).on('child_changed', setMessage); 
 	
};



FriendlyChat.prototype.displayTasks = function(key, toId, text, status, imageUrl)  {
		var container = document.createElement("div");
		container.innerHTML = FriendlyChat.TASK_TEMPLATE;
		var div = container.firstChild;
		div.querySelector('.hyperspan').setAttribute("id", key);
	  	this.taskList.appendChild(div);	 
	  	div.querySelector('.taskText').textContent = text;
	  	div.querySelector('.taskStatus').textContent = status;
	  		  	 
 };	

// Template for tasks.
FriendlyChat.TASK_TEMPLATE =
    '<div class="taskContainer">' +
      '<div class="taskText"></div>' +
      '<div class="taskStatus"></div>' +
       '<span class="hyperspan"></span>' +
    '</div>';


// Saves a new message on the Firebase DB.
FriendlyChat.prototype.saveMessage = function(e) {
  e.preventDefault();
  // Check that the user entered a message and is signed in.
  if (this.messageInput.value && this.checkSignedInWithMessage()) {
    var currentUser = this.auth.currentUser;
    // Add a new message entry to the Firebase Database.
    this.messagesRef.push({
      name: currentUser.displayName,
      text: this.messageInput.value,
      photoUrl: currentUser.photoURL || '/images/profile_placeholder.png'
    }).then(function() {
      // Clear message text field and SEND button state.
      FriendlyChat.resetMaterialTextfield(this.messageInput);
      this.toggleButton();
    }.bind(this)).catch(function(error) {
      console.error('Error writing new message to Firebase Database', error);
    });
  }
};

// Sets the URL of the given img element with the URL of the image stored in Firebase Storage.
FriendlyChat.prototype.setImageUrl = function(imageUri, imgElement) {
  // If the image is a Firebase Storage URI we fetch the URL.
  if (imageUri.startsWith('gs://')) {
    imgElement.src = FriendlyChat.LOADING_IMAGE_URL; // Display a loading image first.
    this.storage.refFromURL(imageUri).getMetadata().then(function(metadata) {
      imgElement.src = metadata.downloadURLs[0];
    });
  } else {
    imgElement.src = imageUri;
  }
};

// Saves a new message containing an image URI in Firebase.
// This first saves the image in Firebase storage.
FriendlyChat.prototype.saveImageMessage = function(event) {
  var file = event.target.files[0];

  // Clear the selection in the file picker input.
  this.imageForm.reset();

  // Check if the file is an image.
  if (!file.type.match('image.*')) {
    var data = {
      message: 'You can only share images',
      timeout: 2000
    };
    this.signInSnackbar.MaterialSnackbar.showSnackbar(data);
    return;
  }
  // Check if the user is signed-in
  if (this.checkSignedInWithMessage()) {

    // We add a message with a loading icon that will get updated with the shared image.
    var currentUser = this.auth.currentUser;
    this.messagesRef.push({
      name: currentUser.displayName,
      imageUrl: FriendlyChat.LOADING_IMAGE_URL,
      photoUrl: currentUser.photoURL || '/images/profile_placeholder.png'
    }).then(function(data) {

      // Upload the image to Firebase Storage.
      var uploadTask = this.storage.ref(currentUser.uid + '/' + Date.now() + '/' + file.name)
          .put(file, {'contentType': file.type});
      // Listen for upload completion.
      uploadTask.on('state_changed', null, function(error) {
        console.error('There was an error uploading a file to Firebase Storage:', error);
      }, function() {

        // Get the file's Storage URI and update the chat message placeholder.
        var filePath = uploadTask.snapshot.metadata.fullPath;
        data.update({imageUrl: this.storage.ref(filePath).toString()});
      }.bind(this));
    }.bind(this));
  }
};

// Signs-in Friendly Chat.
FriendlyChat.prototype.signIn = function() {
  // Sign in Firebase using popup auth and Google as the identity provider.
  var provider = new firebase.auth.GoogleAuthProvider();
  this.auth.signInWithPopup(provider);
};

// Signs-out of Friendly Chat.
FriendlyChat.prototype.signOut = function() {
  // Sign out of Firebase.
  this.auth.signOut();
};

// Triggers when the auth state change for instance when the user signs-in or signs-out.
FriendlyChat.prototype.onAuthStateChanged = function(user) {
  if (user) { // User is signed in!
    // Get profile pic and user's name from the Firebase user object.
    var profilePicUrl = user.photoURL; // Only change these two lines!
    var userName = user.displayName;   // Only change these two lines!

    // Set the user's profile pic and name.
    this.userPic.style.backgroundImage = 'url(' + profilePicUrl + ')';
    this.userName.textContent = userName;

    // Show user's profile and sign-out button.
    this.userName.removeAttribute('hidden');
    this.userPic.removeAttribute('hidden');
    this.signOutButton.removeAttribute('hidden');

    // Hide sign-in button.
    this.signInButton.setAttribute('hidden', 'true');

    // We load currently existing chant messages.
    this.loadTasks();
    this.loadAllTasks();
    
  } else { // User is signed out!
    // Hide user's profile and sign-out button.
    this.userName.setAttribute('hidden', 'true');
    this.userPic.setAttribute('hidden', 'true');
    this.signOutButton.setAttribute('hidden', 'true');

    // Show sign-in button.
    this.signInButton.removeAttribute('hidden');
  }
};

// Returns true if user is signed-in. Otherwise false and displays a message.
FriendlyChat.prototype.checkSignedInWithMessage = function() {
  // Return true if the user is signed in Firebase
  if (this.auth.currentUser) {
    return true;
  }

  // Display a message to the user using a Toast.
  var data = {
    message: 'You must sign-in first',
    timeout: 2000
  };
  this.signInSnackbar.MaterialSnackbar.showSnackbar(data);
  return false;
};

// Resets the given MaterialTextField.
FriendlyChat.resetMaterialTextfield = function(element) {
  element.value = '';
  element.parentNode.MaterialTextfield.boundUpdateClassesHandler();
};

// Template for messages.
FriendlyChat.MESSAGE_TEMPLATE =
    '<div class="message-container">' +
      '<div class="spacing"><div class="pic"></div></div>' +
      '<div class="message"></div>' +
      '<div class="name"></div>' +
    '</div>';
    




// A loading image URL.
FriendlyChat.LOADING_IMAGE_URL = 'https://www.google.com/images/spin-32.gif';

// Displays a Message in the UI.
FriendlyChat.prototype.displayMessage = function(key, name, text, picUrl, imageUri) {
  var div = document.getElementById(key);
  // If an element for that message does not exists yet we create it.
  if (!div) {
    var container = document.createElement('div');
    container.innerHTML = FriendlyChat.MESSAGE_TEMPLATE;
    div = container.firstChild;
    div.setAttribute('id', key);
    this.messageList.appendChild(div);
	
  }
  if (picUrl) {
    div.querySelector('.pic').style.backgroundImage = 'url(' + picUrl + ')';
  }
  div.querySelector('.name').textContent = name;
  var messageElement = div.querySelector('.message');
  if (text) { // If the message is text.
    messageElement.textContent = text;
    // Replace all line breaks by <br>.
    messageElement.innerHTML = messageElement.innerHTML.replace(/\n/g, '<br>');
  } else if (imageUri) { // If the message is an image.
    var image = document.createElement('img');
    image.addEventListener('load', function() {
      this.messageList.scrollTop = this.messageList.scrollHeight;
    }.bind(this));
    this.setImageUrl(imageUri, image);
    messageElement.innerHTML = '';
    messageElement.appendChild(image);
  }
  // Show the card fading-in.
  setTimeout(function() {div.classList.add('visible')}, 1);
  this.messageList.scrollTop = this.messageList.scrollHeight;
  this.messageInput.focus();
  
};

// Enables or disables the submit button depending on the values of the input
// fields.
FriendlyChat.prototype.toggleButton = function() {
  if (this.messageInput.value) {
    this.submitButton.removeAttribute('disabled');
  } else {
    this.submitButton.setAttribute('disabled', 'true');
  }
};

// Checks that the Firebase SDK has been correctly setup and configured.
FriendlyChat.prototype.checkSetup = function() {
  if (!window.firebase || !(firebase.app instanceof Function) || !window.config) {
    window.alert('You have not configured and imported the Firebase SDK. ' +
        'Make sure you go through the codelab setup instructions.');
  } else if (config.storageBucket === '') {
    window.alert('Your Firebase Storage bucket has not been enabled. Sorry about that. This is ' +
        'actually a Firebase bug that occurs rarely. ' +
        'Please go and re-generate the Firebase initialisation snippet (step 4 of the codelab) ' +
        'and make sure the storageBucket attribute is not empty. ' +
        'You may also need to visit the Storage tab and paste the name of your bucket which is ' +
        'displayed there.');
  }
};

window.onload = function() {
  window.friendlyChat = new FriendlyChat();
};





