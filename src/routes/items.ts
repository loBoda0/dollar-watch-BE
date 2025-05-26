const data = [{
  "id": 1,
  "firstName": "Drake",
  "lastName": "Giraths",
}, {
  "id": 2,
  "firstName": "Craggy",
  "lastName": "McGowan",
}, {
  "id": 3,
  "firstName": "Hannis",
  "lastName": "Avrahm",
}, {
  "id": 4,
  "firstName": "Lonna",
  "lastName": "Duchenne",
}, {
  "id": 5,
  "firstName": "Gerik",
  "lastName": "Jacketts",
}, {
  "id": 6,
  "firstName": "Bettine",
  "lastName": "Smiz",
}, {
  "id": 7,
  "firstName": "Sada",
  "lastName": "Treher",
}, {
  "id": 8,
  "firstName": "Clarance",
  "lastName": "Parriss",
}, {
  "id": 9,
  "firstName": "Maude",
  "lastName": "Dorin",
}, {
  "id": 10,
  "firstName": "Melina",
  "lastName": "Dennington",
}]

export const getData = () => data

export const postData = (params: { firstName: string; lastName: string}) => {
    data.push({
        id: data.length,
        firstName: params.firstName,
        lastName: params.lastName
    })
}