import SwiftUI

struct PokemonDetailView: View {
  let pokemon: Pokemon

  var body: some View {
    VStack(spacing: 10) {
      Text(
        "#\(pokemon.id)."
      ).foregroundStyle(.secondary)

      Text(pokemon.name)
    }
    .navigationTitle("Детали")
    .navigationBarTitleDisplayMode(.inline)
  }
}
