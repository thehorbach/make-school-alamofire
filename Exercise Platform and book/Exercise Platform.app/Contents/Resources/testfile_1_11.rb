values_for :numberOfBoys, [20, 10, 0, 15, 1]
values_for :numberOfGirls, [60, 10, 15, 0, 2]

solution do |numberOfBoys, numberOfGirls|
    boyP = numberOfBoys * 100 / (numberOfBoys + numberOfGirls)
    girlP = numberOfGirls * 100 / (numberOfBoys + numberOfGirls)

    "#{boyP}\n#{girlP}"
end

