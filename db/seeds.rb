small_cover_uploader = SmallCoverUploader.new
large_cover_uploader = LargeCoverUploader.new

Video.create(
  title: 'Friends',
  description: 'Friends is an American situation comedy about a group of friends living in the New York City borough of Manhattan. It was created by David Crane and Marta Kauffman, which premiered on NBC on September 22, 1994. The series was produced by Bright/Kauffman/Crane Productions, in association with Warner Bros. Television.',
  small_cover: Rails.root.join('public/uploads/friends.jpg').open,
  large_cover: Rails.root.join('public/uploads/friends_large.png').open,
  video_url: 'https://www.youtube.com/watch?v=Xs-HbHCcK58',
  category_id: 1
)
Video.create(
  title: 'Inception',
  description: 'The film stars Leonardo DiCaprio as a professional thief who steals information by infiltrating the subconscious, and is offered a chance to have his criminal history erased as payment for a seemingly impossible task: "inception", the implantation of another person\'s idea into a target\'s subconscious.',
  small_cover: Rails.root.join('public/uploads/inception.jpg').open,
  large_cover: Rails.root.join('public/uploads/inception_large.jpg').open,
  video_url: 'https://www.youtube.com/watch?v=YoHD9XEInc0',
  category_id: 2
)
Video.create(
  title: 'Gladiator',
  description: 'Maximus is a powerful Roman general, loved by the people and the aging Emperor, Marcus Aurelius. Before his death, the Emperor chooses Maximus to be his heir over his own son, Commodus, and a power struggle leaves Maximus and his family condemned to death.',
  small_cover: Rails.root.join('public/uploads/gladiator.jpg').open,
  large_cover: Rails.root.join('public/uploads/gladiator_large.jpg').open,
  video_url: 'https://www.youtube.com/watch?v=owK1qxDselE',
  category_id: 2
)
Video.create(
  title: 'Monk',
  description: 'Monk is an American comedy-drama detective mystery television series created by Andy Breckman and starring Tony Shalhoub as the eponymous character, Adrian Monk.',
  small_cover: Rails.root.join('public/uploads/monk.jpg').open,
  large_cover: Rails.root.join('public/uploads/monk_large.jpg').open,
  video_url: 'https://www.youtube.com/watch?v=L_IOsLYVKkY',
  category_id: 1
)
Video.create(
  title: 'Friends',
  description: 'Friends is an American situation comedy about a group of friends living in the New York City borough of Manhattan. It was created by David Crane and Marta Kauffman, which premiered on NBC on September 22, 1994. The series was produced by Bright/Kauffman/Crane Productions, in association with Warner Bros. Television.',
  small_cover: Rails.root.join('public/uploads/friends.jpg').open,
  large_cover: Rails.root.join('public/uploads/friends_large.png').open,
  video_url: 'https://www.youtube.com/watch?v=Xs-HbHCcK58',
  category_id: 1
)
Video.create(
  title: 'Inception',
  description: 'The film stars Leonardo DiCaprio as a professional thief who steals information by infiltrating the subconscious, and is offered a chance to have his criminal history erased as payment for a seemingly impossible task: "inception", the implantation of another person\'s idea into a target\'s subconscious.',
  small_cover: Rails.root.join('public/uploads/inception.jpg').open,
  large_cover: Rails.root.join('public/uploads/inception_large.jpg').open,
  video_url: 'https://www.youtube.com/watch?v=YoHD9XEInc0',
  category_id: 2
)
Video.create(
  title: 'Gladiator',
  description: 'Maximus is a powerful Roman general, loved by the people and the aging Emperor, Marcus Aurelius. Before his death, the Emperor chooses Maximus to be his heir over his own son, Commodus, and a power struggle leaves Maximus and his family condemned to death.',
  small_cover: Rails.root.join('public/uploads/gladiator.jpg').open,
  large_cover: Rails.root.join('public/uploads/gladiator_large.jpg').open,
  video_url: 'https://www.youtube.com/watch?v=owK1qxDselE',
  category_id: 2
)
Video.create(
  title: 'Monk',
  description: 'Monk is an American comedy-drama detective mystery television series created by Andy Breckman and starring Tony Shalhoub as the eponymous character, Adrian Monk.',
  small_cover: Rails.root.join('public/uploads/monk.jpg').open,
  large_cover: Rails.root.join('public/uploads/monk_large.jpg').open,
  video_url: 'https://www.youtube.com/watch?v=L_IOsLYVKkY',
  category_id: 1
)
Video.create(
  title: 'Friends',
  description: 'Friends is an American situation comedy about a group of friends living in the New York City borough of Manhattan. It was created by David Crane and Marta Kauffman, which premiered on NBC on September 22, 1994. The series was produced by Bright/Kauffman/Crane Productions, in association with Warner Bros. Television.',
  small_cover: Rails.root.join('public/uploads/friends.jpg').open,
  large_cover: Rails.root.join('public/uploads/friends_large.png').open,
  video_url: 'https://www.youtube.com/watch?v=Xs-HbHCcK58',
  category_id: 1
)
Video.create(
  title: 'Inception',
  description: 'The film stars Leonardo DiCaprio as a professional thief who steals information by infiltrating the subconscious, and is offered a chance to have his criminal history erased as payment for a seemingly impossible task: "inception", the implantation of another person\'s idea into a target\'s subconscious.',
  small_cover: Rails.root.join('public/uploads/inception.jpg').open,
  large_cover: Rails.root.join('public/uploads/inception_large.jpg').open,
  video_url: 'https://www.youtube.com/watch?v=YoHD9XEInc0',
  category_id: 2
)
Video.create(
  title: 'Gladiator',
  description: 'Maximus is a powerful Roman general, loved by the people and the aging Emperor, Marcus Aurelius. Before his death, the Emperor chooses Maximus to be his heir over his own son, Commodus, and a power struggle leaves Maximus and his family condemned to death.',
  small_cover: Rails.root.join('public/uploads/gladiator.jpg').open,
  large_cover: Rails.root.join('public/uploads/gladiator_large.jpg').open,
  video_url: 'https://www.youtube.com/watch?v=owK1qxDselE',
  category_id: 2
)
Video.create(
  title: 'Monk',
  description: 'Monk is an American comedy-drama detective mystery television series created by Andy Breckman and starring Tony Shalhoub as the eponymous character, Adrian Monk.',
  small_cover: Rails.root.join('public/uploads/monk.jpg').open,
  large_cover: Rails.root.join('public/uploads/monk_large.jpg').open,
  video_url: 'https://www.youtube.com/watch?v=L_IOsLYVKkY',
  category_id: 1
)
Video.create(
  title: 'Friends',
  description: 'Friends is an American situation comedy about a group of friends living in the New York City borough of Manhattan. It was created by David Crane and Marta Kauffman, which premiered on NBC on September 22, 1994. The series was produced by Bright/Kauffman/Crane Productions, in association with Warner Bros. Television.',
  small_cover: Rails.root.join('public/uploads/friends.jpg').open,
  large_cover: Rails.root.join('public/uploads/friends_large.png').open,
  video_url: 'https://www.youtube.com/watch?v=Xs-HbHCcK58',
  category_id: 1
)
Video.create(
  title: 'Inception',
  description: 'The film stars Leonardo DiCaprio as a professional thief who steals information by infiltrating the subconscious, and is offered a chance to have his criminal history erased as payment for a seemingly impossible task: "inception", the implantation of another person\'s idea into a target\'s subconscious.',
  small_cover: Rails.root.join('public/uploads/inception.jpg').open,
  large_cover: Rails.root.join('public/uploads/inception_large.jpg').open,
  video_url: 'https://www.youtube.com/watch?v=YoHD9XEInc0',
  category_id: 2
)
Video.create(
  title: 'Gladiator',
  description: 'Maximus is a powerful Roman general, loved by the people and the aging Emperor, Marcus Aurelius. Before his death, the Emperor chooses Maximus to be his heir over his own son, Commodus, and a power struggle leaves Maximus and his family condemned to death.',
  small_cover: Rails.root.join('public/uploads/gladiator.jpg').open,
  large_cover: Rails.root.join('public/uploads/gladiator_large.jpg').open,
  video_url: 'https://www.youtube.com/watch?v=owK1qxDselE',
  category_id: 2
)

Category.create(name: 'TV Comedies')
Category.create(name: 'Movies')

antoine = User.create(email: 'antoine@example.com', full_name: 'Antoine Leclercq', password: 'antoine')
example_user = User.create(email: 'email@example.com', full_name: 'Net Flix', password: 'password')
example_user = User.create(email: 'test@myflix.com', full_name: 'Firsty Lasty', password: 'password')
user1 = Fabricate(:user)
user2 = Fabricate(:user)

Review.create(rating: 4, body: 'This TV show is awesome!', video: Video.first, creator: User.first)
Review.create(rating: 5, body: 'I love this TV show!', video: Video.first, creator: User.second)

QueueItem.create(user: user1, video: Video.first)
QueueItem.create(user: user1, video: Video.second)
QueueItem.create(user: user2, video: Video.first)

Relationship.create(follower: antoine, leader: example_user)
Relationship.create(follower: antoine, leader: user1)
Relationship.create(follower: antoine, leader: user2)
Relationship.create(follower: user1, leader: antoine)
Relationship.create(follower: example_user, leader: antoine)
Relationship.create(follower: example_user, leader: user1)

