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
  this.taskCont = document.querySelector('#tasks');
  this.messageListClear = document.querySelector('#messages');
  this.btnTaskComplete = document.getElementById('taskComplete');
  this.awarenessTextField = document.querySelector('.aboutTask__awarenessForm');	
  this.awarenessInWork = document.querySelector('.aboutTask__awarenessInWork');
  this.awarenessTextLabel = document.querySelector('.aboutTask__awarenessText');
  this.companyNameLabel = document.getElementById('companyName');
  this.phoneLabel = document.getElementById('phoneNumber');
  this.sumButton = document.getElementById('sumTasks');
 
  //awarness
  this.taskIdLabel = document.getElementsByClassName('aboutTask__id');
  this.awarnessField = document.getElementById('awarnessField');
  this.priceField = document.getElementById('priceField');
  this.btnSend = document.getElementById('btnSend');
 
  this.chatContainer = document.getElementById('messages-card');
  
  //sctoks controllers
  this.stockButton = document.getElementById('openStock');
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

  //Gets signup controls
  this.txtEmail = document.getElementById('txtEmail');
  this.txtPassword = document.getElementById('txtPassword');
  this.btnLogin = document.getElementById('btnLogin');
  this.btnSignUp = document.getElementById('btnSignUp');
  this.btnLogOut = document.getElementById('btnLogOut');
  

    //Login event
   this.btnLogin.addEventListener('click', this.signIn.bind(this));
   //SignUp event
   this.btnSignUp.addEventListener('click', this.signUp.bind(this));   
   this.initFirebase();
   
   
	// Events for image upload.
	this.submitImageButton.addEventListener('click', function() {
	this.mediaCapture.click();
	}.bind(this));
	this.mediaCapture.addEventListener('change', this.saveImageMessage.bind(this));

	
  
	//обработчик калика на задачу в чате
	this.taskCont.addEventListener("click", function(event) {
	//получаем id карточки задачи  
	var taskId = event.target.id;
	
	//очищаем содержимое чата от предыдущей задачи
	this.messageListClear.innerHTML = '';
	
	this.sendTaskIdToElementId(taskId);
	this.loadMessages(taskId); 
	this.closeStock();
	this.showAwareness(taskId);
	}.bind(this));
	

 
 
	//Отправляем понимание задачи клиенту и меняем стату задачи 
	this.btnSend.addEventListener('click', e => {
		//узнаем айди задачи
		var taskId = document.querySelector('.aboutTask__id').getAttribute("id");
		var userUid = this.auth.currentUser.uid;
		var timing = this.priceField.value;
		var awareness = this.awarnessField.value;
		var container = document.querySelector('.aboutTask__error');
		if (timing.length == "") {
			container.textContent = 'Оцените задачу в часах';
		} else {
				var userRef = firebase.database().ref('users').child(userUid);
				userRef.on('value', a =>  { 
				
				var userRate = a.val().rate;
				var price = timing * userRate * 2000 * 0.5;
				var messageToChat ='Cогласуйте, пожалуйста, задание на работу:\n' + awareness + '\n\nСтоимость работ: '  + price + ' рублей\n\nСрок: ' + timing + ' часа';
				var currentUser = this.auth.currentUser;
				console.log(messageToChat)
				//упаковывем массив для передачи в БД
				var postData = { awarness: awareness, price: price, status: "В работе"};    	  
			  
				//изменяем статус задачи и стоимость
				this.database.ref('tasks').child(taskId).update(postData);
	
	
				
				//Отправляем понимание в чат
				this.database.ref('tasks').child(taskId).child('messages').push({ name: currentUser.displayName, text: messageToChat, photoUrl: currentUser.photoURL || '/images/profile_placeholder.png'});
			
			}).bind(this);
		   
		   //скрываем форму понимания задачи
			document.querySelector('.aboutTask__awarenessForm').style.display = 'none';
		}
			
		
	});
	
	
	this.editAwareness = document.getElementById('editAwareness');	
	this.editAwareness.addEventListener('click', e => {
		console.log("редактировать понимание");
		document.querySelector('.aboutTask__awarenessForm').style.display = 'block';
		document.querySelector('.aboutTask__awarenessInWork').style.display = 'none';
		document.querySelector('.aboutTask__inArchive').style.display = 'none';
	});
	
	//закрываем задачу
	this.btnTaskComplete.addEventListener('click', e => {
	console.log("Задача закрыта");
	//узнаем айди задачи
	var taskId = document.querySelector('.aboutTask__id').getAttribute("id");
	//упаковывем массив для передачи в БД
	var postData = { status: "Сдано" }; 
	//изменяем статус задачи и стоимость
	this.database.ref('tasks').child(taskId).update(postData);
	
	document.querySelector('.aboutTask__inArchive').style.display = 'block';
	document.querySelector('.aboutTask__awarenessForm').style.display = 'none';
	document.querySelector('.aboutTask__awarenessInWork').style.display = 'none';
	
	document.getElementById(taskId).style.display = 'none';
	});
	
};



FriendlyChat.prototype.sendAwareness = function(userUid, taskId, userRate) {
				var taskRef = firebase.database().ref('tasks').child(taskId);
				taskRef.on('value', snap => { 
					var taskRate = snap.val().rate; 

				});						
};

// Sets up shortcuts to Firebase features and initiate firebase auth.
FriendlyChat.prototype.initFirebase = function() {
  // Shortcuts to Firebase SDK features.
  this.auth = firebase.auth();
  this.database = firebase.database();
  this.storage = firebase.storage();
  this.email = this.txtEmail.value;
  
   this.auth.onAuthStateChanged(this.onAuthStateChanged.bind(this));
};



 
FriendlyChat.prototype.sendTaskIdToElementId  = function(id) {
		var div = document.querySelector('.aboutTask__id');
		div.style.display = 'block';
		div.setAttribute("id", id);	
}; 
 
		 
 
//open stock-window
FriendlyChat.prototype.openStock = function() {			
	var div = document.querySelector('.aboutTask__id');

	if(this.stockContainer.style.display == 'none') {
          this.chatContainer.style.display = 'none';
          this.stockContainer.style.display = 'block';  
          div.style.display = 'none';   
       } else {
	       this.stockButton.removeClass('stock-button'); 
	      this.stockButton.addClass('selected-button');
	       
          this.chatContainer.style.display = 'block';
          this.stockContainer.style.display = 'none';          
          div.style.display = 'block';
	};
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
	this.tasksRef.orderByChild("toId").equalTo('designStudio').on('child_added', setTask);
	
}


FriendlyChat.prototype.displayAllTasks = function(key, toId, text, status, imageUrl)  {
		var container = document.createElement("div");
		container.innerHTML = FriendlyChat.STOCK_TASK_TEMPLATE;
		var div = container.firstChild;
		div.querySelector('.get-task').setAttribute("id", key);
	  	this.allTasks.appendChild(div);	 
	  	div.querySelector('.taskText').textContent = text;
	  	
	  	div.querySelector('.get-task').addEventListener('click', a => {
	  	
		var id = this.auth.currentUser.uid
		
		// this.taskId = event.target.id;
		console.log(key);
		var postData = {
		    status: "На оценке",
		    price: "0",
		    toId: id
		  };
		    
		this.database.ref('tasks').child(key).update(postData); 
		div.style.display = 'none';
	
	});	
	if(this.chatContainer.style.display == 'none') {
	         this.chatContainer.style.display = 'block';
	         this.stockContainer.style.display = 'none';
	       }  	 
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
  
};


// Template for stock-messages.
FriendlyChat.STOCK_TASK_TEMPLATE =
   '<div class="taskContainer taskContainer_stock mdl-shadow--2dp">' +
      '<div class="taskText" style="font-size: 14px; line-height: 22px; margin-bottom: 14px;"></div>' +
      '<button class="get-task">Взять задачу</buttom>' +
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
};



FriendlyChat.prototype.displayTasks = function(key, toId, text, status, imageUrl, company, phone)  {
		var container = document.createElement("li");
		if (status === "Сдано") {
			container.style.display = "none";
		} else {
		container.innerHTML = FriendlyChat.TASK_TEMPLATE;
		var li = container.firstChild;
		li.querySelector('.hyperspan').setAttribute("id", key);
	  	this.taskList.appendChild(li);	 
	  	li.querySelector('.taskText').textContent = text;
	  	li.querySelector('.taskStatus').textContent = status;

	  	}	  	 
 };	

// Template for tasks.
FriendlyChat.TASK_TEMPLATE =
    '<li class="taskContainer taskContainer__myTasks">' +
      '<div class="taskText"></div>' +
      '<span class="taskStatus"></span>' +
       '<span class="hyperspan" ></span>' +
    '</li>';


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
 	var email = this.txtEmail.value;
	   var pass = this.txtPassword.value;
	  //Sign in 
	  firebase.auth().signInWithEmailAndPassword(email, pass).catch(function(error) {
	  // Handle Errors here.
	  console.log(error.code);
	  console.log(error.message);
  // ...
	});

};



// Signs-out of Friendly Chat.
FriendlyChat.prototype.signOut = function() {
  // Sign out of Firebase.
  this.auth.signOut();
  location.reload();
};

// Signs-out of Friendly Chat.
FriendlyChat.prototype.signUp = function() {
	var email = this.txtEmail.value;
	var pass = this.txtPassword.value;

	  firebase.auth().createUserWithEmailAndPassword(email, pass).catch(function(error) {
		  // Handle Errors here.
		  var errorCode = error.code;
		  console.log(error.message);
		  // ...
		}); 
	
};


// Triggers when the auth state change for instance when the user signs-in or signs-out.
FriendlyChat.prototype.onAuthStateChanged = function(user) {
  if (user) { // User is signed in!
		
		var phone = "123456";
		var rate = "0.25";

		var upload = {
		id: user.uid,
		email: user.email,
		phone: phone,
		rate: rate
		};
		
		firebase.database().ref('users').child(user.uid).set(upload);

		document.getElementById('signUp-container').classList.add('hidden');
		document.getElementById('chatRoom').classList.remove('hidden');
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
    document.getElementById('signUp-container').classList.remove('hidden');
    console.log('not logged in');
	document.getElementById('chatRoom').classList.add('hidden');
    
    this.userName.setAttribute('hidden', 'true');
    this.userPic.setAttribute('hidden', 'true');

    this.signOutButton.setAttribute('hidden', 'true');

    // Show sign-in button.
//     this.signInButton.removeAttribute('hidden');

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
    

FriendlyChat.prototype.showAwareness = function(taskId) {
		this.taskRef = this.database.ref('tasks').child(taskId);

		// Loads the last 12 messages and listen for new ones.
	  	var setTaskInfo = function(a) {
	    var val = a.val();
	    
	    this.companyNameLabel.textContent = val.company;
		this.phoneLabel.textContent = val.phone;
	   
	  	//проверяем статус задачи
	    if(val.status === "В работе"){
			console.log("Задача в работе");
			this.awarenessTextField.style.display = 'none';	
			this.awarenessInWork.style.display = 'block';
			this.awarenessTextLabel.textContent = val.awarness;	
		} else {
			console.log("Иначе");
			this.awarenessTextField.style.display = 'block';
			this.awarenessInWork.style.display = 'none';
		};

	  }.bind(this);
	  this.taskRef.on('value', setTaskInfo);
	
};

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





