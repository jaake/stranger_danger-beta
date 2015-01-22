$(document).ready(function() {
  getLocation();
  setInterval(function(){getLocation()}, 28000);
  setInterval(function(){auto_push()}, 2000);
  setTimeout(function(){locating()}, 30000);
  //setInterval(function(){colorCode()}, 2000);
  audio.play();
  $('#loader').hide();
  $('#photo').hide();
});

var audio = new Audio('stranger.mp3');

//$('#image_photo').on('change', auto_push());

function locating() {
        $('#locating').hide();
        $('#photo').show();
    }

function auto_push() {
    if ($('#image_photo').val() != "") {
        $("#tag").submit();
        $("#photo").hide();
        $("#loader").show();
	      $('#image_photo').val("");
    } else {
        //console.log('no photo');   
    }
}

function getLocation() {
    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(pushPosition);
    } else {
        alert('You must have location sharing in your browser to use StrangerDanger :D');
    }
}

function pushPosition(position) {
      $('#image_latitude').val(position.coords.latitude);
      $('#image_longitude').val(position.coords.longitude);      
      $.ajax('location.js', {
        format: 'js',
        data: {latitude: position.coords.latitude, longitude: position.coords.longitude}
      })
}

function colorCode() {
	var time = new Date().getTime(); 
        time = time / 1000;
	$('.square p').each(function( i ) { 
		if ((time - $( this ).text()) < 6000) {
		    $( this ).closest('.square').css({"border-color" : "#7FE0FF", "background-color" : "#7FE0FF"});
		}else if ((time - $( this ).text()) < 60000) {
		    $( this ).closest('.square').css({"border-color" : "#B5EDFF", "background-color" : "#B5EDFF"  });
		}else if ((time - $( this ).text()) < 360000) {
		    $( this ).closest('.square').css({"border-color" : "#E3F9FF", "background-color" : "#E3F9FF"  });
		}else if ((time - $( this ).text()) < 1440000) {
		    $( this ).closest('.square').css({"border-color" : "#ECECEC", "background-color" : "#ECECEC"  });
		}else if ((time - $( this ).text()) < 2880000) {
		    $( this ).closest('.square').css({"border-color" : "#FFEBF8", "background-color" : "#FFEBF8"  });
		}else {
		    $( this ).closest('.square').css({"border-color" : "#FFDAF3", "background-color" : "#FFDAF3"  });
		}
	})
}



