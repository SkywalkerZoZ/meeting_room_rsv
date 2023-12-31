import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import FluentUI
import meeting_room_rsv
FluContentPage {
    id: root_page
    title: "会议室情况"
    property int current_idx: -1
    Component.onCompleted: {
        loadData(db_mng.getRooms())
    }

    Component {
        id: operation
        Item {
            RowLayout {
                anchors.centerIn: parent
                FluButton {
                    id: btn_detail
                    text: "详情"
                    onClicked: {
                        current_idx = row;
                        var obj = tbl_view.dataSource[current_idx]
                        FluApp.navigate("/room_detail", {roomData: obj});
                    }
                }
            }
        }
    }
    Component {
        id: edit_box
        Item {
        }
    }
    FluTextBox {
        id: room_srch
        anchors {
            left: parent.left
            top: parent.top
            margins: 20
        }
        placeholderText: "输入房号或名称搜索"
    }
    FluFilledButton {
        id: srch_btn
        anchors {
            left: room_srch.right
            top: parent.top
            margins: 20
        }
        text: "搜索"
        onClicked: {
            var searchText = room_srch.text;
            var searchResult = db_mng.searchRooms(searchText);
            loadData(searchResult);
        }
    }

    FluTableView {
        id: tbl_view
        dataSource: []
        anchors {
            left: parent.left
            right: parent.right
            top: srch_btn.bottom
            bottom: parent.bottom
        }

        anchors.topMargin: 20
        columnSource: [{
                title: "房号",
                dataIndex: "RoomID",
                width: 80,
                minimumWidth: 120,
                maximumWidth: 120,
                //禁用编辑
                editDelegate: edit_box
            }, {
                title: "名称",
                dataIndex: "RoomName",
                width: 200,
                minimumWidth: 200,
                maximumWidth: 300,
                editDelegate: edit_box
            }, {
                title: "人数容量",
                dataIndex: 'Capacity',
                width: 80,
                minimumWidth: 120,
                maximumWidth: 120,
                editDelegate: edit_box
            }, {
                title: "面积",
                dataIndex: 'RoomArea',
                width: 80,
                minimumWidth: 120,
                maximumWidth: 120,
                editDelegate: edit_box
            }, {
                title: '操作',
                dataIndex: 'operation',
                width: 160,
                minimumWidth: 160,
                maximumWidth: 160,
                delegate: operation,
                editDelegate: edit_box
            }]
        Component.onCompleted: {
        }
    }
    function loadData(data) {
        for (var i = 0; i < data.length; ++i) {
            data[i].operation = tbl_view.customItem(operation);
        }
        tbl_view.dataSource = data;
    }
}
