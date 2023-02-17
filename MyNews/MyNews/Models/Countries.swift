//
//  Countries.swift
//  MyNews
//
//  Created by Stas Boiko on 04.02.2023.
//

import Foundation

enum Country: String, CaseIterable {
    case none = "World"
    case argentina, australia, austria, belgium, brazil, bulgaria, canada, china, colombia, cuba, czechRepublic = "Czech Republic", egypt, france, germany, greece, hongKong = "Hong Kong", hungary, india, indonesia, ireland, israel, italy, japan, latvia, lithuania, malaysia, mexico, marocco, netherlands, newZeland = "New Zeland", nigeria, norway, philippines, poland, portugal, romania, russia, saudiArabia = "Saudi Arabia", serbia, singapore, slovakia, slovenia, southAfrica = "South Africa", southKorea = "South Korea", sweden, switzerland, taiwan, thailand, turkey, uae = "UAE", ukraine, unitedKingdom = "United Kingdom", usa = "USA", venezuela
    
    var countryId: String {
        switch self {
        case .none:
            return ""
        case .argentina:
            return "ar"
        case .australia:
            return "au"
        case .austria:
            return"at"
        case .belgium:
            return "be"
        case .brazil:
            return "br"
        case .bulgaria:
            return "bg"
        case .canada:
            return "ca"
        case .china:
            return "cn"
        case .colombia:
            return "co"
        case .cuba:
            return "cu"
        case .czechRepublic:
            return "cz"
        case .egypt:
            return "eg"
        case .france:
            return "fr"
        case .germany:
            return "de"
        case .greece:
            return "gr"
        case .hongKong:
            return "hk"
        case .hungary:
            return "hu"
        case .india:
            return "in"
        case .indonesia:
            return "id"
        case .ireland:
            return "ie"
        case .israel:
            return "il"
        case .italy:
            return "it"
        case .japan:
            return "jp"
        case .latvia:
            return "lv"
        case .lithuania:
            return "lt"
        case .malaysia:
            return "my"
        case .mexico:
            return "mx"
        case .marocco:
            return "ma"
        case .netherlands:
            return "nl"
        case .newZeland:
            return "nz"
        case .nigeria:
            return "ng"
        case .norway:
            return "no"
        case .philippines:
            return "ph"
        case .poland:
            return "pl"
        case .portugal:
            return "pt"
        case .romania:
            return "ro"
        case .russia:
            return "ru"
        case .saudiArabia:
            return "sa"
        case .serbia:
            return "rs"
        case .singapore:
            return "sg"
        case .slovakia:
            return "sk"
        case .slovenia:
            return "si"
        case .southAfrica:
            return "za"
        case .southKorea:
            return "kr"
        case .sweden:
            return "se"
        case .switzerland:
            return "ch"
        case .taiwan:
            return "tw"
        case .thailand:
            return "th"
        case .turkey:
            return "tr"
        case .uae:
            return "ae"
        case .ukraine:
            return "ua"
        case .unitedKingdom:
            return "uk"
        case .usa:
            return "us"
        case .venezuela:
            return "ve"
        }
    }
}
