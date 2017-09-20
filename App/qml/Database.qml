import QtQuick 2.0
import QtQuick.Controls 1.4

import QtFirebase 1.0

import "."

Page {
    id: root

    /*
     * Database example
     */
    Column {
        anchors { centerIn: parent }

        Connections {
            target: Database
            onReadyChanged: {
                console.log("Is dbready:" + Database.ready);
            }
        }

        Item {
            id: json
            property var jsonData0: {
                "test": 99
            }

            property var jsonData: {
                "test": {
                    "FirstName": "John",
                    "LastName": "Doe",
                    "Age": 43,
                    "Address": {
                        "Street": "Downing Street 10",
                        "City": "London",
                        "Country": "Great Britain"
                    },
                    "Phone numbers": [
                        "+44 1234567",
                        "+44 2345678"
                    ]
                }
            }
        }

        Column {
            id: buttonsDatabase

            Button {
                DatabaseRequest {
                    id: setRequest
                    property string requestName: "Set"
                    onCompleted: {
                        if(success) {
                            console.log(requestName+" request completed successfully");
                        } else {
                            console.log(requestName+ " request failed with error:"+errorId()+" "+errorMsg());
                        }

                    }
                }
                enabled: !setRequest.running
                text: setRequest.running ? "running..." : "Set"
                onClicked: {
                    setRequest.child("test").setValue(12345);
                }
            }
            Button {
                DatabaseRequest {
                    id: updateRequest
                    property string requestName: "Update"
                    onCompleted: {
                        if(success) {
                            console.log(requestName+" request completed successfully");
                        } else {
                            console.log(requestName+ " request failed with error:"+errorId()+" "+errorMsg());
                        }

                    }
                }
                enabled: !updateRequest.running
                text: updateRequest.running ? "running..." : "Update"
                onClicked: {
                    updateRequest.updateTree(JSON.stringify(json.jsonData));
                }
            }

            Button {

                DatabaseRequest {
                    id: getRequest
                    property var data;
                    onCompleted: {
                        if(success) {
                            console.log("Get request successfully");
                            if(snapshot.hasChildren()) {
                                console.log(snapshot.key()+" "+snapshot.jsonString())
                                data = JSON.parse(snapshot.jsonString());
                                console.log("Age:"+data.Age);
                            } else {
                                console.log(snapshot.key() +" "+snapshot.value());
                            }
                        } else {
                            console.log("Get request failed with error:"+errorId()+" "+errorMsg());
                        }
                    }
                }
                enabled: !getRequest.running
                text: getRequest.running ? "running..." : "Get"
                onClicked: {
                    getRequest.child("test").exec();
                }
            }
            Button {
                DatabaseRequest {
                    id: pushRequest
                    property string requestName: "Push"
                    onCompleted: {
                        if(success) {
                            console.log(requestName+" request completed successfully");
                            console.log("Pushed child got key:"+childKey())
                        } else {
                            console.log(requestName + " request failed with error:"+errorId()+" "+errorMsg());
                        }
                    }
                }
                enabled: !pushRequest.running
                text: pushRequest.running ? "running..." : "Push"
                onClicked: {
                    pushRequest.child("test").pushChild("pushedChild").setValue(887)
                }
            }

            Button {

                DatabaseRequest {
                    id: query
                    property string requestName: "Query"
                    onCompleted: {
                        if(success) {
                            console.log(requestName+" request completed successfully");
                            if(snapshot.hasChildren()) {
                                console.log(snapshot.key()+" "+snapshot.jsonString())
                            } else {
                                console.log(snapshot.key() +" "+snapshot.value());
                            }
                        } else {
                            console.log(requestName + " request failed with error:"+errorId()+" "+errorMsg());
                        }
                    }
                }
                enabled: !query.running
                text: query.running ? "running..." : "Query"
                onClicked: {
                    //query.child("test").orderByValue().startAt(0).endAt(7).exec()
                    //query.child("ratings").orderByValue().exec()
                    //query.child("ratings").orderByValue().exec()
                    //query.child("ratings").orderByValue().startAt(7).exec()
                    query.child("listtest").exec()
                }
            }
        }
    }
}
