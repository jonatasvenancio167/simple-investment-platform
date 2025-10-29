puts "Criando usuários..."
users = User.create!([
  { name: "Alice", email: "alice@example.com" },
  { name: "Bruno", email: "bruno@example.com" },
  { name: "Carla", email: "carla@example.com" }
])

puts "Criando ofertas..."
fundraises = Fundraise.create!([
  {
    title: "oferta 1",
    description: "Primeira oferta de teste",
    target_cents: 100_000,
    status: "open",
    starts_at: Time.current,
    ends_at: 30.days.from_now
  },
  {
    title: "oferta 2",
    description: "Segunda oferta de teste",
    target_cents: 200_000,
    status: "open",
    starts_at: Time.current,
    ends_at: 60.days.from_now
  },
  {
    title: "oferta 3",
    description: "oferta já encerrada",
    target_cents: 150_000,
    status: "closed",
    starts_at: 60.days.ago,
    ends_at: 30.days.ago
  }
])

puts "Criando investimentos..."
open_offers = Fundraise.where(status: "open")
Investment.create!([
  { user: users[0], fundraise: open_offers[0], amount_cents: 10_000 },
  { user: users[1], fundraise: open_offers[0], amount_cents: 25_000 },
  { user: users[2], fundraise: open_offers[1], amount_cents: 50_000 },
  { user: users[0], fundraise: open_offers[1], amount_cents: 5_000 },
  { user: users[1], fundraise: open_offers[1], amount_cents: 12_500 }
])

puts "Seeds criados com sucesso!"
