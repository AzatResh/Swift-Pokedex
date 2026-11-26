import SwiftUI
import SwiftData

struct FavoriteButton: View {
    let pokemon: Pokemon
    
    @Environment(\.modelContext) private var modelContext
    
    @Query private var favorites: [Pokemon]
    
    init(pokemon: Pokemon) {
        self.pokemon = pokemon
        
        let id = pokemon.id
        
        _favorites = Query(
            filter: #Predicate<Pokemon> {
                $0.id == id
            }
        )
    }
    
    
    private var isFavorite: Bool {
        !favorites.isEmpty
    }
    
    var body: some View {
        Button {
            toggleFavorite()
        } label: {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .foregroundStyle(isFavorite ? Color.red : Color.primary)
        }
        .accessibilityLabel(
            isFavorite
                ? "Удалить из избранного"
                : "Добавить в избранное"
        )
    }

    private func toggleFavorite() {
        
        if let favorite = favorites.first {
            modelContext.delete(favorite)
        } else {
            modelContext.insert(Pokemon(
                id: pokemon.id,
                name: pokemon.name
            )
            )
        }

        do {
            try modelContext.save()
        } catch {
            modelContext.rollback()
        }
    }
}
