# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

at1 = ArtifactType.create(name: 'Use Case')
at2 = ArtifactType.create(name: 'Test Case')
at3 = ArtifactType.create(name: 'Prototype Espec')

Artifact.create(code: 'UC0001', name: 'Delete Post', artifact_type_id: at1.id)
Artifact.create(code: 'PE0001', name: 'Delete Post View', artifact_type_id: at3.id)
Artifact.create(code: 'TC0001', name: 'Delete Post', artifact_type_id: at2.id)

r1 = RelationshipType.create(name: 'Implementes')
r2 = RelationshipType.create(name: 'Implmented by')
