//
//  TimeZone.swift
//  CleverCam
//
//  Created by Abhinandan Prateek on 27/10/21.
//

import Foundation

public struct _time_offset {
    var timezone: String
    var offset: Double
    
   init(timezone: String, offset: Double){
        self.timezone = timezone
        self.offset = offset
    }
}


public class _timezones {
    public var tzlist:Array<_time_offset>
    
   init(){
        tzlist = []
    
        tzlist.append(_time_offset(timezone: "Africa/Abidjan", offset: 0.0))
        tzlist.append(_time_offset(timezone: "Africa/Accra", offset: 0.0))
        tzlist.append(_time_offset(timezone: "Africa/Addis_Ababa", offset: 3.0))
        tzlist.append(_time_offset(timezone: "Africa/Algiers", offset: 1.0))
        tzlist.append(_time_offset(timezone: "Africa/Asmara", offset: 3.0))
        tzlist.append(_time_offset(timezone: "Africa/Accra", offset: 3.0))
        tzlist.append(_time_offset(timezone: "Africa/Bamako", offset: 0.0))
        tzlist.append(_time_offset(timezone: "Africa/Bangui", offset: 1.0))
        tzlist.append(_time_offset(timezone: "Africa/Banjul", offset: 0.0))
        tzlist.append(_time_offset(timezone: "Africa/Bissau", offset: 0.0))
        tzlist.append(_time_offset(timezone: "Africa/Blantyre", offset: 2.0))
        tzlist.append(_time_offset(timezone: "Africa/Brazzaville", offset: 1.0))
        tzlist.append(_time_offset(timezone: "Africa/Bujumbura", offset: 2.0))
        tzlist.append(_time_offset(timezone: "Africa/Cairo", offset: 2.0))
        tzlist.append(_time_offset(timezone: "Africa/Casablanca", offset: 1.0))
        tzlist.append(_time_offset(timezone: "Africa/Ceuta", offset: 2.0))
        tzlist.append(_time_offset(timezone: "Africa/Conakry", offset: 0.0))
        tzlist.append(_time_offset(timezone: "Africa/Dakar", offset: 0.0))
        tzlist.append(_time_offset(timezone: "Africa/Dar_es_Salaam", offset: 3.0))
        tzlist.append(_time_offset(timezone: "Africa/Djibouti", offset: 3.0))
        tzlist.append(_time_offset(timezone: "Africa/Douala", offset: 1.0))
        tzlist.append(_time_offset(timezone: "Africa/El_Aaiun", offset: 1.0))
        tzlist.append(_time_offset(timezone: "Africa/Freetown", offset: 0.0))
        tzlist.append(_time_offset(timezone: "Africa/Gaborone", offset: 2.0))
        tzlist.append(_time_offset(timezone: "Africa/Harare", offset: 2.0))
        tzlist.append(_time_offset(timezone: "Africa/Johannesburg", offset: 2.0))
        tzlist.append(_time_offset(timezone: "Africa/Juba", offset: 2.0))
        tzlist.append(_time_offset(timezone: "Africa/Kampala", offset: 3.0))
        tzlist.append(_time_offset(timezone: "Africa/Khartoum", offset: 2.0))
        tzlist.append(_time_offset(timezone: "Africa/Kigali", offset: 2.0))
        tzlist.append(_time_offset(timezone: "Africa/Kinshasa", offset: 1.0))
        tzlist.append(_time_offset(timezone: "Africa/Lagos", offset: 1.0))
        tzlist.append(_time_offset(timezone: "Africa/Libreville", offset: 1.0))
        tzlist.append(_time_offset(timezone: "Africa/Lome", offset: 0.0))
        tzlist.append(_time_offset(timezone: "Africa/Luanda", offset: 1.0))
        tzlist.append(_time_offset(timezone: "Africa/Luanda", offset: 1.0)) //    +01:00
        tzlist.append(_time_offset(timezone: "Africa/Lubumbashi", offset: 2.0))//     +02:00
        tzlist.append(_time_offset(timezone: "Africa/Lusaka", offset: 2.0))//     +02:00
        tzlist.append(_time_offset(timezone: "Africa/Malabo", offset: 1.0))//     +01:00
        tzlist.append(_time_offset(timezone: "Africa/Maputo", offset: 2.0))//     +02:00
        tzlist.append(_time_offset(timezone: "Africa/Maseru ", offset: 2.0))//    +02:00
        tzlist.append(_time_offset(timezone: "Africa/Mbabane", offset: 2.0))//     +02:00
        tzlist.append(_time_offset(timezone: "Africa/Mogadishu", offset: 3.0))//     +03:00
        tzlist.append(_time_offset(timezone: "Africa/Monrovia", offset: 0.0))//          Z
        tzlist.append(_time_offset(timezone: "Africa/Nairobi", offset: 3.0))//     +03:00
        tzlist.append(_time_offset(timezone: "Africa/Ndjamena", offset: 1.0))//     +01:00
        tzlist.append(_time_offset(timezone: "Africa/Niamey", offset: 1.0))//     +01:00
        tzlist.append(_time_offset(timezone: "Africa/Nouakchott", offset: 0.0))//          Z
        tzlist.append(_time_offset(timezone: "Africa/Ouagadougou", offset: 0.0))//          Z
        tzlist.append(_time_offset(timezone: "Africa/Porto-Novo", offset: 1.0))//     +01:00
        tzlist.append(_time_offset(timezone: "Africa/Sao_Tome", offset: 0.0))//          Z
        tzlist.append(_time_offset(timezone: "Africa/Timbuktu", offset: 0.0))//          Z
        tzlist.append(_time_offset(timezone: "Africa/Tripoli", offset: 2.0))//     +02:00
        tzlist.append(_time_offset(timezone: "Africa/Tunis", offset: 1.0))//     +01:00
        tzlist.append(_time_offset(timezone: "Africa/Windhoek", offset: 2.0))//     +02:00
        tzlist.append(_time_offset(timezone: "America/Adak", offset: -9.0))//     -09:00
        tzlist.append(_time_offset(timezone: "America/Anchorage", offset: -8.0))//     -08:00
        tzlist.append(_time_offset(timezone: "America/Anguilla", offset: -4.0))//     -04:00
        tzlist.append(_time_offset(timezone: "America/Antigua", offset: -4.0))//     -04:00
        tzlist.append(_time_offset(timezone: "America/Araguaina", offset: -3.0))//     -03:00
        tzlist.append(_time_offset(timezone: "America/Argentina/Buenos_Aires", offset: -3.0))//     -03:00
        tzlist.append(_time_offset(timezone: "America/Argentina/Catamarca", offset: -3.0))//     -03:00
        tzlist.append(_time_offset(timezone: "America/Argentina/ComodRivadavia", offset: -3.0))//     -03:00
        tzlist.append(_time_offset(timezone: "America/Argentina/Cordoba", offset: -3.0))//     -03:00
        tzlist.append(_time_offset(timezone: "America/Argentina/Jujuy", offset: -3.0))//     -03:00
        tzlist.append(_time_offset(timezone: "America/Argentina/La_Rioja", offset: -3.0))//     -03:00
        tzlist.append(_time_offset(timezone: "America/Argentina/Mendoza", offset: -3.0))//     -03:00
        tzlist.append(_time_offset(timezone: "America/Argentina/Rio_Gallegos", offset: -3.0))//     -03:00
        tzlist.append(_time_offset(timezone: "America/Argentina/Salta", offset: -3.0))//     -03:00
        tzlist.append(_time_offset(timezone: "America/Argentina/San_Juan", offset: -3.0))//     -03:00
        tzlist.append(_time_offset(timezone: "America/Argentina/San_Luis", offset: 2-3.0))//     -03:00
        tzlist.append(_time_offset(timezone: "America/Argentina/Tucuman", offset: -3.0))//     -03:00
        tzlist.append(_time_offset(timezone: "America/Argentina/Ushuaia", offset: -3.0))//     -03:00
        tzlist.append(_time_offset(timezone: "America/Aruba", offset: -4.0))//     -04:00
        tzlist.append(_time_offset(timezone: "America/Asuncion", offset: -4.0))//     -04:00
        tzlist.append(_time_offset(timezone: "America/Atikokan", offset: -5.0))//     -05:00
        tzlist.append(_time_offset(timezone: "America/Atka", offset: -9.0))//     -09:00
        tzlist.append(_time_offset(timezone: "America/Bahia", offset: -3.0))//     -03:00
        tzlist.append(_time_offset(timezone: "America/Bahia_Banderas", offset: -5.0))//     -05:00
        tzlist.append(_time_offset(timezone: "America/Barbados", offset: -4.0))//     -04:00
        tzlist.append(_time_offset(timezone: "America/Belem", offset: -3.0))//     -03:00
        tzlist.append(_time_offset(timezone: "America/Belize", offset: -6.0))//     -06:00
        tzlist.append(_time_offset(timezone: "America/Blanc-Sablon", offset: -4.0))//     -04:00
        tzlist.append(_time_offset(timezone: "America/Boa_Vista", offset: -4.0))//     -04:00
        tzlist.append(_time_offset(timezone: "America/Bogota", offset: -5.0))//     -05:00
        tzlist.append(_time_offset(timezone: "America/Boise", offset: -6.0))//     -06:00
        tzlist.append(_time_offset(timezone: "America/Buenos_Aires", offset: -3.0))//     -03:00
        tzlist.append(_time_offset(timezone: "America/Cambridge_Bay", offset: -6.0))//     -06:00
        tzlist.append(_time_offset(timezone: "America/Campo_Grande", offset: -4.0))//     -04:00
        tzlist.append(_time_offset(timezone: "America/Cancun", offset: -5.0))//     -05:00
        tzlist.append(_time_offset(timezone: "America/Caracas", offset: -4.0))//     -04:00
        tzlist.append(_time_offset(timezone: "America/Catamarca", offset: -3.0))//     -03:00
        tzlist.append(_time_offset(timezone: "America/Cayenne", offset: -3.0))//     -03:00
        tzlist.append(_time_offset(timezone: "America/Cayman", offset: -5.0))//     -05:00
        tzlist.append(_time_offset(timezone: "America/Chicago", offset: -5.0))//     -05:00
        tzlist.append(_time_offset(timezone: "America/Chihuahua", offset: -6.0))//     -06:00
        tzlist.append(_time_offset(timezone: "America/Coral_Harbour", offset: -5.0))//     -05:00
        tzlist.append(_time_offset(timezone: "America/Cordoba", offset: -3.0))//     -03:00
        tzlist.append(_time_offset(timezone: "America/Costa_Rica", offset: -6.0))//     -06:00
        tzlist.append(_time_offset(timezone: "America/Creston", offset: -7.0))//     -07:00
        tzlist.append(_time_offset(timezone: "America/Cuiaba", offset: -4.0))//     -04:00
        tzlist.append(_time_offset(timezone: "America/Curacao", offset: -4.0))//     -04:00
        tzlist.append(_time_offset(timezone: "America/Danmarkshavn", offset: 0.0))//          Z
        tzlist.append(_time_offset(timezone: "America/Dawson", offset: -7.0))//     -07:00
        tzlist.append(_time_offset(timezone: "America/Dawson_Creek", offset: -7.0))//     -07:00
        tzlist.append(_time_offset(timezone: "America/Denver", offset: -6.0))//     -06:00
        tzlist.append(_time_offset(timezone: "America/Detroit", offset: -4.0))//     -04:00
        tzlist.append(_time_offset(timezone: "America/Dominica", offset: -4.0))//     -04:00
        tzlist.append(_time_offset(timezone: "America/Edmonton", offset: -6.0))//     -06:00
        tzlist.append(_time_offset(timezone: "America/Eirunepe", offset: -5.0))//     -05:00
        tzlist.append(_time_offset(timezone: "America/El_Salvador", offset: -6.0))//     -06:00
        tzlist.append(_time_offset(timezone: "America/Ensenada", offset: -7.0))//     -07:00
        tzlist.append(_time_offset(timezone: "America/Fort_Nelson", offset: -7.0))//     -07:00
        tzlist.append(_time_offset(timezone: "America/Fort_Wayne", offset: -4.0))//     -04:00
        tzlist.append(_time_offset(timezone: "America/Fortaleza", offset: -3.0))//     -03:00
        tzlist.append(_time_offset(timezone: "America/Glace_Bay", offset: -3.0))//     -03:00
        tzlist.append(_time_offset(timezone: "America/Godthab", offset: -2.0))//     -02:00
        tzlist.append(_time_offset(timezone: "America/Goose_Bay", offset: -3.0))//     -03:00
        tzlist.append(_time_offset(timezone: "America/Grand_Turk", offset: -4.0))//     -04:00
        tzlist.append(_time_offset(timezone: "America/Grenada", offset: -4.0))//     -04:00
        tzlist.append(_time_offset(timezone: "America/Guadeloupe", offset: -4.0))//     -04:00
        tzlist.append(_time_offset(timezone: "America/Guatemala", offset: -6.0))//     -06:00
        tzlist.append(_time_offset(timezone: "America/Guayaquil", offset: -5.0))//     -05:00
        tzlist.append(_time_offset(timezone: "America/Guyana", offset: -4.0))//     -04:00
        tzlist.append(_time_offset(timezone: "America/Halifax", offset: -3.0))//     -03:00
        tzlist.append(_time_offset(timezone: "America/Havana", offset: -4.0))//     -04:00
        tzlist.append(_time_offset(timezone: "America/Hermosillo", offset: -7.0))//     -07:00
        tzlist.append(_time_offset(timezone: "America/Indiana/Indianapolis", offset: -4.0))//     -04:00
        tzlist.append(_time_offset(timezone: "America/Indiana/Knox", offset: -5.0))//     -05:00
        tzlist.append(_time_offset(timezone: "America/Indiana/Marengo", offset: -4.0))//     -04:00
        tzlist.append(_time_offset(timezone: "America/Indiana/Petersburg", offset: -4.0))//     -04:00
        tzlist.append(_time_offset(timezone: "America/Indiana/Tell_City", offset: -5.0))//     -05:00
        tzlist.append(_time_offset(timezone: "America/Indiana/Vevay", offset: -4.0))//     -04:00
        tzlist.append(_time_offset(timezone: "America/Indiana/Vincennes", offset: -4.0))//     -04:00
        tzlist.append(_time_offset(timezone: "America/Indiana/Winamac", offset: -4.0))//     -04:00
        tzlist.append(_time_offset(timezone: "America/Indianapolis", offset: -4.0))//     -04:00
        tzlist.append(_time_offset(timezone: "America/Inuvik", offset: -6.0))//     -06:00
        tzlist.append(_time_offset(timezone: "America/Iqaluit", offset: -4.0))//     -04:00
        tzlist.append(_time_offset(timezone: "America/Jamaica", offset: -5.0))//     -05:00
        tzlist.append(_time_offset(timezone: "America/Jujuy", offset: -3.0))//     -03:00
        tzlist.append(_time_offset(timezone: "America/Juneau", offset: -8.0))//     -08:00
        tzlist.append(_time_offset(timezone: "America/Kentucky/Louisville", offset: -4.0))//     -04:00
        tzlist.append(_time_offset(timezone: "America/Kentucky/Monticello", offset: -4.0))//     -04:00
        tzlist.append(_time_offset(timezone: "America/Knox_IN", offset: -5.0))//     -05:00
        tzlist.append(_time_offset(timezone: "America/Kralendijk", offset: -4.0))//     -04:00
        tzlist.append(_time_offset(timezone: "America/La_Paz", offset: -4.0))//     -04:00
        tzlist.append(_time_offset(timezone: "America/Lima", offset: -5.0))//     -05:00
        tzlist.append(_time_offset(timezone: "America/Los_Angeles", offset: -7.0))//     -07:00
        tzlist.append(_time_offset(timezone: "America/Louisville", offset: -4.0))//     -04:00
        tzlist.append(_time_offset(timezone: "America/Lower_Princes", offset: -4.0))//     -04:00
        tzlist.append(_time_offset(timezone: "America/Maceio", offset: -3.0))//     -03:00
        tzlist.append(_time_offset(timezone: "America/Managua", offset: -6.0))//     -06:00
        tzlist.append(_time_offset(timezone: "America/Manaus", offset: -4.0))//     -04:00
        tzlist.append(_time_offset(timezone: "America/Marigot", offset: -4.0))//     -04:00
        tzlist.append(_time_offset(timezone: "America/Martinique", offset: -4.0))//     -04:00
        tzlist.append(_time_offset(timezone: "America/Matamoros", offset:-5.0))//     -05:00
        tzlist.append(_time_offset(timezone: "America/Mazatlan", offset: -6.0))//     -06:00
        tzlist.append(_time_offset(timezone: "America/Mendoza", offset: -3.0))//     -03:00
        tzlist.append(_time_offset(timezone: "America/Menominee", offset: -5.0))//     -05:00
        tzlist.append(_time_offset(timezone: "America/Merida", offset: -5.0))//     -05:00
        tzlist.append(_time_offset(timezone: "America/Metlakatla", offset: -8.0))//     -08:00
        tzlist.append(_time_offset(timezone: "America/Mexico_City", offset: -5.0))//     -05:00
        tzlist.append(_time_offset(timezone: "America/Miquelon", offset: -2.0))//     -02:00
        tzlist.append(_time_offset(timezone: "America/Moncton", offset: -3.0))//     -03:00
        tzlist.append(_time_offset(timezone: "America/Monterrey", offset: -5.0))//     -05:00
        tzlist.append(_time_offset(timezone: "America/Montevideo", offset: -3.0))//     -03:00
        tzlist.append(_time_offset(timezone: "America/Montreal", offset: -4.0))//     -04:00
        tzlist.append(_time_offset(timezone: "America/Montserrat", offset: -4.0))//     -04:00
        tzlist.append(_time_offset(timezone: "America/Nassau", offset: -4.0))//     -04:00
        tzlist.append(_time_offset(timezone: "America/New_York", offset: -4.0))//     -04:00
        tzlist.append(_time_offset(timezone: "America/Nipigon", offset: -4.0))//     -04:00
        tzlist.append(_time_offset(timezone: "America/Nome", offset: -8.0))//     -08:00
        tzlist.append(_time_offset(timezone: "America/Noronha", offset: -2.0))//     -02:00
        tzlist.append(_time_offset(timezone: "America/North_Dakota/Beulah", offset: -5.0))//     -05:00
        tzlist.append(_time_offset(timezone: "America/North_Dakota/Center", offset: -5.0))//     -05:00
        tzlist.append(_time_offset(timezone: "America/North_Dakota/New_Salem", offset: -5.0))//     -05:00
        tzlist.append(_time_offset(timezone: "America/Nuuk", offset: -2.0))//     -02:00
        tzlist.append(_time_offset(timezone: "America/Ojinaga", offset: -6.0))//     -06:00
        tzlist.append(_time_offset(timezone: "America/Panama", offset: -5.0))//     -05:00
        tzlist.append(_time_offset(timezone: "America/Pangnirtung", offset: -4.0))//     -04:00
        tzlist.append(_time_offset(timezone: "America/Paramaribo", offset: -3.0))//     -03:00
        tzlist.append(_time_offset(timezone: "America/Phoenix", offset: -7.0))//     -07:00
        tzlist.append(_time_offset(timezone: "America/Port-au-Prince", offset: -4.0))//     -04:00
        tzlist.append(_time_offset(timezone: "America/Port_of_Spain", offset: -4.0))//     -04:00
        tzlist.append(_time_offset(timezone: "America/Porto_Acre", offset: -5.0))//     -05:00
        tzlist.append(_time_offset(timezone: "America/Porto_Velho", offset: -4.0))//     -04:00
        tzlist.append(_time_offset(timezone: "America/Puerto_Rico", offset: 4.0))//     -04:00
        tzlist.append(_time_offset(timezone: "America/Punta_Arenas", offset: 3.0))//     -03:00
        tzlist.append(_time_offset(timezone: "America/Rainy_River", offset: -5.0))//     -05:00
        tzlist.append(_time_offset(timezone: "America/Rankin_Inlet", offset: -5.0))//     -05:00
        tzlist.append(_time_offset(timezone: "America/Recife", offset: -3.0))//     -03:00
        tzlist.append(_time_offset(timezone: "America/Regina", offset: -6.0))//     -06:00
        tzlist.append(_time_offset(timezone: "America/Resolute", offset: -5.0))//     -05:00
        tzlist.append(_time_offset(timezone: "America/Rio_Branco", offset: -5.0))//     -05:00
        tzlist.append(_time_offset(timezone: "America/Rosario", offset: -3.0))//     -03:00
        tzlist.append(_time_offset(timezone: "America/Santa_Isabel", offset: -7.0))//     -07:00
        tzlist.append(_time_offset(timezone: "America/Santarem", offset: -3.0))//     -03:00
        tzlist.append(_time_offset(timezone: "America/Santiago", offset: -3.0))//     -03:00
        tzlist.append(_time_offset(timezone: "America/Santo_Domingo", offset: -4.0))//     -04:00
        tzlist.append(_time_offset(timezone: "America/Sao_Paulo", offset: -3.0))//     -03:00
        tzlist.append(_time_offset(timezone: "America/Scoresbysund", offset: 0.0))//          Z
        tzlist.append(_time_offset(timezone: "America/Shiprock", offset: -6.0))//     -06:00
        tzlist.append(_time_offset(timezone: "America/Sitka", offset: -8.0))//     -08:00
        tzlist.append(_time_offset(timezone: "America/St_Barthelemy", offset: -4.0))//     -04:00
        tzlist.append(_time_offset(timezone: "America/St_Johns", offset: -2.5))//     -02:30
        tzlist.append(_time_offset(timezone: "America/St_Kitts", offset: -4.0))//     -04:00
        tzlist.append(_time_offset(timezone: "America/St_Lucia", offset: -4.0))//     -04:00
        tzlist.append(_time_offset(timezone: "America/St_Thomas", offset: -4.0))//     -04:00
        tzlist.append(_time_offset(timezone: "America/St_Vincent", offset: -4.0))//     -04:00
        tzlist.append(_time_offset(timezone: "America/Swift_Current", offset: -6.0))//     -06:00
        tzlist.append(_time_offset(timezone: "America/Tegucigalpa", offset: -6.0))//     -06:00
        tzlist.append(_time_offset(timezone: "America/Thule", offset: -3.0))//     -03:00
        tzlist.append(_time_offset(timezone: "America/Thunder_Bay", offset: -4.0))//     -04:00
        tzlist.append(_time_offset(timezone: "America/Tijuana", offset: -7.0))//     -07:00
        tzlist.append(_time_offset(timezone: "America/Toronto", offset: -4.0))//     -04:00
        tzlist.append(_time_offset(timezone: "America/Tortola", offset: -4.0))//     -04:00
        tzlist.append(_time_offset(timezone: "America/Vancouver", offset: -7.0))//     -07:00
        tzlist.append(_time_offset(timezone: "America/Virgin", offset: -4.0))//     -04:00
        tzlist.append(_time_offset(timezone: "America/Whitehorse", offset: -7.0))//     -07:00
        tzlist.append(_time_offset(timezone: "America/Winnipeg", offset: -5.0))//     -05:00
        tzlist.append(_time_offset(timezone: "America/Yakutat", offset: -8.0))//     -08:00
        tzlist.append(_time_offset(timezone: "America/Yellowknife", offset: -6.0))//     -06:00
        tzlist.append(_time_offset(timezone: "Antarctica/Casey", offset: 11.0))//     +11:00
        tzlist.append(_time_offset(timezone: "Antarctica/Davis", offset: 7.0))//     +07:00
        tzlist.append(_time_offset(timezone: "Antarctica/DumontDUrville", offset: 10.0))//     +10:00
        tzlist.append(_time_offset(timezone: "Antarctica/Macquarie", offset: 10.0))//     +10:00
        tzlist.append(_time_offset(timezone: "Antarctica/Mawson", offset: 5.0))//     +05:00
        tzlist.append(_time_offset(timezone: "Antarctica/McMurdo", offset: 12.0))//     +12:00
        tzlist.append(_time_offset(timezone: "Antarctica/Palmer", offset: -3.0))//     -03:00
        tzlist.append(_time_offset(timezone: "Antarctica/Rothera", offset: -3.0))//     -03:00
        tzlist.append(_time_offset(timezone: "Antarctica/South_Pole", offset: 12.0))//     +12:00
        tzlist.append(_time_offset(timezone: "Antarctica/Syowa", offset: 3.0))//     +03:00
        tzlist.append(_time_offset(timezone: "Antarctica/Troll", offset: 2.0))//     +02:00
        tzlist.append(_time_offset(timezone: "Antarctica/Vostok", offset: 6.0))//     +06:00
        tzlist.append(_time_offset(timezone: "Arctic/Longyearbyen", offset: 2.0))//     +02:00
        tzlist.append(_time_offset(timezone: "Asia/Aden", offset: 3.0))//     +03:00
        tzlist.append(_time_offset(timezone: "Asia/Almaty", offset: 6.0))//     +06:00
        tzlist.append(_time_offset(timezone: "Asia/Amman", offset: 3.0))//     +03:00
        tzlist.append(_time_offset(timezone: "Asia/Anadyr", offset: 12.0))//     +12:00
        tzlist.append(_time_offset(timezone: "Asia/Aqtau", offset: 5.0))//     +05:00
        tzlist.append(_time_offset(timezone: "Asia/Aqtobe", offset: 5.0))//     +05:00
        tzlist.append(_time_offset(timezone: "Asia/Ashgabat", offset: 5.0))//     +05:00
        tzlist.append(_time_offset(timezone: "Asia/Ashkhabad", offset: 5.0))//     +05:00
        tzlist.append(_time_offset(timezone: "Asia/Atyrau", offset: 5.0))//     +05:00
        tzlist.append(_time_offset(timezone: "Asia/Baghdad", offset: 3.0))//     +03:00
        tzlist.append(_time_offset(timezone: "Asia/Bahrain", offset: 3.0))//     +03:00
        tzlist.append(_time_offset(timezone: "Asia/Baku", offset: 4.0))//     +04:00
        tzlist.append(_time_offset(timezone: "Asia/Bangkok", offset: 7.0))//     +07:00
        tzlist.append(_time_offset(timezone: "Asia/Barnaul", offset: 7.0))//     +07:00
        tzlist.append(_time_offset(timezone: "Asia/Beirut", offset: 3.0))//     +03:00
        tzlist.append(_time_offset(timezone: "Asia/Bishkek", offset: 6.0))//     +06:00
        tzlist.append(_time_offset(timezone: "Asia/Brunei", offset: 8.0))//     +08:00
        tzlist.append(_time_offset(timezone: "Asia/Calcutta", offset: 5.5))//     +05:30
        tzlist.append(_time_offset(timezone: "Asia/Chita", offset: 9.0))//     +09:00
        tzlist.append(_time_offset(timezone: "Asia/Choibalsan", offset: 8.0))//     +08:00
        tzlist.append(_time_offset(timezone: "Asia/Chongqing", offset: 8.0))//     +08:00
        tzlist.append(_time_offset(timezone: "Asia/Chungking", offset: 8.0))//     +08:00
        tzlist.append(_time_offset(timezone: "Asia/Colombo", offset: 5.5))//     +05:30
        tzlist.append(_time_offset(timezone: "Asia/Dacca", offset: 6.0))//     +06:00
        tzlist.append(_time_offset(timezone: "Asia/Damascus", offset: 3.0))//     +03:00
        tzlist.append(_time_offset(timezone: "Asia/Dhaka", offset: 6.0))//     +06:00
        tzlist.append(_time_offset(timezone: "Asia/Dili", offset: 9.0))//     +09:00
        tzlist.append(_time_offset(timezone: "Asia/Dubai", offset: 4.0))//     +04:00
        tzlist.append(_time_offset(timezone: "Asia/Dushanbe", offset: 5.0))//     +05:00
        tzlist.append(_time_offset(timezone: "Asia/Famagusta", offset: 3.0))//     +03:00
        tzlist.append(_time_offset(timezone: "Asia/Gaza", offset: 3.0))//     +03:00
        tzlist.append(_time_offset(timezone: "Asia/Harbin", offset: 8.0))//     +08:00
        tzlist.append(_time_offset(timezone: "Asia/Hebron", offset: 3.0))//     +03:00
        tzlist.append(_time_offset(timezone: "Asia/Ho_Chi_Minh", offset: 7.0))//     +07:00
        tzlist.append(_time_offset(timezone: "Asia/Hong_Kong", offset: 8.0))//     +08:00
        tzlist.append(_time_offset(timezone: "Asia/Hovd", offset: 7.0))//     +07:00
        tzlist.append(_time_offset(timezone: "Asia/Irkutsk", offset: 8.0))//     +08:00
        tzlist.append(_time_offset(timezone: "Asia/Istanbul", offset: 3.0))//     +03:00
        tzlist.append(_time_offset(timezone: "Asia/Jakarta", offset: 7.0))//     +07:00
        tzlist.append(_time_offset(timezone: "Asia/Jayapura", offset: 9.0))//     +09:00
        tzlist.append(_time_offset(timezone: "Asia/Jerusalem", offset: 3.0))//     +03:00
        tzlist.append(_time_offset(timezone: "Asia/Kabul", offset: 4.5))//     +04:30
        tzlist.append(_time_offset(timezone: "Asia/Kamchatka", offset: 12.0))//     +12:00
        tzlist.append(_time_offset(timezone: "Asia/Karachi", offset: 5.0))//     +05:00
        tzlist.append(_time_offset(timezone: "Asia/Kashgar", offset: 6.0))//     +06:00
        tzlist.append(_time_offset(timezone: "Asia/Kathmandu", offset: 5.75))//     +05:45
        tzlist.append(_time_offset(timezone: "Asia/Katmandu", offset: 5.75))//     +05:45
        tzlist.append(_time_offset(timezone: "Asia/Khandyga", offset: 9.0))//     +09:00
        tzlist.append(_time_offset(timezone: "Asia/Kolkata", offset: 5.3))//     +05:30
        tzlist.append(_time_offset(timezone: "Asia/Krasnoyarsk", offset: 7.0))//     +07:00
        tzlist.append(_time_offset(timezone: "Asia/Kuala_Lumpur", offset: 8.0))//     +08:00
        tzlist.append(_time_offset(timezone: "Asia/Kuching", offset: 8.0))//     +08:00
        tzlist.append(_time_offset(timezone: "Asia/Kuwait", offset: 3.0))//     +03:00
        tzlist.append(_time_offset(timezone: "Asia/Macao", offset: 8.0))//     +08:00
        tzlist.append(_time_offset(timezone: "Asia/Macau", offset: 8.0))//     +08:00
        tzlist.append(_time_offset(timezone: "Asia/Magadan", offset: 11.0))//     +11:00
        tzlist.append(_time_offset(timezone: "Asia/Makassar", offset: 8.0))//     +08:00
        tzlist.append(_time_offset(timezone: "Asia/Manila", offset: 8.0))//     +08:00
        tzlist.append(_time_offset(timezone: "Asia/Muscat", offset: 4.0))//     +04:00
        tzlist.append(_time_offset(timezone: "Asia/Nicosia", offset: 3.0))//     +03:00
        tzlist.append(_time_offset(timezone: "Asia/Novokuznetsk", offset: 7.0))//     +07:00
        tzlist.append(_time_offset(timezone: "Asia/Novosibirsk", offset: 7.0))//     +07:00
        tzlist.append(_time_offset(timezone: "Asia/Omsk", offset: 6.0))//     +06:00
        tzlist.append(_time_offset(timezone: "Asia/Oral", offset: 5.0))//     +05:00
        tzlist.append(_time_offset(timezone: "Asia/Phnom_Penh", offset: 7.0))//     +07:00
        tzlist.append(_time_offset(timezone: "Asia/Pontianak", offset: 7.0))//     +07:00
        tzlist.append(_time_offset(timezone: "Asia/Pyongyang", offset: 9.0))//     +09:00
        tzlist.append(_time_offset(timezone: "Asia/Qatar", offset: 3.0))//     +03:00
        tzlist.append(_time_offset(timezone: "Asia/Qostanay", offset: 6.0))//     +06:00
        tzlist.append(_time_offset(timezone: "Asia/Qyzylorda", offset: 5.0))//     +05:00
        tzlist.append(_time_offset(timezone: "Asia/Rangoon", offset: 6.5))//     +06:30
        tzlist.append(_time_offset(timezone: "Asia/Riyadh", offset: 3.0))//     +03:00
        tzlist.append(_time_offset(timezone: "Asia/Saigon", offset: 7.0))//     +07:00
        tzlist.append(_time_offset(timezone: "Asia/Sakhalin", offset: 11.0))//     +11:00
        tzlist.append(_time_offset(timezone: "Asia/Samarkand", offset: 5.0))//     +05:00
        tzlist.append(_time_offset(timezone: "Asia/Seoul", offset: 9.0))//     +09:00
        tzlist.append(_time_offset(timezone: "Asia/Shanghai", offset: 8.0))//     +08:00
        tzlist.append(_time_offset(timezone: "Asia/Singapore", offset: 8.0))//     +08:00
        tzlist.append(_time_offset(timezone: "Asia/Srednekolymsk", offset: 11.0))//     +11:00
        tzlist.append(_time_offset(timezone: "Asia/Taipei", offset: 8.0))//     +08:00
        tzlist.append(_time_offset(timezone: "Asia/Tashkent", offset: 5.0))//     +05:00
        tzlist.append(_time_offset(timezone: "Asia/Tbilisi", offset: 4.0))//     +04:00
        tzlist.append(_time_offset(timezone: "Asia/Tehran", offset: 3.5))//     +03:30
        tzlist.append(_time_offset(timezone: "Asia/Tel_Aviv", offset: 3.0))//     +03:00
        tzlist.append(_time_offset(timezone: "Asia/Thimbu", offset: 6.0))//     +06:00
        tzlist.append(_time_offset(timezone: "Asia/Thimphu", offset: 6.0))//     +06:00
        tzlist.append(_time_offset(timezone: "Asia/Tokyo", offset: 9.0))//     +09:00
        tzlist.append(_time_offset(timezone: "Asia/Tomsk", offset: 7.0))//     +07:00
        tzlist.append(_time_offset(timezone: "Asia/Ujung_Pandang", offset: 8.0))//     +08:00
        tzlist.append(_time_offset(timezone: "Asia/Ulaanbaatar", offset: 8.0))//     +08:00
        tzlist.append(_time_offset(timezone: "Asia/Ulan_Bator", offset: 8.0))//     +08:00
        tzlist.append(_time_offset(timezone: "Asia/Urumqi", offset: 6.0))//     +06:00
        tzlist.append(_time_offset(timezone: "Asia/Ust-Nera", offset: 10.0))//     +10:00
        tzlist.append(_time_offset(timezone: "Asia/Vientiane", offset: 7.0))//     +07:00
        tzlist.append(_time_offset(timezone: "Asia/Vladivostok", offset: 10.0))//     +10:00
        tzlist.append(_time_offset(timezone: "Asia/Yakutsk", offset: 9.0))//     +09:00
        tzlist.append(_time_offset(timezone: "Asia/Yangon", offset: 6.5))//     +06:30
        tzlist.append(_time_offset(timezone: "Asia/Yekaterinburg", offset: 5.0))//     +05:00
        tzlist.append(_time_offset(timezone: "Asia/Yerevan", offset: 4.0))//     +04:00
        tzlist.append(_time_offset(timezone: "Atlantic/Azores", offset: 0.0))//          Z
        tzlist.append(_time_offset(timezone: "Atlantic/Bermuda", offset: -3.0))//     -03:00
        tzlist.append(_time_offset(timezone: "Atlantic/Canary", offset: 1.0))//     +01:00
        tzlist.append(_time_offset(timezone: "Atlantic/Cape_Verde", offset: -1.0))//     -01:00
        tzlist.append(_time_offset(timezone: "Atlantic/Faeroe", offset: 1.0))//     +01:00
        tzlist.append(_time_offset(timezone: "Atlantic/Faroe", offset: 1.0))//     +01:00
        tzlist.append(_time_offset(timezone: "Atlantic/Jan_Mayen", offset: 2.0))//     +02:00
        tzlist.append(_time_offset(timezone: "Atlantic/Madeira", offset: 1.0))//     +01:00
        tzlist.append(_time_offset(timezone: "Atlantic/Reykjavik", offset: 0.0))//          Z
        tzlist.append(_time_offset(timezone: "Atlantic/South_Georgia", offset: -2.0))//     -02:00
        tzlist.append(_time_offset(timezone: "Atlantic/St_Helena", offset: 0.0))//          Z
        tzlist.append(_time_offset(timezone: "Atlantic/Stanley", offset: -3.0))//     -03:00
        tzlist.append(_time_offset(timezone: "Australia/ACT", offset: 10.0))//     +10:00
        tzlist.append(_time_offset(timezone: "Australia/Adelaide", offset: 9.5))//     +09:30
        tzlist.append(_time_offset(timezone: "Australia/Brisbane", offset: 10.0))//     +10:00
        tzlist.append(_time_offset(timezone: "Australia/Broken_Hill", offset: 9.5))//     +09:30
        tzlist.append(_time_offset(timezone: "Australia/Canberra", offset: 10.0))//     +10:00
        tzlist.append(_time_offset(timezone: "Australia/Currie", offset: 10.0))//     +10:00
        tzlist.append(_time_offset(timezone: "Australia/Darwin", offset: 9.5))//     +09:30
        tzlist.append(_time_offset(timezone: "Australia/Eucla", offset: 8.75))//     +08:45
        tzlist.append(_time_offset(timezone: "Australia/Hobart", offset: 10.0))//     +10:00
        tzlist.append(_time_offset(timezone: "Australia/LHI", offset: 10.5))//     +10:30
        tzlist.append(_time_offset(timezone: "Australia/Lindeman", offset: 10.0))//     +10:00
        tzlist.append(_time_offset(timezone: "Australia/Lord_Howe", offset: 10.5))//     +10:30
        tzlist.append(_time_offset(timezone: "Australia/Melbourne", offset: 10.0))//     +10:00
        tzlist.append(_time_offset(timezone: "Australia/NSW", offset: 10.0))//     +10:00
        tzlist.append(_time_offset(timezone: "Australia/North", offset: 9.5))//     +09:30
        tzlist.append(_time_offset(timezone: "Australia/Perth", offset: 8.0))//     +08:00
        tzlist.append(_time_offset(timezone: "Australia/Queensland", offset: 10.0))//     +10:00
        tzlist.append(_time_offset(timezone: "Australia/South", offset: 9.5))//     +09:30
        tzlist.append(_time_offset(timezone: "Australia/Sydney", offset: 10.0))//     +10:00
        tzlist.append(_time_offset(timezone: "Australia/Tasmania", offset: 10.0))//     +10:00
        tzlist.append(_time_offset(timezone: "Australia/Victoria", offset: 10.0))//     +10:00
        tzlist.append(_time_offset(timezone: "Australia/West", offset: 8.0))//     +08:00
        tzlist.append(_time_offset(timezone: "Australia/Yancowinna", offset: 9.5))//     +09:30
        tzlist.append(_time_offset(timezone: "Brazil/Acre", offset: -5.0))//     -05:00
        tzlist.append(_time_offset(timezone: "Brazil/DeNoronha", offset: 2.0))//     -02:00
        tzlist.append(_time_offset(timezone: "Brazil/East", offset: -3.0))//     -03:00
        tzlist.append(_time_offset(timezone: "Brazil/West", offset: -4.0))//     -04:00
        tzlist.append(_time_offset(timezone: "Canada/Atlantic", offset: -3.0))//     -03:00
        tzlist.append(_time_offset(timezone: "Canada/Central", offset: -5.0))//     -05:00
        tzlist.append(_time_offset(timezone: "Canada/East-Saskatchewan", offset: -6.0))//     -06:00
        tzlist.append(_time_offset(timezone: "Canada/Eastern", offset: -4.0))//     -04:00
        tzlist.append(_time_offset(timezone: "Canada/Mountain", offset: -6.0))//     -06:00
        tzlist.append(_time_offset(timezone: "Canada/Newfoundland", offset: -2.5))//     -02:30
        tzlist.append(_time_offset(timezone: "Canada/Pacific", offset: -7.0))//     -07:00
        tzlist.append(_time_offset(timezone: "Canada/Saskatchewan", offset: -6.0))//     -06:00
        tzlist.append(_time_offset(timezone: "Canada/Yukon", offset: -7.0))//     -07:00
        tzlist.append(_time_offset(timezone: "Chile/Continental", offset: -3.0))//     -03:00
        tzlist.append(_time_offset(timezone: "Chile/EasterIsland", offset: -5.0))//     -05:00
        tzlist.append(_time_offset(timezone: "Cuba", offset: -4.0))//     -04:00
        tzlist.append(_time_offset(timezone: "Etc/Greenwich", offset: 0.0))//          Z
        tzlist.append(_time_offset(timezone: "Etc/Universal", offset: 0.0))//          Z
        tzlist.append(_time_offset(timezone: "Etc/Zulu", offset: 0.0))//          Z
        tzlist.append(_time_offset(timezone: "Europe/Amsterdam", offset: 2.0))//     +02:00
        tzlist.append(_time_offset(timezone: "Europe/Andorra", offset: 2.0))//     +02:00
        tzlist.append(_time_offset(timezone: "Europe/Astrakhan", offset: 4.0))//     +04:00
        tzlist.append(_time_offset(timezone: "Europe/Athens", offset: 3.0))//     +03:00
        tzlist.append(_time_offset(timezone: "Europe/Belfast", offset: 1.0))//     +01:00
        tzlist.append(_time_offset(timezone: "Europe/Belgrade", offset: 2.0))//     +02:00
        tzlist.append(_time_offset(timezone: "Europe/Berlin", offset: 2.0))//     +02:00
        tzlist.append(_time_offset(timezone: "Europe/Bratislava", offset: 2.0))//     +02:00
        tzlist.append(_time_offset(timezone: "Europe/Brussels", offset: 2.0))//     +02:00
        tzlist.append(_time_offset(timezone: "Europe/Bucharest", offset: 3.0))//     +03:00
        tzlist.append(_time_offset(timezone: "Europe/Budapest", offset: 2.0))//     +02:00
        tzlist.append(_time_offset(timezone: "Europe/Busingen", offset: 2.0))//     +02:00
        tzlist.append(_time_offset(timezone: "Europe/Chisinau", offset: 3.0))//     +03:00
        tzlist.append(_time_offset(timezone: "Europe/Copenhagen", offset: 2.0))//     +02:00
        tzlist.append(_time_offset(timezone: "Europe/Dublin", offset: 1.0))//     +01:00
        tzlist.append(_time_offset(timezone: "Europe/Gibraltar", offset: 2.0))//     +02:00
        tzlist.append(_time_offset(timezone: "Europe/Guernsey", offset: 1.0))//     +01:00
        tzlist.append(_time_offset(timezone: "Europe/Helsinki", offset: 3.0))//     +03:00
        tzlist.append(_time_offset(timezone: "Europe/Isle_of_Man", offset: 1.0))//     +01:00
        tzlist.append(_time_offset(timezone: "Europe/Istanbul", offset: 3.0))//     +03:00
        tzlist.append(_time_offset(timezone: "Europe/Jersey", offset: 1.0))//     +01:00
        tzlist.append(_time_offset(timezone: "Europe/Kaliningrad", offset: 2.0))//     +02:00
        tzlist.append(_time_offset(timezone: "Europe/Kiev", offset: 3.0))//     +03:00
        tzlist.append(_time_offset(timezone: "Europe/Kirov", offset: 2.0))//     +03:00
        tzlist.append(_time_offset(timezone: "Europe/Lisbon", offset: 1.0))//     +01:00
        tzlist.append(_time_offset(timezone: "Europe/Ljubljana", offset: 2.0))//     +02:00
        tzlist.append(_time_offset(timezone: "Europe/London", offset: 1.0))//     +01:00
        tzlist.append(_time_offset(timezone: "Europe/Luxembourg", offset: 2.0))//     +02:00
        tzlist.append(_time_offset(timezone: "Europe/Madrid", offset: 2.0))//     +02:00
        tzlist.append(_time_offset(timezone: "Europe/Malta", offset: 2.0))//     +02:00
        tzlist.append(_time_offset(timezone: "Europe/Mariehamn", offset: 3.0))//     +03:00
        tzlist.append(_time_offset(timezone: "Europe/Minsk", offset: 3.0))//     +03:00
        tzlist.append(_time_offset(timezone: "Europe/Monaco", offset: 2.0))//     +02:00
        tzlist.append(_time_offset(timezone: "Europe/Moscow", offset: 3.0))//     +03:00
        tzlist.append(_time_offset(timezone: "Europe/Nicosia", offset: 3.0))//     +03:00
        tzlist.append(_time_offset(timezone: "Europe/Oslo", offset: 2.0))//     +02:00
        tzlist.append(_time_offset(timezone: "Europe/Paris", offset: 2.0))//     +02:00
        tzlist.append(_time_offset(timezone: "Europe/Podgorica", offset: 2.0))//     +02:00
        tzlist.append(_time_offset(timezone: "Europe/Prague", offset: 2.0))//     +02:00
        tzlist.append(_time_offset(timezone: "Europe/Riga", offset: 3.0))//     +03:00
        tzlist.append(_time_offset(timezone: "Europe/Rome", offset: 2.0))//     +02:00
        tzlist.append(_time_offset(timezone: "Europe/Samara", offset: 4.0))//     +04:00
        tzlist.append(_time_offset(timezone: "Europe/San_Marino", offset: 2.0))//     +02:00
        tzlist.append(_time_offset(timezone: "Europe/Sarajevo", offset: 2.0))//     +02:00
        tzlist.append(_time_offset(timezone: "Europe/Saratov", offset: 4.0))//     +04:00
        tzlist.append(_time_offset(timezone: "Europe/Simferopol", offset: 3.0))//     +03:00
        tzlist.append(_time_offset(timezone: "Europe/Skopje", offset: 2.0))//     +02:00
        tzlist.append(_time_offset(timezone: "Europe/Sofia", offset: 3.0))//     +03:00
        tzlist.append(_time_offset(timezone: "Europe/Stockholm", offset: 2.0))//     +02:00
        tzlist.append(_time_offset(timezone: "Europe/Tallinn", offset: 3.0))//     +03:00
        tzlist.append(_time_offset(timezone: "Europe/Tirane", offset: 2.0))//     +02:00
        tzlist.append(_time_offset(timezone: "Europe/Tiraspol", offset: 3.0))//     +03:00
        tzlist.append(_time_offset(timezone: "Europe/Ulyanovsk", offset: 4.0))//     +04:00
        tzlist.append(_time_offset(timezone: "Europe/Uzhgorod", offset: 3.0))//     +03:00
        tzlist.append(_time_offset(timezone: "Europe/Vaduz", offset: 2.0))//     +02:00
        tzlist.append(_time_offset(timezone: "Europe/Vatican", offset: 2.0))//     +02:00
        tzlist.append(_time_offset(timezone: "Europe/Vienna", offset: 2.0))//     +02:00
        tzlist.append(_time_offset(timezone: "Europe/Vilnius", offset: 3.0))//     +03:00
        tzlist.append(_time_offset(timezone: "Europe/Volgograd", offset: 3.0))//     +03:00
        tzlist.append(_time_offset(timezone: "Europe/Warsaw", offset: 2.0))//     +02:00
        tzlist.append(_time_offset(timezone: "Europe/Zagreb", offset: 2.0))//     +02:00
        tzlist.append(_time_offset(timezone: "Europe/Zaporozhye", offset: 3.0))//     +03:00
        tzlist.append(_time_offset(timezone: "Europe/Zurich", offset: 2.0))//     +02:00
        tzlist.append(_time_offset(timezone: "Hongkong", offset: 8.0))//     +08:00
        tzlist.append(_time_offset(timezone: "Iceland", offset: 0.0))//
        tzlist.append(_time_offset(timezone: "Indian/Antananarivo", offset: 3.0))//     +03:00
        tzlist.append(_time_offset(timezone: "Indian/Chagos", offset: 6.0))//     +06:00
        tzlist.append(_time_offset(timezone: "Indian/Christmas", offset: 7.0))//     +07:00
        tzlist.append(_time_offset(timezone: "Indian/Cocos", offset: 6.5))//     +06:30
        tzlist.append(_time_offset(timezone: "Indian/Comoro", offset: 3.0))//     +03:00
        tzlist.append(_time_offset(timezone: "Indian/Kerguelen", offset: 5.0))//     +05:00
        tzlist.append(_time_offset(timezone: "Indian/Mahe", offset: 4.0))//     +04:00
        tzlist.append(_time_offset(timezone: "Indian/Maldives", offset: 5.0))//     +05:00
        tzlist.append(_time_offset(timezone: "Indian/Mauritius", offset: 4.0))//     +04:00
        tzlist.append(_time_offset(timezone: "Indian/Mayotte", offset: 3.0))//     +03:00
        tzlist.append(_time_offset(timezone: "Indian/Reunion", offset: 4.0))//     +04:00
        tzlist.append(_time_offset(timezone: "Iran", offset: 3.5))//     +03:30
        tzlist.append(_time_offset(timezone: "Israel", offset: 3.0))//     +03:00
        tzlist.append(_time_offset(timezone: "Jamaica", offset: -5.0))//     -05:00
        tzlist.append(_time_offset(timezone: "Japan", offset: 9.0))//     +09:00
        tzlist.append(_time_offset(timezone: "Kwajalein", offset: 12.0))//     +12:00
        tzlist.append(_time_offset(timezone: "Libya", offset: 2.0))//     +02:00
        tzlist.append(_time_offset(timezone: "Mexico/BajaNorte", offset: -7.0))//     -07:00
        tzlist.append(_time_offset(timezone: "Mexico/BajaSur", offset: -6.0))//     -06:00
        tzlist.append(_time_offset(timezone: "Mexico/General", offset: -5.0))//     -05:00
        tzlist.append(_time_offset(timezone: "NET", offset: 4.0))//     +04:00
        tzlist.append(_time_offset(timezone: "NST", offset: 12.0))//     +12:00
        tzlist.append(_time_offset(timezone: "NZ", offset: 12.0))//     +12:00
        tzlist.append(_time_offset(timezone: "NZ-CHAT", offset: 12.75))//     +12:45
        tzlist.append(_time_offset(timezone: "Navajo", offset: -6.0))//     -06:00
        tzlist.append(_time_offset(timezone: "Pacific/Apia", offset: 13.0))//     +13:00
        tzlist.append(_time_offset(timezone: "Pacific/Auckland", offset: 12.0))//     +12:00
        tzlist.append(_time_offset(timezone: "Pacific/Bougainville", offset: 11.0))//     +11:00
        tzlist.append(_time_offset(timezone: "Pacific/Chatham", offset: 12.75))//     +12:45
        tzlist.append(_time_offset(timezone: "Pacific/Chuuk", offset: 10.0))//     +10:00
        tzlist.append(_time_offset(timezone: "Pacific/Easter", offset: -5.0))//     -05:00
        tzlist.append(_time_offset(timezone: "Pacific/Efate", offset: 11.0))//     +11:00
        tzlist.append(_time_offset(timezone: "Pacific/Enderbury", offset: 13.0))//     +13:00
        tzlist.append(_time_offset(timezone: "Pacific/Fakaofo", offset: 13.0))//     +13:00
        tzlist.append(_time_offset(timezone: "Pacific/Fiji", offset: 12.0))//     +12:00
        tzlist.append(_time_offset(timezone: "Pacific/Funafuti", offset: 12.0))//     +12:00
        tzlist.append(_time_offset(timezone: "Pacific/Galapagos", offset: -6.0))//     -06:00
        tzlist.append(_time_offset(timezone: "Pacific/Gambier", offset: -9.0))//     -09:00
        tzlist.append(_time_offset(timezone: "Pacific/Guadalcanal", offset: 11.0))//     +11:00
        tzlist.append(_time_offset(timezone: "Pacific/Guam", offset: 10.0))//     +10:00
        tzlist.append(_time_offset(timezone: "Pacific/Honolulu", offset: -10.0))//     -10:00
        tzlist.append(_time_offset(timezone: "Pacific/Johnston", offset: -10.0))//     -10:00
        tzlist.append(_time_offset(timezone: "Pacific/Kiritimati", offset: 14.0))//     +14:00
        tzlist.append(_time_offset(timezone: "Pacific/Kosrae", offset: 11.0))//     +11:00
        tzlist.append(_time_offset(timezone: "Pacific/Kwajalein", offset: 12.0))//     +12:00
        tzlist.append(_time_offset(timezone: "Pacific/Majuro", offset: 12.0))//     +12:00
        tzlist.append(_time_offset(timezone: "Pacific/Marquesas", offset: -9.0))//     -09:30
        tzlist.append(_time_offset(timezone: "Pacific/Midway", offset: -11.0))//     -11:00
        tzlist.append(_time_offset(timezone: "Pacific/Nauru", offset: 12.0))//     +12:00
        tzlist.append(_time_offset(timezone: "Pacific/Niue", offset: -11.0))//     -11:00
        tzlist.append(_time_offset(timezone: "Pacific/Norfolk", offset: 11.0))//     +11:00
        tzlist.append(_time_offset(timezone: "Pacific/Noumea", offset: 11.0))//     +11:00
        tzlist.append(_time_offset(timezone: "Pacific/Pago_Pago", offset: -11.0))//     -11:00
        tzlist.append(_time_offset(timezone: "Pacific/Palau", offset: 9.0))//     +09:00
        tzlist.append(_time_offset(timezone: "Pacific/Pitcairn", offset: -8.0))//     -08:00
        tzlist.append(_time_offset(timezone: "Pacific/Pohnpei", offset: 11.0))//     +11:00
        tzlist.append(_time_offset(timezone: "Pacific/Ponape", offset: 11.0))//     +11:00
        tzlist.append(_time_offset(timezone: "Pacific/Port_Moresby", offset: 10.0))//     +10:00
        tzlist.append(_time_offset(timezone: "Pacific/Rarotonga", offset: -10.0))//     -10:00
        tzlist.append(_time_offset(timezone: "Pacific/Saipan", offset: 10.0))//     +10:00
        tzlist.append(_time_offset(timezone: "Pacific/Samoa", offset: -11.0))//     -11:00
        tzlist.append(_time_offset(timezone: "Pacific/Tahiti", offset: -10.0))//     -10:00
        tzlist.append(_time_offset(timezone: "Pacific/Tarawa", offset: 12.0))//     +12:00
        tzlist.append(_time_offset(timezone: "Pacific/Tongatapu", offset: 13.0))//     +13:00
        tzlist.append(_time_offset(timezone: "Pacific/Truk", offset: 10.0))//     +10:00
        tzlist.append(_time_offset(timezone: "Pacific/Wake", offset: 12.0))//     +12:00
        tzlist.append(_time_offset(timezone: "Pacific/Wallis", offset: 12.0))//     +12:00
        tzlist.append(_time_offset(timezone: "Pacific/Yap", offset: 10.0))//     +10:00
        tzlist.append(_time_offset(timezone: "Poland", offset: 2.0))//     +02:00
        tzlist.append(_time_offset(timezone: "Portugal", offset: 1.0))//     +01:00
        tzlist.append(_time_offset(timezone: "ROC", offset: 8.0))//     +08:00
        tzlist.append(_time_offset(timezone: "ROK", offset: 9.0))//     +09:00
        tzlist.append(_time_offset(timezone: "SST", offset: 11.0))//     +11:00
        tzlist.append(_time_offset(timezone: "Singapore", offset: 8.0))//     +08:00
        tzlist.append(_time_offset(timezone: "Turkey", offset: 3.0))//     +03:00
        tzlist.append(_time_offset(timezone: "UCT", offset: 0.0))//          Z
        tzlist.append(_time_offset(timezone: "US/Alaska", offset: -8.0))//     -08:00
        tzlist.append(_time_offset(timezone: "US/Aleutian", offset: -9.0))//     -09:00
        tzlist.append(_time_offset(timezone: "US/Arizona", offset: -7.0))//     -07:00
        tzlist.append(_time_offset(timezone: "US/Central", offset: -5.0))//     -05:00
        tzlist.append(_time_offset(timezone: "US/East-Indiana", offset: -4.0))//     -04:00
        tzlist.append(_time_offset(timezone: "US/Eastern", offset: -4.0))//     -04:00
        tzlist.append(_time_offset(timezone: "US/Hawaii", offset: -10.0))//     -10:00
        tzlist.append(_time_offset(timezone: "US/Indiana-Starke", offset: -5.0))//     -05:00
        tzlist.append(_time_offset(timezone: "US/Michigan", offset: -4.0))//     -04:00
        tzlist.append(_time_offset(timezone: "US/Mountain", offset: -6.0))//     -06:00
        tzlist.append(_time_offset(timezone: "US/Pacific", offset: -7.0))//     -07:00
        tzlist.append(_time_offset(timezone: "US/Pacific-New", offset: -7.0))//     -07:00
        tzlist.append(_time_offset(timezone: "US/Samoa", offset: -11.0))//     -11:00
        tzlist.append(_time_offset(timezone: "UTC", offset: 3.0))//
        tzlist.append(_time_offset(timezone: "Zulu", offset: 0.0))//          Z
    }

    public func getTimeZones()->Array<_time_offset> {
        return tzlist
    }
}
