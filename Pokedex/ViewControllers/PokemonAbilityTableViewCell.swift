//
//  PokemonAbilityTableViewCell.swift
//  Pokedex
//
//  Created by Austin Dobberfuhl on 4/29/24.
//

import UIKit

class PokemonAbilityTableViewCell: UITableViewCell {

    
    @IBOutlet weak var abilityNameLabel: UILabel!
    @IBOutlet weak var effectDescriptionLabel: UILabel!
    @IBOutlet weak var flavorTextLabel: UILabel!
    
    
    func setup() {
        abilityNameLabel.text = "Mirror Shield"
        effectDescriptionLabel.text = "The msioafiualesu fhshiofh esyau fbousrbfefb oaisefb uasbf saubfsuaoefb oyasfbrhgsei ygb eailrubfr kagrajkbf akjsrfb sefjhb aseligb eawkjgb erajgb eig biweafh eaksfuh askelfh ilefh ewiaoyfg aweifg eroyufg afiulh wago erng elrb arvihar uierabf iarhf eiuoarfb aeifgn"
        flavorTextLabel.text = "alfhilusilg yhao lgeih ou;h;aeyf;owae f;aewfo ;h;gufharguhaerigha hofasfojf hwef jawuipgfh awpief hwaofghsaef osefjp wpeoufghaiwe gosaiejfkasepnfi asha ejfaewfawiefu how jskfuh isapfh aoefij iaupgwaepigfh eg hipweh fwaefo hweipauf haef weifpu hawipf hwepo h"
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
