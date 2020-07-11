/****************************************************************************
**
** Copyright (C) 2020 A-Team.
** Contact: https://a-team.fr/
**
** This file is part of the SwagSoftware free project.
**
**  SwagSoftware is free software: you can redistribute it and/or modify
**  it under the terms of the GNU General Public License as published by
**  the Free Software Foundation, either version 3 of the License, or
**  (at your option) any later version.
**
**  SwagSoftware is distributed in the hope that it will be useful,
**  but WITHOUT ANY WARRANTY; without even the implied warranty of
**  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
**  GNU General Public License for more details.
**
**  You should have received a copy of the GNU General Public License
**  along with SwagSoftware.  If not, see <https://www.gnu.org/licenses/>.
**
****************************************************************************/
pragma Singleton
import QtQuick 2.14
//import Qt.labs.folderlistmodel 2.2
//import QSyncable 1.0
import Qt.labs.settings 1.0
//import fr.ateam.swag 1.0
import QtQuick.Controls.Material 2.14
import MaterialIcons 1.0

Item {
    id:root

    property int windowWidth : 640
    property int windowHeight : 480
    property int slideWidth : 1920
    property int slideHeight : 1080

    property bool welcomeAnimation : true

    property var settings : Settings{
        property bool openLastPrezAtStartup : false
        property bool loadElement3d: false
        property string defaultSyntaxHighlightingStyle : "default"
        property alias windowWidth : root.windowWidth
        property alias windowHeight : root.windowHeight

        property string swagBackend : "https://swagsoftware.net/"
        property string profileAuthor : ""
        property bool signinAtStartup : true

        property color materialAccent : "#f48fb1"
        property color materialBackground : "#303030"
        property int materialElevation : 6
        property color materialForeground : "#ffffff"
        property color materialPrimary : "#3f51b5"
        property int materialTheme :  Material.Dark

        property string ftpHost : "ftp.swagsoftware.net"
        property string ftpUser : "swagapp@swagsoftware.net"
        property string ftpPassword : "eWbsKg7~Kh^@"
        property int ftpPort : 21

        property real defaultPageRatio : 16/9
    }

    //property var currentDocument : null //the object is either a slide, or prezSettings or slideSettings...
        //onCurrentDocumentChanged: console.log("currentDocument:"+currentDocument)
    //readonly property var currentSlide : pm.isSlideDisplayed ? currentDocument : null
        //onCurrentSlideChanged: console.log("currentSlide:"+currentSlide)

    signal navigationFocusChanged(var item );

    //signal rebuildNavigationFocusList( );
    //signal triggerElementPositionner(var element); //root is to be an Element item

    property bool navigationManagedBySlide : (pm.displayType === 3 /*PM.Slide_FlatView*/)

    property var elementItemToModify : null


    function actionCancel()
    {
        root.elementItemToModify = null;
        pm.displayType = 0/*PM.Slide*/;
        pm.showDocumentCode =false;
        pm.viewWorldMode = false;

    }

    function displayEditElement(item){
        root.elementItemToModify = item
    }

    Shortcut {
        sequence: StandardKey.MoveToPreviousChar
        context: Qt.ApplicationShortcut
        onActivated: pm.previousSlide( false );
    }
    Shortcut {
        sequence: StandardKey.MoveToNextChar
        context: Qt.ApplicationShortcut
        onActivated: pm.nextSlide( false );
    }
    Shortcut {
        sequence: StandardKey.Cancel
        context: Qt.ApplicationShortcut
        onActivated: actionCancel()
    }

    Shortcut {
        sequence: "Ctrl+R"
        context: Qt.ApplicationShortcut
        onActivated: pm.hotReload(true);
    }


    /*------------------------------------------------------------------------------------------
                kinda output (usefull properties with readonly binding)
    ------------------------------------------------------------------------------------------*/
    //readonly property string idAliasRoleName : "fileName"

    //readonly property var lstMaterialIcons : []

    readonly property var lstMaterialIcons : [
        { name:"icon3d_rotation", value:"\ue84d"}
        ,{ name:"ac_unit", value:"\ueb3b"}
        ,{ name:"access_alarm", value:"\ue190"}
        ,{ name:"access_alarms", value:"\ue191"}
        ,{ name:"access_time", value:"\ue192"}
        ,{ name:"accessibility", value:"\ue84e"}
        ,{ name:"accessible", value:"\ue914"}
        ,{ name:"account_balance", value:"\ue84f"}
        ,{ name:"account_balance_wallet", value:"\ue850"}
        ,{ name:"account_box", value:"\ue851"}
        ,{ name:"account_circle", value:"\ue853"}
        ,{ name:"adb", value:"\ue60e"}
        ,{ name:"add", value:"\ue145"}
        ,{ name:"add_a_photo", value:"\ue439"}
        ,{ name:"add_alarm", value:"\ue193"}
        ,{ name:"add_alert", value:"\ue003"}
        ,{ name:"add_box", value:"\ue146"}
        ,{ name:"add_circle", value:"\ue147"}
        ,{ name:"add_circle_outline", value:"\ue148"}
        ,{ name:"add_location", value:"\ue567"}
        ,{ name:"add_shopping_cart", value:"\ue854"}
        ,{ name:"add_to_photos", value:"\ue39d"}
        ,{ name:"add_to_queue", value:"\ue05c"}
        ,{ name:"adjust", value:"\ue39e"}
        ,{ name:"airline_seat_flat", value:"\ue630"}
        ,{ name:"airline_seat_flat_angled", value:"\ue631"}
        ,{ name:"airline_seat_individual_suite", value:"\ue632"}
        ,{ name:"airline_seat_legroom_extra", value:"\ue633"}
        ,{ name:"airline_seat_legroom_normal", value:"\ue634"}
        ,{ name:"airline_seat_legroom_reduced", value:"\ue635"}
        ,{ name:"airline_seat_recline_extra", value:"\ue636"}
        ,{ name:"airline_seat_recline_normal", value:"\ue637"}
        ,{ name:"airplanemode_active", value:"\ue195"}
        ,{ name:"airplanemode_inactive", value:"\ue194"}
        ,{ name:"airplay", value:"\ue055"}
        ,{ name:"airport_shuttle", value:"\ueb3c"}
        ,{ name:"alarm", value:"\ue855"}
        ,{ name:"alarm_add", value:"\ue856"}
        ,{ name:"alarm_off", value:"\ue857"}
        ,{ name:"alarm_on", value:"\ue858"}
        ,{ name:"album", value:"\ue019"}
        ,{ name:"all_inclusive", value:"\ueb3d"}
        ,{ name:"all_out", value:"\ue90b"}
        ,{ name:"android", value:"\ue859"}
        ,{ name:"announcement", value:"\ue85a"}
        ,{ name:"apps", value:"\ue5c3"}
        ,{ name:"archive", value:"\ue149"}
        ,{ name:"arrow_back", value:"\ue5c4"}
        ,{ name:"arrow_downward", value:"\ue5db"}
        ,{ name:"arrow_drop_down", value:"\ue5c5"}
        ,{ name:"arrow_drop_down_circle", value:"\ue5c6"}
        ,{ name:"arrow_drop_up", value:"\ue5c7"}
        ,{ name:"arrow_forward", value:"\ue5c8"}
        ,{ name:"arrow_upward", value:"\ue5d8"}
        ,{ name:"art_track", value:"\ue060"}
        ,{ name:"aspect_ratio", value:"\ue85b"}
        ,{ name:"assessment", value:"\ue85c"}
        ,{ name:"assignment", value:"\ue85d"}
        ,{ name:"assignment_ind", value:"\ue85e"}
        ,{ name:"assignment_late", value:"\ue85f"}
        ,{ name:"assignment_return", value:"\ue860"}
        ,{ name:"assignment_returned", value:"\ue861"}
        ,{ name:"assignment_turned_in", value:"\ue862"}
        ,{ name:"assistant", value:"\ue39f"}
        ,{ name:"assistant_photo", value:"\ue3a0"}
        ,{ name:"attach_file", value:"\ue226"}
        ,{ name:"attach_money", value:"\ue227"}
        ,{ name:"attachment", value:"\ue2bc"}
        ,{ name:"audiotrack", value:"\ue3a1"}
        ,{ name:"autorenew", value:"\ue863"}
        ,{ name:"av_timer", value:"\ue01b"}
        ,{ name:"backspace", value:"\ue14a"}
        ,{ name:"backup", value:"\ue864"}
        ,{ name:"battery_alert", value:"\ue19c"}
        ,{ name:"battery_charging_full", value:"\ue1a3"}
        ,{ name:"battery_full", value:"\ue1a4"}
        ,{ name:"battery_std", value:"\ue1a5"}
        ,{ name:"battery_unknown", value:"\ue1a6"}
        ,{ name:"beach_access", value:"\ueb3e"}
        ,{ name:"beenhere", value:"\ue52d"}
        ,{ name:"block", value:"\ue14b"}
        ,{ name:"bluetooth", value:"\ue1a7"}
        ,{ name:"bluetooth_audio", value:"\ue60f"}
        ,{ name:"bluetooth_connected", value:"\ue1a8"}
        ,{ name:"bluetooth_disabled", value:"\ue1a9"}
        ,{ name:"bluetooth_searching", value:"\ue1aa"}
        ,{ name:"blur_circular", value:"\ue3a2"}
        ,{ name:"blur_linear", value:"\ue3a3"}
        ,{ name:"blur_off", value:"\ue3a4"}
        ,{ name:"blur_on", value:"\ue3a5"}
        ,{ name:"book", value:"\ue865"}
        ,{ name:"bookmark", value:"\ue866"}
        ,{ name:"bookmark_border", value:"\ue867"}
        ,{ name:"border_all", value:"\ue228"}
        ,{ name:"border_bottom", value:"\ue229"}
        ,{ name:"border_clear", value:"\ue22a"}
        ,{ name:"border_color", value:"\ue22b"}
        ,{ name:"border_horizontal", value:"\ue22c"}
        ,{ name:"border_inner", value:"\ue22d"}
        ,{ name:"border_left", value:"\ue22e"}
        ,{ name:"border_outer", value:"\ue22f"}
        ,{ name:"border_right", value:"\ue230"}
        ,{ name:"border_style", value:"\ue231"}
        ,{ name:"border_top", value:"\ue232"}
        ,{ name:"border_vertical", value:"\ue233"}
        ,{ name:"branding_watermark", value:"\ue06b"}
        ,{ name:"brightness_1", value:"\ue3a6"}
        ,{ name:"brightness_2", value:"\ue3a7"}
        ,{ name:"brightness_3", value:"\ue3a8"}
        ,{ name:"brightness_4", value:"\ue3a9"}
        ,{ name:"brightness_5", value:"\ue3aa"}
        ,{ name:"brightness_6", value:"\ue3ab"}
        ,{ name:"brightness_7", value:"\ue3ac"}
        ,{ name:"brightness_auto", value:"\ue1ab"}
        ,{ name:"brightness_high", value:"\ue1ac"}
        ,{ name:"brightness_low", value:"\ue1ad"}
        ,{ name:"brightness_medium", value:"\ue1ae"}
        ,{ name:"broken_image", value:"\ue3ad"}
        ,{ name:"brush", value:"\ue3ae"}
        ,{ name:"bubble_chart", value:"\ue6dd"}
        ,{ name:"bug_report", value:"\ue868"}
        ,{ name:"build", value:"\ue869"}
        ,{ name:"burst_mode", value:"\ue43c"}
        ,{ name:"business", value:"\ue0af"}
        ,{ name:"business_center", value:"\ueb3f"}
        ,{ name:"cached", value:"\ue86a"}
        ,{ name:"cake", value:"\ue7e9"}
        ,{ name:"call", value:"\ue0b0"}
        ,{ name:"call_end", value:"\ue0b1"}
        ,{ name:"call_made", value:"\ue0b2"}
        ,{ name:"call_merge", value:"\ue0b3"}
        ,{ name:"call_missed", value:"\ue0b4"}
        ,{ name:"call_missed_outgoing", value:"\ue0e4"}
        ,{ name:"call_received", value:"\ue0b5"}
        ,{ name:"call_split", value:"\ue0b6"}
        ,{ name:"call_to_action", value:"\ue06c"}
        ,{ name:"camera", value:"\ue3af"}
        ,{ name:"camera_alt", value:"\ue3b0"}
        ,{ name:"camera_enhance", value:"\ue8fc"}
        ,{ name:"camera_front", value:"\ue3b1"}
        ,{ name:"camera_rear", value:"\ue3b2"}
        ,{ name:"camera_roll", value:"\ue3b3"}
        ,{ name:"cancel", value:"\ue5c9"}
        ,{ name:"card_giftcard", value:"\ue8f6"}
        ,{ name:"card_membership", value:"\ue8f7"}
        ,{ name:"card_travel", value:"\ue8f8"}
        ,{ name:"casino", value:"\ueb40"}
        ,{ name:"cast", value:"\ue307"}
        ,{ name:"cast_connected", value:"\ue308"}
        ,{ name:"center_focus_strong", value:"\ue3b4"}
        ,{ name:"center_focus_weak", value:"\ue3b5"}
        ,{ name:"change_history", value:"\ue86b"}
        ,{ name:"chat", value:"\ue0b7"}
        ,{ name:"chat_bubble", value:"\ue0ca"}
        ,{ name:"chat_bubble_outline", value:"\ue0cb"}
        ,{ name:"check", value:"\ue5ca"}
        ,{ name:"check_box", value:"\ue834"}
        ,{ name:"check_box_outline_blank", value:"\ue835"}
        ,{ name:"check_circle", value:"\ue86c"}
        ,{ name:"chevron_left", value:"\ue5cb"}
        ,{ name:"chevron_right", value:"\ue5cc"}
        ,{ name:"child_care", value:"\ueb41"}
        ,{ name:"child_friendly", value:"\ueb42"}
        ,{ name:"chrome_reader_mode", value:"\ue86d"}
        ,{ name:"iconclass", value:"\ue86e"}
        ,{ name:"clear", value:"\ue14c"}
        ,{ name:"clear_all", value:"\ue0b8"}
        ,{ name:"close", value:"\ue5cd"}
        ,{ name:"closed_caption", value:"\ue01c"}
        ,{ name:"cloud", value:"\ue2bd"}
        ,{ name:"cloud_circle", value:"\ue2be"}
        ,{ name:"cloud_done", value:"\ue2bf"}
        ,{ name:"cloud_download", value:"\ue2c0"}
        ,{ name:"cloud_off", value:"\ue2c1"}
        ,{ name:"cloud_queue", value:"\ue2c2"}
        ,{ name:"cloud_upload", value:"\ue2c3"}
        ,{ name:"code", value:"\ue86f"}
        ,{ name:"collections", value:"\ue3b6"}
        ,{ name:"collections_bookmark", value:"\ue431"}
        ,{ name:"color_lens", value:"\ue3b7"}
        ,{ name:"colorize", value:"\ue3b8"}
        ,{ name:"comment", value:"\ue0b9"}
        ,{ name:"compare", value:"\ue3b9"}
        ,{ name:"compare_arrows", value:"\ue915"}
        ,{ name:"computer", value:"\ue30a"}
        ,{ name:"confirmation_number", value:"\ue638"}
        ,{ name:"contact_mail", value:"\ue0d0"}
        ,{ name:"contact_phone", value:"\ue0cf"}
        ,{ name:"contacts", value:"\ue0ba"}
        ,{ name:"content_copy", value:"\ue14d"}
        ,{ name:"content_cut", value:"\ue14e"}
        ,{ name:"content_paste", value:"\ue14f"}
        ,{ name:"control_point", value:"\ue3ba"}
        ,{ name:"control_point_duplicate", value:"\ue3bb"}
        ,{ name:"copyright", value:"\ue90c"}
        ,{ name:"create", value:"\ue150"}
        ,{ name:"create_new_folder", value:"\ue2cc"}
        ,{ name:"credit_card", value:"\ue870"}
        ,{ name:"crop", value:"\ue3be"}
        ,{ name:"crop_16_9", value:"\ue3bc"}
        ,{ name:"crop_3_2", value:"\ue3bd"}
        ,{ name:"crop_5_4", value:"\ue3bf"}
        ,{ name:"crop_7_5", value:"\ue3c0"}
        ,{ name:"crop_din", value:"\ue3c1"}
        ,{ name:"crop_free", value:"\ue3c2"}
        ,{ name:"crop_landscape", value:"\ue3c3"}
        ,{ name:"crop_original", value:"\ue3c4"}
        ,{ name:"crop_portrait", value:"\ue3c5"}
        ,{ name:"crop_rotate", value:"\ue437"}
        ,{ name:"crop_square", value:"\ue3c6"}
        ,{ name:"dashboard", value:"\ue871"}
        ,{ name:"data_usage", value:"\ue1af"}
        ,{ name:"date_range", value:"\ue916"}
        ,{ name:"dehaze", value:"\ue3c7"}
        ,{ name:"icondelete", value:"\ue872"}
        ,{ name:"delete_forever", value:"\ue92b"}
        ,{ name:"delete_sweep", value:"\ue16c"}
        ,{ name:"description", value:"\ue873"}
        ,{ name:"desktop_mac", value:"\ue30b"}
        ,{ name:"desktop_windows", value:"\ue30c"}
        ,{ name:"details", value:"\ue3c8"}
        ,{ name:"developer_board", value:"\ue30d"}
        ,{ name:"developer_mode", value:"\ue1b0"}
        ,{ name:"device_hub", value:"\ue335"}
        ,{ name:"devices", value:"\ue1b1"}
        ,{ name:"devices_other", value:"\ue337"}
        ,{ name:"dialer_sip", value:"\ue0bb"}
        ,{ name:"dialpad", value:"\ue0bc"}
        ,{ name:"directions", value:"\ue52e"}
        ,{ name:"directions_bike", value:"\ue52f"}
        ,{ name:"directions_boat", value:"\ue532"}
        ,{ name:"directions_bus", value:"\ue530"}
        ,{ name:"directions_car", value:"\ue531"}
        ,{ name:"directions_railway", value:"\ue534"}
        ,{ name:"directions_run", value:"\ue566"}
        ,{ name:"directions_subway", value:"\ue533"}
        ,{ name:"directions_transit", value:"\ue535"}
        ,{ name:"directions_walk", value:"\ue536"}
        ,{ name:"disc_full", value:"\ue610"}
        ,{ name:"dns", value:"\ue875"}
        ,{ name:"do_not_disturb", value:"\ue612"}
        ,{ name:"do_not_disturb_alt", value:"\ue611"}
        ,{ name:"do_not_disturb_off", value:"\ue643"}
        ,{ name:"do_not_disturb_on", value:"\ue644"}
        ,{ name:"dock", value:"\ue30e"}
        ,{ name:"domain", value:"\ue7ee"}
        ,{ name:"done", value:"\ue876"}
        ,{ name:"done_all", value:"\ue877"}
        ,{ name:"donut_large", value:"\ue917"}
        ,{ name:"donut_small", value:"\ue918"}
        ,{ name:"drafts", value:"\ue151"}
        ,{ name:"drag_handle", value:"\ue25d"}
        ,{ name:"drive_eta", value:"\ue613"}
        ,{ name:"dvr", value:"\ue1b2"}
        ,{ name:"edit", value:"\ue3c9"}
        ,{ name:"edit_location", value:"\ue568"}
        ,{ name:"eject", value:"\ue8fb"}
        ,{ name:"email", value:"\ue0be"}
        ,{ name:"enhanced_encryption", value:"\ue63f"}
        ,{ name:"equalizer", value:"\ue01d"}
        ,{ name:"error", value:"\ue000"}
        ,{ name:"error_outline", value:"\ue001"}
        ,{ name:"euro_symbol", value:"\ue926"}
        ,{ name:"ev_station", value:"\ue56d"}
        ,{ name:"event", value:"\ue878"}
        ,{ name:"event_available", value:"\ue614"}
        ,{ name:"event_busy", value:"\ue615"}
        ,{ name:"event_note", value:"\ue616"}
        ,{ name:"event_seat", value:"\ue903"}
        ,{ name:"exit_to_app", value:"\ue879"}
        ,{ name:"expand_less", value:"\ue5ce"}
        ,{ name:"expand_more", value:"\ue5cf"}
        ,{ name:"explicit", value:"\ue01e"}
        ,{ name:"explore", value:"\ue87a"}
        ,{ name:"exposure", value:"\ue3ca"}
        ,{ name:"exposure_neg_1", value:"\ue3cb"}
        ,{ name:"exposure_neg_2", value:"\ue3cc"}
        ,{ name:"exposure_plus_1", value:"\ue3cd"}
        ,{ name:"exposure_plus_2", value:"\ue3ce"}
        ,{ name:"exposure_zero", value:"\ue3cf"}
        ,{ name:"extension", value:"\ue87b"}
        ,{ name:"face", value:"\ue87c"}
        ,{ name:"fast_forward", value:"\ue01f"}
        ,{ name:"fast_rewind", value:"\ue020"}
        ,{ name:"favorite", value:"\ue87d"}
        ,{ name:"favorite_border", value:"\ue87e"}
        ,{ name:"featured_play_list", value:"\ue06d"}
        ,{ name:"featured_video", value:"\ue06e"}
        ,{ name:"feedback", value:"\ue87f"}
        ,{ name:"fiber_dvr", value:"\ue05d"}
        ,{ name:"fiber_manual_record", value:"\ue061"}
        ,{ name:"fiber_new", value:"\ue05e"}
        ,{ name:"fiber_pin", value:"\ue06a"}
        ,{ name:"fiber_smart_record", value:"\ue062"}
        ,{ name:"file_download", value:"\ue2c4"}
        ,{ name:"file_upload", value:"\ue2c6"}
        ,{ name:"filter", value:"\ue3d3"}
        ,{ name:"filter_1", value:"\ue3d0"}
        ,{ name:"filter_2", value:"\ue3d1"}
        ,{ name:"filter_3", value:"\ue3d2"}
        ,{ name:"filter_4", value:"\ue3d4"}
        ,{ name:"filter_5", value:"\ue3d5"}
        ,{ name:"filter_6", value:"\ue3d6"}
        ,{ name:"filter_7", value:"\ue3d7"}
        ,{ name:"filter_8", value:"\ue3d8"}
        ,{ name:"filter_9", value:"\ue3d9"}
        ,{ name:"filter_9_plus", value:"\ue3da"}
        ,{ name:"filter_b_and_w", value:"\ue3db"}
        ,{ name:"filter_center_focus", value:"\ue3dc"}
        ,{ name:"filter_drama", value:"\ue3dd"}
        ,{ name:"filter_frames", value:"\ue3de"}
        ,{ name:"filter_hdr", value:"\ue3df"}
        ,{ name:"filter_list", value:"\ue152"}
        ,{ name:"filter_none", value:"\ue3e0"}
        ,{ name:"filter_tilt_shift", value:"\ue3e2"}
        ,{ name:"filter_vintage", value:"\ue3e3"}
        ,{ name:"find_in_page", value:"\ue880"}
        ,{ name:"find_replace", value:"\ue881"}
        ,{ name:"fingerprint", value:"\ue90d"}
        ,{ name:"first_page", value:"\ue5dc"}
        ,{ name:"fitness_center", value:"\ueb43"}
        ,{ name:"flag", value:"\ue153"}
        ,{ name:"flare", value:"\ue3e4"}
        ,{ name:"flash_auto", value:"\ue3e5"}
        ,{ name:"flash_off", value:"\ue3e6"}
        ,{ name:"flash_on", value:"\ue3e7"}
        ,{ name:"flight", value:"\ue539"}
        ,{ name:"flight_land", value:"\ue904"}
        ,{ name:"flight_takeoff", value:"\ue905"}
        ,{ name:"flip", value:"\ue3e8"}
        ,{ name:"flip_to_back", value:"\ue882"}
        ,{ name:"flip_to_front", value:"\ue883"}
        ,{ name:"folder", value:"\ue2c7"}
        ,{ name:"folder_open", value:"\ue2c8"}
        ,{ name:"folder_shared", value:"\ue2c9"}
        ,{ name:"folder_special", value:"\ue617"}
        ,{ name:"font_download", value:"\ue167"}
        ,{ name:"format_align_center", value:"\ue234"}
        ,{ name:"format_align_justify", value:"\ue235"}
        ,{ name:"format_align_left", value:"\ue236"}
        ,{ name:"format_align_right", value:"\ue237"}
        ,{ name:"format_bold", value:"\ue238"}
        ,{ name:"format_clear", value:"\ue239"}
        ,{ name:"format_color_fill", value:"\ue23a"}
        ,{ name:"format_color_reset", value:"\ue23b"}
        ,{ name:"format_color_text", value:"\ue23c"}
        ,{ name:"format_indent_decrease", value:"\ue23d"}
        ,{ name:"format_indent_increase", value:"\ue23e"}
        ,{ name:"format_italic", value:"\ue23f"}
        ,{ name:"format_line_spacing", value:"\ue240"}
        ,{ name:"format_list_bulleted", value:"\ue241"}
        ,{ name:"format_list_numbered", value:"\ue242"}
        ,{ name:"format_paint", value:"\ue243"}
        ,{ name:"format_quote", value:"\ue244"}
        ,{ name:"format_shapes", value:"\ue25e"}
        ,{ name:"format_size", value:"\ue245"}
        ,{ name:"format_strikethrough", value:"\ue246"}
        ,{ name:"format_textdirection_l_to_r", value:"\ue247"}
        ,{ name:"format_textdirection_r_to_l", value:"\ue248"}
        ,{ name:"format_underlined", value:"\ue249"}
        ,{ name:"forum", value:"\ue0bf"}
        ,{ name:"forward", value:"\ue154"}
        ,{ name:"forward_10", value:"\ue056"}
        ,{ name:"forward_30", value:"\ue057"}
        ,{ name:"forward_5", value:"\ue058"}
        ,{ name:"free_breakfast", value:"\ueb44"}
        ,{ name:"fullscreen", value:"\ue5d0"}
        ,{ name:"fullscreen_exit", value:"\ue5d1"}
        ,{ name:"functions", value:"\ue24a"}
        ,{ name:"g_translate", value:"\ue927"}
        ,{ name:"gamepad", value:"\ue30f"}
        ,{ name:"games", value:"\ue021"}
        ,{ name:"gavel", value:"\ue90e"}
        ,{ name:"gesture", value:"\ue155"}
        ,{ name:"get_app", value:"\ue884"}
        ,{ name:"gif", value:"\ue908"}
        ,{ name:"golf_course", value:"\ueb45"}
        ,{ name:"gps_fixed", value:"\ue1b3"}
        ,{ name:"gps_not_fixed", value:"\ue1b4"}
        ,{ name:"gps_off", value:"\ue1b5"}
        ,{ name:"grade", value:"\ue885"}
        ,{ name:"gradient", value:"\ue3e9"}
        ,{ name:"grain", value:"\ue3ea"}
        ,{ name:"graphic_eq", value:"\ue1b8"}
        ,{ name:"grid_off", value:"\ue3eb"}
        ,{ name:"grid_on", value:"\ue3ec"}
        ,{ name:"group", value:"\ue7ef"}
        ,{ name:"group_add", value:"\ue7f0"}
        ,{ name:"group_work", value:"\ue886"}
        ,{ name:"hd", value:"\ue052"}
        ,{ name:"hdr_off", value:"\ue3ed"}
        ,{ name:"hdr_on", value:"\ue3ee"}
        ,{ name:"hdr_strong", value:"\ue3f1"}
        ,{ name:"hdr_weak", value:"\ue3f2"}
        ,{ name:"headset", value:"\ue310"}
        ,{ name:"headset_mic", value:"\ue311"}
        ,{ name:"healing", value:"\ue3f3"}
        ,{ name:"hearing", value:"\ue023"}
        ,{ name:"help", value:"\ue887"}
        ,{ name:"help_outline", value:"\ue8fd"}
        ,{ name:"high_quality", value:"\ue024"}
        ,{ name:"highlight", value:"\ue25f"}
        ,{ name:"highlight_off", value:"\ue888"}
        ,{ name:"history", value:"\ue889"}
        ,{ name:"home", value:"\ue88a"}
        ,{ name:"hot_tub", value:"\ueb46"}
        ,{ name:"hotel", value:"\ue53a"}
        ,{ name:"hourglass_empty", value:"\ue88b"}
        ,{ name:"hourglass_full", value:"\ue88c"}
        ,{ name:"http", value:"\ue902"}
        ,{ name:"https", value:"\ue88d"}
        ,{ name:"image", value:"\ue3f4"}
        ,{ name:"image_aspect_ratio", value:"\ue3f5"}
        ,{ name:"import_contacts", value:"\ue0e0"}
        ,{ name:"import_export", value:"\ue0c3"}
        ,{ name:"important_devices", value:"\ue912"}
        ,{ name:"inbox", value:"\ue156"}
        ,{ name:"indeterminate_check_box", value:"\ue909"}
        ,{ name:"info", value:"\ue88e"}
        ,{ name:"info_outline", value:"\ue88f"}
        ,{ name:"input", value:"\ue890"}
        ,{ name:"insert_chart", value:"\ue24b"}
        ,{ name:"insert_comment", value:"\ue24c"}
        ,{ name:"insert_drive_file", value:"\ue24d"}
        ,{ name:"insert_emoticon", value:"\ue24e"}
        ,{ name:"insert_invitation", value:"\ue24f"}
        ,{ name:"insert_link", value:"\ue250"}
        ,{ name:"insert_photo", value:"\ue251"}
        ,{ name:"invert_colors", value:"\ue891"}
        ,{ name:"invert_colors_off", value:"\ue0c4"}
        ,{ name:"iso", value:"\ue3f6"}
        ,{ name:"keyboard", value:"\ue312"}
        ,{ name:"keyboard_arrow_down", value:"\ue313"}
        ,{ name:"keyboard_arrow_left", value:"\ue314"}
        ,{ name:"keyboard_arrow_right", value:"\ue315"}
        ,{ name:"keyboard_arrow_up", value:"\ue316"}
        ,{ name:"keyboard_backspace", value:"\ue317"}
        ,{ name:"keyboard_capslock", value:"\ue318"}
        ,{ name:"keyboard_hide", value:"\ue31a"}
        ,{ name:"keyboard_return", value:"\ue31b"}
        ,{ name:"keyboard_tab", value:"\ue31c"}
        ,{ name:"keyboard_voice", value:"\ue31d"}
        ,{ name:"kitchen", value:"\ueb47"}
        ,{ name:"label", value:"\ue892"}
        ,{ name:"label_outline", value:"\ue893"}
        ,{ name:"landscape", value:"\ue3f7"}
        ,{ name:"language", value:"\ue894"}
        ,{ name:"laptop", value:"\ue31e"}
        ,{ name:"laptop_chromebook", value:"\ue31f"}
        ,{ name:"laptop_mac", value:"\ue320"}
        ,{ name:"laptop_windows", value:"\ue321"}
        ,{ name:"last_page", value:"\ue5dd"}
        ,{ name:"launch", value:"\ue895"}
        ,{ name:"layers", value:"\ue53b"}
        ,{ name:"layers_clear", value:"\ue53c"}
        ,{ name:"leak_add", value:"\ue3f8"}
        ,{ name:"leak_remove", value:"\ue3f9"}
        ,{ name:"lens", value:"\ue3fa"}
        ,{ name:"library_add", value:"\ue02e"}
        ,{ name:"library_books", value:"\ue02f"}
        ,{ name:"library_music", value:"\ue030"}
        ,{ name:"lightbulb_outline", value:"\ue90f"}
        ,{ name:"line_style", value:"\ue919"}
        ,{ name:"line_weight", value:"\ue91a"}
        ,{ name:"linear_scale", value:"\ue260"}
        ,{ name:"link", value:"\ue157"}
        ,{ name:"linked_camera", value:"\ue438"}
        ,{ name:"list", value:"\ue896"}
        ,{ name:"live_help", value:"\ue0c6"}
        ,{ name:"live_tv", value:"\ue639"}
        ,{ name:"local_activity", value:"\ue53f"}
        ,{ name:"local_airport", value:"\ue53d"}
        ,{ name:"local_atm", value:"\ue53e"}
        ,{ name:"local_bar", value:"\ue540"}
        ,{ name:"local_cafe", value:"\ue541"}
        ,{ name:"local_car_wash", value:"\ue542"}
        ,{ name:"local_convenience_store", value:"\ue543"}
        ,{ name:"local_dining", value:"\ue556"}
        ,{ name:"local_drink", value:"\ue544"}
        ,{ name:"local_florist", value:"\ue545"}
        ,{ name:"local_gas_station", value:"\ue546"}
        ,{ name:"local_grocery_store", value:"\ue547"}
        ,{ name:"local_hospital", value:"\ue548"}
        ,{ name:"local_hotel", value:"\ue549"}
        ,{ name:"local_laundry_service", value:"\ue54a"}
        ,{ name:"local_library", value:"\ue54b"}
        ,{ name:"local_mall", value:"\ue54c"}
        ,{ name:"local_movies", value:"\ue54d"}
        ,{ name:"local_offer", value:"\ue54e"}
        ,{ name:"local_parking", value:"\ue54f"}
        ,{ name:"local_pharmacy", value:"\ue550"}
        ,{ name:"local_phone", value:"\ue551"}
        ,{ name:"local_pizza", value:"\ue552"}
        ,{ name:"local_play", value:"\ue553"}
        ,{ name:"local_post_office", value:"\ue554"}
        ,{ name:"local_printshop", value:"\ue555"}
        ,{ name:"local_see", value:"\ue557"}
        ,{ name:"local_shipping", value:"\ue558"}
        ,{ name:"local_taxi", value:"\ue559"}
        ,{ name:"location_city", value:"\ue7f1"}
        ,{ name:"location_disabled", value:"\ue1b6"}
        ,{ name:"location_off", value:"\ue0c7"}
        ,{ name:"location_on", value:"\ue0c8"}
        ,{ name:"location_searching", value:"\ue1b7"}
        ,{ name:"lock", value:"\ue897"}
        ,{ name:"lock_open", value:"\ue898"}
        ,{ name:"lock_outline", value:"\ue899"}
        ,{ name:"looks", value:"\ue3fc"}
        ,{ name:"looks_3", value:"\ue3fb"}
        ,{ name:"looks_4", value:"\ue3fd"}
        ,{ name:"looks_5", value:"\ue3fe"}
        ,{ name:"looks_6", value:"\ue3ff"}
        ,{ name:"looks_one", value:"\ue400"}
        ,{ name:"looks_two", value:"\ue401"}
        ,{ name:"loop", value:"\ue028"}
        ,{ name:"loupe", value:"\ue402"}
        ,{ name:"low_priority", value:"\ue16d"}
        ,{ name:"loyalty", value:"\ue89a"}
        ,{ name:"mail", value:"\ue158"}
        ,{ name:"mail_outline", value:"\ue0e1"}
        ,{ name:"map", value:"\ue55b"}
        ,{ name:"markunread", value:"\ue159"}
        ,{ name:"markunread_mailbox", value:"\ue89b"}
        ,{ name:"memory", value:"\ue322"}
        ,{ name:"menu", value:"\ue5d2"}
        ,{ name:"merge_type", value:"\ue252"}
        ,{ name:"message", value:"\ue0c9"}
        ,{ name:"mic", value:"\ue029"}
        ,{ name:"mic_none", value:"\ue02a"}
        ,{ name:"mic_off", value:"\ue02b"}
        ,{ name:"mms", value:"\ue618"}
        ,{ name:"mode_comment", value:"\ue253"}
        ,{ name:"mode_edit", value:"\ue254"}
        ,{ name:"monetization_on", value:"\ue263"}
        ,{ name:"money_off", value:"\ue25c"}
        ,{ name:"monochrome_photos", value:"\ue403"}
        ,{ name:"mood", value:"\ue7f2"}
        ,{ name:"mood_bad", value:"\ue7f3"}
        ,{ name:"more", value:"\ue619"}
        ,{ name:"more_horiz", value:"\ue5d3"}
        ,{ name:"more_vert", value:"\ue5d4"}
        ,{ name:"motorcycle", value:"\ue91b"}
        ,{ name:"mouse", value:"\ue323"}
        ,{ name:"move_to_inbox", value:"\ue168"}
        ,{ name:"movie", value:"\ue02c"}
        ,{ name:"movie_creation", value:"\ue404"}
        ,{ name:"movie_filter", value:"\ue43a"}
        ,{ name:"multiline_chart", value:"\ue6df"}
        ,{ name:"music_note", value:"\ue405"}
        ,{ name:"music_video", value:"\ue063"}
        ,{ name:"my_location", value:"\ue55c"}
        ,{ name:"nature", value:"\ue406"}
        ,{ name:"nature_people", value:"\ue407"}
        ,{ name:"navigate_before", value:"\ue408"}
        ,{ name:"navigate_next", value:"\ue409"}
        ,{ name:"navigation", value:"\ue55d"}
        ,{ name:"near_me", value:"\ue569"}
        ,{ name:"network_cell", value:"\ue1b9"}
        ,{ name:"network_check", value:"\ue640"}
        ,{ name:"network_locked", value:"\ue61a"}
        ,{ name:"network_wifi", value:"\ue1ba"}
        ,{ name:"new_releases", value:"\ue031"}
        ,{ name:"next_week", value:"\ue16a"}
        ,{ name:"nfc", value:"\ue1bb"}
        ,{ name:"no_encryption", value:"\ue641"}
        ,{ name:"no_sim", value:"\ue0cc"}
        ,{ name:"not_interested", value:"\ue033"}
        ,{ name:"note", value:"\ue06f"}
        ,{ name:"note_add", value:"\ue89c"}
        ,{ name:"notifications", value:"\ue7f4"}
        ,{ name:"notifications_active", value:"\ue7f7"}
        ,{ name:"notifications_none", value:"\ue7f5"}
        ,{ name:"notifications_off", value:"\ue7f6"}
        ,{ name:"notifications_paused", value:"\ue7f8"}
        ,{ name:"offline_pin", value:"\ue90a"}
        ,{ name:"ondemand_video", value:"\ue63a"}
        ,{ name:"opacity", value:"\ue91c"}
        ,{ name:"open_in_browser", value:"\ue89d"}
        ,{ name:"open_in_new", value:"\ue89e"}
        ,{ name:"open_with", value:"\ue89f"}
        ,{ name:"pages", value:"\ue7f9"}
        ,{ name:"pageview", value:"\ue8a0"}
        ,{ name:"palette", value:"\ue40a"}
        ,{ name:"pan_tool", value:"\ue925"}
        ,{ name:"panorama", value:"\ue40b"}
        ,{ name:"panorama_fish_eye", value:"\ue40c"}
        ,{ name:"panorama_horizontal", value:"\ue40d"}
        ,{ name:"panorama_vertical", value:"\ue40e"}
        ,{ name:"panorama_wide_angle", value:"\ue40f"}
        ,{ name:"party_mode", value:"\ue7fa"}
        ,{ name:"pause", value:"\ue034"}
        ,{ name:"pause_circle_filled", value:"\ue035"}
        ,{ name:"pause_circle_outline", value:"\ue036"}
        ,{ name:"payment", value:"\ue8a1"}
        ,{ name:"people", value:"\ue7fb"}
        ,{ name:"people_outline", value:"\ue7fc"}
        ,{ name:"perm_camera_mic", value:"\ue8a2"}
        ,{ name:"perm_contact_calendar", value:"\ue8a3"}
        ,{ name:"perm_data_setting", value:"\ue8a4"}
        ,{ name:"perm_device_information", value:"\ue8a5"}
        ,{ name:"perm_identity", value:"\ue8a6"}
        ,{ name:"perm_media", value:"\ue8a7"}
        ,{ name:"perm_phone_msg", value:"\ue8a8"}
        ,{ name:"perm_scan_wifi", value:"\ue8a9"}
        ,{ name:"person", value:"\ue7fd"}
        ,{ name:"person_add", value:"\ue7fe"}
        ,{ name:"person_outline", value:"\ue7ff"}
        ,{ name:"person_pin", value:"\ue55a"}
        ,{ name:"person_pin_circle", value:"\ue56a"}
        ,{ name:"personal_video", value:"\ue63b"}
        ,{ name:"pets", value:"\ue91d"}
        ,{ name:"phone", value:"\ue0cd"}
        ,{ name:"phone_android", value:"\ue324"}
        ,{ name:"phone_bluetooth_speaker", value:"\ue61b"}
        ,{ name:"phone_forwarded", value:"\ue61c"}
        ,{ name:"phone_in_talk", value:"\ue61d"}
        ,{ name:"phone_iphone", value:"\ue325"}
        ,{ name:"phone_locked", value:"\ue61e"}
        ,{ name:"phone_missed", value:"\ue61f"}
        ,{ name:"phone_paused", value:"\ue620"}
        ,{ name:"phonelink", value:"\ue326"}
        ,{ name:"phonelink_erase", value:"\ue0db"}
        ,{ name:"phonelink_lock", value:"\ue0dc"}
        ,{ name:"phonelink_off", value:"\ue327"}
        ,{ name:"phonelink_ring", value:"\ue0dd"}
        ,{ name:"phonelink_setup", value:"\ue0de"}
        ,{ name:"photo", value:"\ue410"}
        ,{ name:"photo_album", value:"\ue411"}
        ,{ name:"photo_camera", value:"\ue412"}
        ,{ name:"photo_filter", value:"\ue43b"}
        ,{ name:"photo_library", value:"\ue413"}
        ,{ name:"photo_size_select_actual", value:"\ue432"}
        ,{ name:"photo_size_select_large", value:"\ue433"}
        ,{ name:"photo_size_select_small", value:"\ue434"}
        ,{ name:"picture_as_pdf", value:"\ue415"}
        ,{ name:"picture_in_picture", value:"\ue8aa"}
        ,{ name:"picture_in_picture_alt", value:"\ue911"}
        ,{ name:"pie_chart", value:"\ue6c4"}
        ,{ name:"pie_chart_outlined", value:"\ue6c5"}
        ,{ name:"pin_drop", value:"\ue55e"}
        ,{ name:"place", value:"\ue55f"}
        ,{ name:"play_arrow", value:"\ue037"}
        ,{ name:"play_circle_filled", value:"\ue038"}
        ,{ name:"play_circle_outline", value:"\ue039"}
        ,{ name:"play_for_work", value:"\ue906"}
        ,{ name:"playlist_add", value:"\ue03b"}
        ,{ name:"playlist_add_check", value:"\ue065"}
        ,{ name:"playlist_play", value:"\ue05f"}
        ,{ name:"plus_one", value:"\ue800"}
        ,{ name:"poll", value:"\ue801"}
        ,{ name:"polymer", value:"\ue8ab"}
        ,{ name:"pool", value:"\ueb48"}
        ,{ name:"portable_wifi_off", value:"\ue0ce"}
        ,{ name:"portrait", value:"\ue416"}
        ,{ name:"power", value:"\ue63c"}
        ,{ name:"power_input", value:"\ue336"}
        ,{ name:"power_settings_new", value:"\ue8ac"}
        ,{ name:"pregnant_woman", value:"\ue91e"}
        ,{ name:"present_to_all", value:"\ue0df"}
        ,{ name:"iconprint", value:"\ue8ad"}
        ,{ name:"priority_high", value:"\ue645"}
        ,{ name:"iconpublic", value:"\ue80b"}
        ,{ name:"publish", value:"\ue255"}
        ,{ name:"query_builder", value:"\ue8ae"}
        ,{ name:"question_answer", value:"\ue8af"}
        ,{ name:"queue", value:"\ue03c"}
        ,{ name:"queue_music", value:"\ue03d"}
        ,{ name:"queue_play_next", value:"\ue066"}
        ,{ name:"radio", value:"\ue03e"}
        ,{ name:"radio_button_checked", value:"\ue837"}
        ,{ name:"radio_button_unchecked", value:"\ue836"}
        ,{ name:"rate_review", value:"\ue560"}
        ,{ name:"receipt", value:"\ue8b0"}
        ,{ name:"recent_actors", value:"\ue03f"}
        ,{ name:"record_voice_over", value:"\ue91f"}
        ,{ name:"redeem", value:"\ue8b1"}
        ,{ name:"redo", value:"\ue15a"}
        ,{ name:"refresh", value:"\ue5d5"}
        ,{ name:"remove", value:"\ue15b"}
        ,{ name:"remove_circle", value:"\ue15c"}
        ,{ name:"remove_circle_outline", value:"\ue15d"}
        ,{ name:"remove_from_queue", value:"\ue067"}
        ,{ name:"remove_red_eye", value:"\ue417"}
        ,{ name:"remove_shopping_cart", value:"\ue928"}
        ,{ name:"reorder", value:"\ue8fe"}
        ,{ name:"repeat", value:"\ue040"}
        ,{ name:"repeat_one", value:"\ue041"}
        ,{ name:"replay", value:"\ue042"}
        ,{ name:"replay_10", value:"\ue059"}
        ,{ name:"replay_30", value:"\ue05a"}
        ,{ name:"replay_5", value:"\ue05b"}
        ,{ name:"reply", value:"\ue15e"}
        ,{ name:"reply_all", value:"\ue15f"}
        ,{ name:"report", value:"\ue160"}
        ,{ name:"report_problem", value:"\ue8b2"}
        ,{ name:"restaurant", value:"\ue56c"}
        ,{ name:"restaurant_menu", value:"\ue561"}
        ,{ name:"restore", value:"\ue8b3"}
        ,{ name:"restore_page", value:"\ue929"}
        ,{ name:"ring_volume", value:"\ue0d1"}
        ,{ name:"room", value:"\ue8b4"}
        ,{ name:"room_service", value:"\ueb49"}
        ,{ name:"rotate_90_degrees_ccw", value:"\ue418"}
        ,{ name:"rotate_left", value:"\ue419"}
        ,{ name:"rotate_right", value:"\ue41a"}
        ,{ name:"rounded_corner", value:"\ue920"}
        ,{ name:"router", value:"\ue328"}
        ,{ name:"rowing", value:"\ue921"}
        ,{ name:"rss_feed", value:"\ue0e5"}
        ,{ name:"rv_hookup", value:"\ue642"}
        ,{ name:"satellite", value:"\ue562"}
        ,{ name:"save", value:"\ue161"}
        ,{ name:"scanner", value:"\ue329"}
        ,{ name:"schedule", value:"\ue8b5"}
        ,{ name:"school", value:"\ue80c"}
        ,{ name:"screen_lock_landscape", value:"\ue1be"}
        ,{ name:"screen_lock_portrait", value:"\ue1bf"}
        ,{ name:"screen_lock_rotation", value:"\ue1c0"}
        ,{ name:"screen_rotation", value:"\ue1c1"}
        ,{ name:"screen_share", value:"\ue0e2"}
        ,{ name:"sd_card", value:"\ue623"}
        ,{ name:"sd_storage", value:"\ue1c2"}
        ,{ name:"search", value:"\ue8b6"}
        ,{ name:"security", value:"\ue32a"}
        ,{ name:"select_all", value:"\ue162"}
        ,{ name:"send", value:"\ue163"}
        ,{ name:"sentiment_dissatisfied", value:"\ue811"}
        ,{ name:"sentiment_neutral", value:"\ue812"}
        ,{ name:"sentiment_satisfied", value:"\ue813"}
        ,{ name:"sentiment_very_dissatisfied", value:"\ue814"}
        ,{ name:"sentiment_very_satisfied", value:"\ue815"}
        ,{ name:"settings", value:"\ue8b8"}
        ,{ name:"settings_applications", value:"\ue8b9"}
        ,{ name:"settings_backup_restore", value:"\ue8ba"}
        ,{ name:"settings_bluetooth", value:"\ue8bb"}
        ,{ name:"settings_brightness", value:"\ue8bd"}
        ,{ name:"settings_cell", value:"\ue8bc"}
        ,{ name:"settings_ethernet", value:"\ue8be"}
        ,{ name:"settings_input_antenna", value:"\ue8bf"}
        ,{ name:"settings_input_component", value:"\ue8c0"}
        ,{ name:"settings_input_composite", value:"\ue8c1"}
        ,{ name:"settings_input_hdmi", value:"\ue8c2"}
        ,{ name:"settings_input_svideo", value:"\ue8c3"}
        ,{ name:"settings_overscan", value:"\ue8c4"}
        ,{ name:"settings_phone", value:"\ue8c5"}
        ,{ name:"settings_power", value:"\ue8c6"}
        ,{ name:"settings_remote", value:"\ue8c7"}
        ,{ name:"settings_system_daydream", value:"\ue1c3"}
        ,{ name:"settings_voice", value:"\ue8c8"}
        ,{ name:"share", value:"\ue80d"}
        ,{ name:"shop", value:"\ue8c9"}
        ,{ name:"shop_two", value:"\ue8ca"}
        ,{ name:"shopping_basket", value:"\ue8cb"}
        ,{ name:"shopping_cart", value:"\ue8cc"}
        ,{ name:"short_text", value:"\ue261"}
        ,{ name:"show_chart", value:"\ue6e1"}
        ,{ name:"shuffle", value:"\ue043"}
        ,{ name:"signal_cellular_4_bar", value:"\ue1c8"}
        ,{ name:"signal_cellular_connected_no_internet_4_bar", value:"\ue1cd"}
        ,{ name:"signal_cellular_no_sim", value:"\ue1ce"}
        ,{ name:"signal_cellular_null", value:"\ue1cf"}
        ,{ name:"signal_cellular_off", value:"\ue1d0"}
        ,{ name:"signal_wifi_4_bar", value:"\ue1d8"}
        ,{ name:"signal_wifi_4_bar_lock", value:"\ue1d9"}
        ,{ name:"signal_wifi_off", value:"\ue1da"}
        ,{ name:"sim_card", value:"\ue32b"}
        ,{ name:"sim_card_alert", value:"\ue624"}
        ,{ name:"skip_next", value:"\ue044"}
        ,{ name:"skip_previous", value:"\ue045"}
        ,{ name:"slideshow", value:"\ue41b"}
        ,{ name:"slow_motion_video", value:"\ue068"}
        ,{ name:"smartphone", value:"\ue32c"}
        ,{ name:"smoke_free", value:"\ueb4a"}
        ,{ name:"smoking_rooms", value:"\ueb4b"}
        ,{ name:"sms", value:"\ue625"}
        ,{ name:"sms_failed", value:"\ue626"}
        ,{ name:"snooze", value:"\ue046"}
        ,{ name:"sort", value:"\ue164"}
        ,{ name:"sort_by_alpha", value:"\ue053"}
        ,{ name:"spa", value:"\ueb4c"}
        ,{ name:"space_bar", value:"\ue256"}
        ,{ name:"speaker", value:"\ue32d"}
        ,{ name:"speaker_group", value:"\ue32e"}
        ,{ name:"speaker_notes", value:"\ue8cd"}
        ,{ name:"speaker_notes_off", value:"\ue92a"}
        ,{ name:"speaker_phone", value:"\ue0d2"}
        ,{ name:"spellcheck", value:"\ue8ce"}
        ,{ name:"star", value:"\ue838"}
        ,{ name:"star_border", value:"\ue83a"}
        ,{ name:"star_half", value:"\ue839"}
        ,{ name:"stars", value:"\ue8d0"}
        ,{ name:"stay_current_landscape", value:"\ue0d3"}
        ,{ name:"stay_current_portrait", value:"\ue0d4"}
        ,{ name:"stay_primary_landscape", value:"\ue0d5"}
        ,{ name:"stay_primary_portrait", value:"\ue0d6"}
        ,{ name:"stop", value:"\ue047"}
        ,{ name:"stop_screen_share", value:"\ue0e3"}
        ,{ name:"storage", value:"\ue1db"}
        ,{ name:"store", value:"\ue8d1"}
        ,{ name:"store_mall_directory", value:"\ue563"}
        ,{ name:"straighten", value:"\ue41c"}
        ,{ name:"streetview", value:"\ue56e"}
        ,{ name:"strikethrough_s", value:"\ue257"}
        ,{ name:"style", value:"\ue41d"}
        ,{ name:"subdirectory_arrow_left", value:"\ue5d9"}
        ,{ name:"subdirectory_arrow_right", value:"\ue5da"}
        ,{ name:"subject", value:"\ue8d2"}
        ,{ name:"subscriptions", value:"\ue064"}
        ,{ name:"subtitles", value:"\ue048"}
        ,{ name:"subway", value:"\ue56f"}
        ,{ name:"supervisor_account", value:"\ue8d3"}
        ,{ name:"surround_sound", value:"\ue049"}
        ,{ name:"swap_calls", value:"\ue0d7"}
        ,{ name:"swap_horiz", value:"\ue8d4"}
        ,{ name:"swap_vert", value:"\ue8d5"}
        ,{ name:"swap_vertical_circle", value:"\ue8d6"}
        ,{ name:"switch_camera", value:"\ue41e"}
        ,{ name:"switch_video", value:"\ue41f"}
        ,{ name:"sync", value:"\ue627"}
        ,{ name:"sync_disabled", value:"\ue628"}
        ,{ name:"sync_problem", value:"\ue629"}
        ,{ name:"system_update", value:"\ue62a"}
        ,{ name:"system_update_alt", value:"\ue8d7"}
        ,{ name:"tab", value:"\ue8d8"}
        ,{ name:"tab_unselected", value:"\ue8d9"}
        ,{ name:"tablet", value:"\ue32f"}
        ,{ name:"tablet_android", value:"\ue330"}
        ,{ name:"tablet_mac", value:"\ue331"}
        ,{ name:"tag_faces", value:"\ue420"}
        ,{ name:"tap_and_play", value:"\ue62b"}
        ,{ name:"terrain", value:"\ue564"}
        ,{ name:"text_fields", value:"\ue262"}
        ,{ name:"text_format", value:"\ue165"}
        ,{ name:"textsms", value:"\ue0d8"}
        ,{ name:"texture", value:"\ue421"}
        ,{ name:"theaters", value:"\ue8da"}
        ,{ name:"thumb_down", value:"\ue8db"}
        ,{ name:"thumb_up", value:"\ue8dc"}
        ,{ name:"thumbs_up_down", value:"\ue8dd"}
        ,{ name:"time_to_leave", value:"\ue62c"}
        ,{ name:"timelapse", value:"\ue422"}
        ,{ name:"timeline", value:"\ue922"}
        ,{ name:"timer", value:"\ue425"}
        ,{ name:"timer_10", value:"\ue423"}
        ,{ name:"timer_3", value:"\ue424"}
        ,{ name:"timer_off", value:"\ue426"}
        ,{ name:"title", value:"\ue264"}
        ,{ name:"toc", value:"\ue8de"}
        ,{ name:"today", value:"\ue8df"}
        ,{ name:"toll", value:"\ue8e0"}
        ,{ name:"tonality", value:"\ue427"}
        ,{ name:"touch_app", value:"\ue913"}
        ,{ name:"toys", value:"\ue332"}
        ,{ name:"track_changes", value:"\ue8e1"}
        ,{ name:"traffic", value:"\ue565"}
        ,{ name:"train", value:"\ue570"}
        ,{ name:"tram", value:"\ue571"}
        ,{ name:"transfer_within_a_station", value:"\ue572"}
        ,{ name:"transform", value:"\ue428"}
        ,{ name:"translate", value:"\ue8e2"}
        ,{ name:"trending_down", value:"\ue8e3"}
        ,{ name:"trending_flat", value:"\ue8e4"}
        ,{ name:"trending_up", value:"\ue8e5"}
        ,{ name:"tune", value:"\ue429"}
        ,{ name:"turned_in", value:"\ue8e6"}
        ,{ name:"turned_in_not", value:"\ue8e7"}
        ,{ name:"tv", value:"\ue333"}
        ,{ name:"unarchive", value:"\ue169"}
        ,{ name:"undo", value:"\ue166"}
        ,{ name:"unfold_less", value:"\ue5d6"}
        ,{ name:"unfold_more", value:"\ue5d7"}
        ,{ name:"update", value:"\ue923"}
        ,{ name:"usb", value:"\ue1e0"}
        ,{ name:"verified_user", value:"\ue8e8"}
        ,{ name:"vertical_align_bottom", value:"\ue258"}
        ,{ name:"vertical_align_center", value:"\ue259"}
        ,{ name:"vertical_align_top", value:"\ue25a"}
        ,{ name:"vibration", value:"\ue62d"}
        ,{ name:"video_call", value:"\ue070"}
        ,{ name:"video_label", value:"\ue071"}
        ,{ name:"video_library", value:"\ue04a"}
        ,{ name:"videocam", value:"\ue04b"}
        ,{ name:"videocam_off", value:"\ue04c"}
        ,{ name:"videogame_asset", value:"\ue338"}
        ,{ name:"view_agenda", value:"\ue8e9"}
        ,{ name:"view_array", value:"\ue8ea"}
        ,{ name:"view_carousel", value:"\ue8eb"}
        ,{ name:"view_column", value:"\ue8ec"}
        ,{ name:"view_comfy", value:"\ue42a"}
        ,{ name:"view_compact", value:"\ue42b"}
        ,{ name:"view_day", value:"\ue8ed"}
        ,{ name:"view_headline", value:"\ue8ee"}
        ,{ name:"view_list", value:"\ue8ef"}
        ,{ name:"view_module", value:"\ue8f0"}
        ,{ name:"view_quilt", value:"\ue8f1"}
        ,{ name:"view_stream", value:"\ue8f2"}
        ,{ name:"view_week", value:"\ue8f3"}
        ,{ name:"vignette", value:"\ue435"}
        ,{ name:"visibility", value:"\ue8f4"}
        ,{ name:"visibility_off", value:"\ue8f5"}
        ,{ name:"voice_chat", value:"\ue62e"}
        ,{ name:"voicemail", value:"\ue0d9"}
        ,{ name:"volume_down", value:"\ue04d"}
        ,{ name:"volume_mute", value:"\ue04e"}
        ,{ name:"volume_off", value:"\ue04f"}
        ,{ name:"volume_up", value:"\ue050"}
        ,{ name:"vpn_key", value:"\ue0da"}
        ,{ name:"vpn_lock", value:"\ue62f"}
        ,{ name:"wallpaper", value:"\ue1bc"}
        ,{ name:"warning", value:"\ue002"}
        ,{ name:"watch", value:"\ue334"}
        ,{ name:"watch_later", value:"\ue924"}
        ,{ name:"wb_auto", value:"\ue42c"}
        ,{ name:"wb_cloudy", value:"\ue42d"}
        ,{ name:"wb_incandescent", value:"\ue42e"}
        ,{ name:"wb_iridescent", value:"\ue436"}
        ,{ name:"wb_sunny", value:"\ue430"}
        ,{ name:"wc", value:"\ue63d"}
        ,{ name:"web", value:"\ue051"}
        ,{ name:"web_asset", value:"\ue069"}
        ,{ name:"weekend", value:"\ue16b"}
        ,{ name:"whatshot", value:"\ue80e"}
        ,{ name:"widgets", value:"\ue1bd"}
        ,{ name:"wifi", value:"\ue63e"}
        ,{ name:"wifi_lock", value:"\ue1e1"}
        ,{ name:"wifi_tethering", value:"\ue1e2"}
        ,{ name:"work", value:"\ue8f9"}
        ,{ name:"wrap_text", value:"\ue25b"}
        ,{ name:"youtube_searched_for", value:"\ue8fa"}
        ,{ name:"zoom_in", value:"\ue8ff"}
        ,{ name:"zoom_out", value:"\ue900"}
        ,{ name:"zoom_out_map", value:"\ue56b"}
    ]








}




