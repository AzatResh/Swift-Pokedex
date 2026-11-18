struct Pokemon: Identifiable {
    let id: Int
    let name: String
}

struct PokemonDetail: Identifiable {
   let id: Int
   let name: String
   let baseExperience: Int?
   let weight: Int
   let height: Int
}

