# Script moved the file inside the media folder. 
# For practice and excersice purposes only!

cc <- c("angry8.jpg", "media/angry.jpg")

file.copy(from = "angry8.jpg", to="media/angry.jpg", copy.mode = TRUE)
file.remove("CopyOfangry8.jpg")
