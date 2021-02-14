# Firestore Data Organization
## Data Diagram
[Interactive Data Diagram](https://app.diagrams.net/#G18DQ6qrUtG-X4go2jzja08kt_WIECgaJY)

![image](https://drive.google.com/uc?export=view&id=1HSPNRK2ZCn1c5Rar7XuPkJL8p5WqAyBd)
## Users
### Collections
* [Feeders](#feeders)
* [Notifications](#notifications)
### Document Fields
```ts
{
  active: boolean, //User's active status
  appIdentifier: string, //User's application device type
  email: string, //User's email address
  firstName: string, //User's first name
  id: string, //Auto-generated document ID
  lastName: string, //User's last name
  lastOnlineTimestamp: timestamp, //Timestamp of the user's last online status
  phoneNumber: string, //User's phone number
  profilePictureURL: string //URL to user's profile picture
} 
```
## Feeders
### Collections
* [Pets](#pets)
### Document Fields
```ts
{
  id: string, //Auto-generated document ID
  modelNumber: string, //Feeder device model number
  name: string //Feeder's user-friendly display name
}
```
## Notifications
### Document Fields
```ts
{
  id: string, //Auto-generated document ID
  message: string, //Notification content
  time: timestamp //Time of notification creation
}
```
## Pets
### Collections
* [Schedule](#schedule)
### Document Fields
```ts
{
  RFID: string, //RFID of pet's collar fob
  dob: timestamp, //Date of birth of pet
  id: string, //Auto-generated document ID
  name: string, //Name of pet
  type: string, //Pet type (cat, dog, etc?)
  lbs: number //weight of pet
}
```
## Schedule
### Document Fields
```ts
{
  id: string, //Auto-generated document ID
  portion: number[5], //Array of portions (Units TBD)
  time: timestamp[5] //Array of timestamps when food will be dispensed
}
```
