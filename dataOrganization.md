# Firestore Data Organization
## Users
### Collections
* [Feeders](##feeders)
* [Notifications](##notifications)
### Document Fields
```ts
{
  active: boolean,
  appIdentifier: string,
  email: string,
  firstName: string,
  id: string,
  lastName: string,
  lastOnlineTimestamp: timestamp,
  phoneNumber: string,
  profilePictureURL: string
} 
```
## Feeders
### Collections
* [Pets](##pets)
### Document Fields
```ts
{
  id: string,
  modelNumber: string,
  name: string
}
```
## Notifications
### Document Fields
```ts
{
  id: string,
  message: string,
  time: timestamp
}
```
## Pets
### Collections
* [Schedule](##schedule)
### Document Fields
```ts
{
  RFID: string,
  age: number,
  id: string,
  name: string,
  type: string,
  weight: number
}
```
## Schedule
### Document Fields
```ts
{
  id: string,
  portion: number[5],
  time: timestamp[5]
}
```
