puts "Inserting the breakfast pastry..."
Message.delete_all
Chatroom.delete_all
Lesson.delete_all
Unit.delete_all
Course.delete_all
User.delete_all

puts "...The secret government Eggo project..."
User.create!(email: ENV.fetch("AI_EMAIL"), username: "assistant",
  password: ENV.fetch("ADMIN_PASSWORD"),
  password_confirmation: ENV.fetch("ADMIN_PASSWORD"),
  class_code: ENV.fetch("ADMIN_CLASS_CODE"))

puts "...Contact Dr. Jemima ..."
User.create!(email: ENV.fetch("GMAIL_USERNAME"),
  username: ENV.fetch("ADMIN_USERNAME"), password: ENV.fetch("ADMIN_PASSWORD"),
  password_confirmation: ENV.fetch("ADMIN_PASSWORD"), admin: true,
  instructor: true, class_code: ENV.fetch("ADMIN_CLASS_CODE"))

User.create!(email: "teachmaster5000@teach.edu", username: "TeachMaster 5000",
  password: "I love to teach", instructor: true,
  class_code: loop { n = rand(1000..9999); break n unless n == ENV.fetch("ADMIN_CLASS_CODE") || n == ENV.fetch("INSTRUCTOR_CLASS_CODE") })

puts "...God I love the blueberry ones best..."
SystemMessage.create!(content: ENV.fetch("SYSTEM_MESSAGE"))
puts "...Start warming the syrup..."
Course.create!(name: "Global Environmental Issues", details: "This course explores critical environmental challenges facing the world today. Students will examine topics such as climate change, pollution, and sustainable development, focusing on global solutions and their local impacts. Through discussions, case studies, and projects, students will develop a better understanding of how to address environmental problems.", user: User.find_by(username: ENV.fetch("ADMIN_USERNAME")))
puts "...Yum..."
Unit.create!(name: "Unit 1: Climate Change and Its Impact", details: "This unit covers the science behind climate change, including causes, consequences, and mitigation strategies. Students will explore global warming, rising sea levels, and how climate change affects both ecosystems and human populations.", course: Course.find_by(name: "Global Environmental Issues"))
Lesson.create!(name: "Lesson 1: Understanding Climate Science", details: "Lecture Summary: The basics of climate science, focusing on the greenhouse effect, carbon emissions, and their role in global warming.
Class Activity: Students will analyze recent climate data and interpret graphs showing temperature changes over the past century.
Homework Assignment: Write a 500-word essay on how climate change has affected a specific country, focusing on rising temperatures or sea levels.", unit: Unit.find_by(name: "Unit 1: Climate Change and Its Impact"))
Lesson.create!(name: "Lesson 2: Mitigation and Adaptation Strategies", details: "Lecture Summary: Examination of strategies to reduce or cope with climate change impacts, including renewable energy, carbon taxes, and reforestation.
Class Activity: Group discussions on various mitigation strategies and how they can be applied in different countries.
Homework Assignment: Create a short presentation proposing a climate change mitigation plan for Japan.", unit: Unit.find_by(name: "Unit 1: Climate Change and Its Impact"))
Unit.create!(name: "Unit 2: Pollution and Public Health", details: "This unit delves into different forms of pollution, including air, water, and soil pollution, and their effects on human health. Students will learn about both global and local pollution challenges and explore policy responses.", course: Course.find_by(name: "Global Environmental Issues"))
Lesson.create!(name: "Lesson 1: Air Pollution and Its Effects on Health", details: "Lecture Summary: An overview of air pollution sources, such as factories and vehicles, and the harmful effects on respiratory and cardiovascular health.
Class Activity: Students will read case studies of cities dealing with severe air pollution and discuss possible solutions.
Homework Assignment: Research a Japanese city affected by air pollution and prepare a 2-page report on how the city is addressing the issue.", unit: Unit.find_by(name: "Unit 2: Pollution and Public Health"))
Lesson.create!(name: "Lesson 2: Water Pollution and Its Impact on Ecosystems", details: "Lecture Summary: Exploration of the causes and consequences of water pollution, focusing on industrial waste, oil spills, and agricultural runoff.
Class Activity: Simulation of a water contamination scenario, where students brainstorm solutions to clean up a polluted river.
Homework Assignment: Write a 300-word summary of a water pollution event in Japan, detailing its impact on local wildlife.", unit: Unit.find_by(name: "Unit 2: Pollution and Public Health"))

puts "... Increase the Flash Gordon noise and put more science stuff around."
Course.create!(name: "Cultural Communication in a Globalized World", details: "This course focuses on the role of cultural communication in the context of globalization. Students will learn about cross-cultural interactions, misunderstandings, and strategies for effective communication in international settings, both in personal and professional environments.", user: User.find_by(username: "TeachMaster 5000"))
Unit.create(name: "Unit 1: Understanding Cultural Differences", details: "In this unit, students will explore cultural dimensions such as individualism vs. collectivism, power distance, and uncertainty avoidance. Emphasis will be placed on how these cultural differences manifest in communication styles.", course: Course.find_by(name: "Cultural Communication in a Globalized World"))
Lesson.create(name: "Lesson 1: Theories of Cultural Dimensions", details: "Lecture Summary: Introduction to Hofstede's cultural dimensions theory, discussing key concepts like individualism vs. collectivism and high vs. low context communication.
Class Activity: Role-play exercise where students practice communicating in both high and low-context scenarios.
Homework Assignment: Compare Japanese and Western communication styles in a 500-word essay, using Hofstede’s dimensions as a framework.", unit: Unit.find_by(name: "Unit 1: Understanding Cultural Differences"))
Lesson.create(name: "Lesson 2: Miscommunication Across Cultures", details: "Lecture Summary: Focus on common cultural misunderstandings and the impact of non-verbal communication across different cultures.
Class Activity: Watch and analyze a video showcasing cross-cultural miscommunication, followed by group discussions on how it could have been avoided.
Homework Assignment: Identify a real-life example of cross-cultural miscommunication and describe the cultural factors that contributed to it.", unit: Unit.find_by(name: "Unit 1: Understanding Cultural Differences"))

puts "...Oh my god, my waffle!"
