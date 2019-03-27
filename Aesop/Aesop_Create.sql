-----------------------------------------------------------
-- Aesop's Fables Sample Database
-- For Searching Full-Text Indexes

-----------------------------------------------------------
-----------------------------------------------------------
USE Master
IF EXISTS (SELECT * FROM SysDatabases WHERE NAME='Aesop')
		DROP DATABASE Aesop
go
CREATE DATABASE Aesop
go
USE Aesop

CREATE TABLE Fable (
  FableID INT NOT NULL CONSTRAINT FablePK PRIMARY KEY NONCLUSTERED,
  Title VARCHAR(50) NOT NULL,
  Moral VARCHAR(100) NOT NULL,
  FableText VARCHAR(1536) NOT NULL
  )
go

SET NOCOUNT ON

INSERT Fable(FableID, Title, Moral, FableText)
  VALUES (1, 'The Ants and the Grasshopper','It is thrifty to prepare today for the wants of tomorrow.', 'The ants were spending a fine winter''s day drying grain collected in the summertime.  A Grasshopper, perishing with famine, passed by and earnestly begged for a little food.  The Ants inquired of him, "Why did you not treasure up food during the summer?"  He replied, "I had not leisure enough.  I passed the days in singing."  They then said in derision:  "If you were foolish enough to sing all the summer, you must dance supperless to bed in the winter.')
INSERT Fable(FableID, Title, Moral, FableText)
  VALUES (2, 'The Bald Knight', 'Thy pride is but the prologue of thy shame.', 'A bald knight, who wore a wig, went out to hunt.  A sudden puff of wind blew off his hat and wig, at which a loud laugh rang forth from his companions.  He pulled up his horse, and with great glee joined in the joke by saying, "What a marvel it is that hairs which are not mine should fly from me, when they have forsaken even the man on whose head they grew."')
INSERT Fable(FableID, Title, Moral, FableText)
  VALUES (3, 'Androcles', 'Gratitude is the sign of noble souls.', 'A slave named Androcles once escaped from his master and fled to the forest.  As he was wandering about there he came upon a Lion lying down moaning and groaning.  At first he turned to flee, but finding that the Lion did not pursue him, he turned back and went up to him.  As he came near, the Lion put out his paw, which was all swollen and bleeding, and Androcles found that a huge thorn had got into it, and was causing all the pain.  He pulled out the thorn and bound up the paw of the Lion, who was soon able to rise and lick the hand of Androcles like a dog.  Then the Lion took Androcles to his cave, and every day used to bring him meat from which to live.  But shortly afterwards both Androcles and the Lion were captured, and the slave was sentenced to be thrown to the Lion, after the latter had been kept without food for several days.  The Emperor and all his Court came to see the spectacle, and Androcles was led out into the middle of the arena.  Soon the Lion was let loose from his den, and rushed bounding and roaring towards his victim.  But as soon as he came near to Androcles he recognised his friend, and fawned upon him, and licked his hands like a friendly dog.  The Emperor, surprised at this, summoned Androcles to him, who told him the whole story.  Whereupon the slave was pardoned and freed, and the Lion let loose to his native forest.') 
INSERT Fable(FableID, Title, Moral, FableText)
  VALUES (4, 'The Ass in the Lion''s Skin', 'Fine clothes may disguise, but silly words will disclose a fool.', 'An Ass once found a Lion''s skin which the hunters had left out in the sun to dry.  He put it on and went towards his native village.  All fled at his approach, both men and animals, and he was a proud Ass that day.  In his delight he lifted up his voice and brayed, but then every one knew him, and his owner came up and gave him a sound cudgeling for the fright he had caused.  And shortly afterwards a Fox came up to him and said: "Ah, I knew you by your voice."')
INSERT Fable(FableID, Title, Moral, FableText)
  VALUES (5, 'The Bundle of Sticks', 'Union gives strength.', 'An old man on the point of death summoned his sons around him to give them some parting advice.  He ordered his servants to bring in a faggot of sticks, and said to his eldest son, "Break it."  The son strained and strained, but with all his efforts was unable to break the Bundle.  The other sons also tried, but none of them was successful.  "Untie the faggots," said the father, "and each of you take a stick."  When they had done so, he called out to them, "Now, break," and each stick was easily broken.  "You see my meaning," said their father.')

INSERT Fable(FableID, Title, Moral, FableText)
  VALUES (6, 'The Eagle and the Arrow', 'We often give our enemies the means for our own destruction.', 'An Eagle was soaring through the air when suddenly it heard the whizz of an Arrow, and felt itself wounded to death.  Slowly it fluttered down to the earth, with its life-blood pouring out of it.  Looking down upon the Arrow with which it had been pierced, it found that the shaft of the Arrow had been feathered with one of its own plumes.  "Alas!" it cried, as it died.')
INSERT Fable(FableID, Title, Moral, FableText)
  VALUES (7, 'The Dove and the Ant', 'Little friends may prove great friends.', 'An Ant, going to a river to drink, fell in, and was carried along in the stream. A Dove pitied her condition, and threw into the river a small bough, by means of which the Ant gained the shore. The Ant afterward, seeing a man with a fowling-piece aiming at the Dove, stung him in the foot sharply, and made him miss his aim, and so saved the Dove''s life.')
INSERT Fable(FableID, Title, Moral, FableText)
  VALUES (8, 'The Woodman and the Serpent', 'No gratitude from the wicked.', 'One wintry day a Woodman was tramping home from his work when he saw something black lying on the snow.  When he came closer he saw it was a Serpent to all appearance dead.  But he took it up and put it in his bosom to warm while he hurried home.  As soon as he got indoors he put the Serpent down on the hearth before the fire.  The children watched it and saw it slowly come to life again.  Then one of them stooped down to stroke it, but the Serpent raised its head and put out its fangs and was about to sting the child to death.  So the Woodman seized his axe, and with one stroke cut the Serpent in two.  "Ah," said he.') 
INSERT Fable(FableID, Title, Moral, FableText)
  VALUES (9, 'The Wolf and the Kid', 'It is easy to be brave from a safe distance.', 'A Kid was perched up on the top of a house, and looking down saw a Wolf passing under him.  Immediately he began to revile and attack his enemy.  "Murderer and thief," he cried, "what do you here near honest folks'' houses?  How dare you make an appearance where your vile deeds are known?" "Curse away, my young friend," said the Wolf.')
INSERT Fable(FableID, Title, Moral, FableText)
  VALUES (10, 'The Old Woman and the Wine-Jar', 'The memory of a good deed lives.', 'An old woman found an empty jar which had lately been full of prime old wine and which still retained the fragrant smell of its former contents.  She greedily placed it several times to her nose, and drawing it backwards and forwards said, "O most delicious! How nice must the Wine itself have been, when it leaves behind in the very vessel which contained it so sweet a perfume!"')

INSERT Fable(FableID, Title, Moral, FableText)
  VALUES (11, 'The Hare and the Tortoise', 'Plodding wins the race."', 'The Hare was once boasting of his speed before the other animals.  "I have never yet been beaten," said he, "when I put forth my full speed.  I challenge any one here to race with me."    The Tortoise said quietly, "I accept your challenge."    "That is a good joke," said the Hare; "I could dance round you all the way."    "Keep your boasting till you''ve beaten," answered the Tortoise.  "Shall we race?"    So a course was fixed and a start was made.  The Hare darted almost out of sight at once, but soon stopped and, to show his contempt for the Tortoise, lay down to have a nap.  The Tortoise plodded on and plodded on, and when the Hare awoke from his nap, he saw the Tortoise just near the winning-post and could not run up in time to save the race.  Then said the Tortoise: Plodding wins the race.')
INSERT Fable(FableID, Title, Moral, FableText)
  VALUES (12, 'The Goose With the Golden Eggs', 'Greed often over reaches itself.', 'One day a countryman going to the nest of his Goose found there an egg all yellow and glittering.  When he took it up it was as heavy as lead and he was going to throw it away, because he thought a trick had been played upon him.  But he took it home on second thoughts, and soon found to his delight that it was an egg of pure gold.  Every morning the same thing occurred, and he soon became rich by selling his eggs.  As he grew rich he grew greedy; and thinking to get at once all the gold the Goose could give, he killed it and opened it only to find nothing. ')
INSERT Fable(FableID, Title, Moral, FableText)
  VALUES (13, 'The Eagle and the Fox', 'Do unto others as you would have them do unto you.', 'An eagle and a Fox formed an intimate friendship and decided to live near each other.  The Eagle built her nest in the branches of a tall tree, while the Fox crept into the underwood and there produced her young.  Not long after they had agreed upon this plan, the Eagle, being in want of provision for her young ones, swooped down while the Fox was out, seized upon one of the little cubs, and feasted herself and her brood.  The Fox on her return, discovered what had happened, but was less grieved for the death of her young than for her inability to avenge them.  A just retribution, however, quickly fell upon the Eagle.  While hovering near an altar, on which some villagers were sacrificing a goat, she suddenly seized a piece of the flesh, and carried it, along with a burning cinder, to her nest.  A strong breeze soon fanned the spark into a flame, and the eaglets, as yet unfledged and helpless, were roasted in their nest and dropped down dead at the bottom of the tree.  There, in the sight of the Eagle, the Fox gobbled them up.') 
INSERT Fable(FableID, Title, Moral, FableText)
  VALUES (14, 'The Dogs and the Fox', 'It is easy to kick a man that is down.', 'Some dogs, finding the skin of a lion, began to tear it in pieces with their teeth.  A Fox, seeing them, said, "If this lion were alive, you would soon find out that his claws were stronger than your teeth."  ') 
INSERT Fable(FableID, Title, Moral, FableText)
  VALUES (15, 'The Ant and the Chrysalis', 'Appearances are deceptive.', 'An Ant nimbly running about in the sunshine in search of food came across a Chrysalis that was very near its time of change. The Chrysalis moved its tail, and thus attracted the attention of the Ant, who then saw for the first time that it was alive. "Poor, pitiable animal!" cried the Ant disdainfully. "What a sad fate is yours! While I can run hither and thither, at my pleasure, and, if I wish, ascend the tallest tree, you lie imprisoned here in your shell, with power only to move a joint or two of your scaly tail." The Chrysalis heard all this, but did not try to make any reply. A few days after, when the Ant passed that way again, nothing but the shell remained. Wondering what had become of its contents, he felt himself suddenly shaded and fanned by the gorgeous wings of a beautiful Butterfly. "Behold in me," said the Butterfly, "your much-pitied friend! Boast now of your powers to run and climb as long as you can get me to listen." So saying, the Butterfly rose in the air, and, borne along and aloft on the summer breeze, was soon lost to the sight of the Ant forever.')

INSERT Fable(FableID, Title, Moral, FableText)
  VALUES (16, 'The Shipwrecked Impostor', 'A liar deceives no one but himself.', 'The shipwrecked Chimpanzee had been clinging for a long time to a slender spar, when a Dolphin came up and offered to carry him ashore. This kind proposition was immediately accepted, and, as they moved along, the Chimp commenced to tell the Fish many marvelous tales, every one of them a bundle of falsehoods. "Well, well, you are indeed an educated chap," said the Dolphin in admiration. "My schooling has been sadly neglected, as I went to sea when but a week old." Just then they entered a large bay, and the Dolphin, referring to it, said, "I suppose you know Herring Roads?" The chimp, taking this for the name of a fellow, and not wishing to appear ignorant, replied: "Do I know Rhodes? Well, I should almost think so! He''s an old college chum of mine, and related to our family by-" This was too much for the Dolphin, who immediately made a great leap, and then diving quickly, left the impostor in the air for an instant before he splashed back and disappeared.')
INSERT Fable(FableID, Title, Moral, FableText)
  VALUES (17, 'The Seagull and the Kite', 'Every man should be content to mind his own business.', 'A seagull having bolted down too large a fish, burst its deep gullet-bag and lay down on the shore to die.  A Kite saw him and exclaimed,  "You richly deserve your fate; for a bird of the air has no business to seek its food from the sea."')
INSERT Fable(FableID, Title, Moral, FableText)
  VALUES (18, 'Hercules and the Waggoner', 'The gods help them that help themselves.', 'A Waggoner was once driving a heavy load along a very muddy way.  At last he came to a part of the road where the wheels sank half-way into the mire, and the more the horses pulled, the deeper sank the wheels.  So the Waggoner threw down his whip, and knelt down and prayed to Hercules the Strong.  "O Hercules, help me in this my hour of distress," quoth he.  But Hercules appeared to him, and said: "Tut, man, don''t sprawl there.  Get up and put your shoulder to the wheel."')
INSERT Fable(FableID, Title, Moral, FableText)
  VALUES (19, 'The Boy and the Filberts', 'Do not attempt too much at once.', 'A boy put his hand into a pitcher full of filberts.  He grasped as many as he could possibly hold, but when he tried to pull out his hand, he was prevented from doing so by the neck of the pitcher.  Unwilling to lose his filberts, and yet unable to withdraw his hand, he burst into tears and bitterly lamented his disappointment.  A bystander said to him, "Be satisfied with half the quantity, and you will readily draw out your hand."') 
INSERT Fable(FableID, Title, Moral, FableText)
  VALUES (20, 'The Hunter and the Woodman', 'The hero is brave in deeds as well as words.', 'A hunter, not very bold, was searching for the tracks of a Lion.  He asked a man felling oaks in the forest if he had seen any marks of his footsteps or knew where his lair was.  "I will," said the man, "at once show you the Lion himself."  The Hunter, turning very pale and chattering with his teeth from fear, replied, "No, thank you.  I did not ask that; it is his track only I am in search of, not the Lion himself."') 

INSERT Fable(FableID, Title, Moral, FableText)
  VALUES (21, 'The Crow and the Pitcher', 'Necessity is the mother of invention.', 'A crow perishing with thirst saw a pitcher, and hoping to find water, flew to it with delight.  When he reached it, he discovered to his grief that it contained so little water that he could not possibly get at it.  He tried everything he could think of to reach the water, but all his efforts were in vain.  At last he collected as many stones as he could carry and dropped them one by one with his beak into the pitcher, until he brought the water within his reach and thus saved his life.')  
INSERT Fable(FableID, Title, Moral, FableText)
  VALUES (22, 'The Father and His Two Daughters', 'You can''t please everybody.', 'A man had two daughters, the one married to a gardener, and the other to a tile-maker.  After a time he went to the daughter who had married the gardener, and inquired how she was and how all things went with her.  She said, "All things are prospering with me, and I have only one wish, that there may be a heavy fall of rain, in order that the plants may be well watered."  Not long after, he went to the daughter who had married the tilemaker, and likewise inquired of her how she fared; she replied, "I want for nothing, and have only one wish, that the dry weather may continue, and the sun shine hot and bright, so that the bricks might be dried."  He said to her, "If your sister wishes for rain, and you for dry weather, with which of the two am I to join my wishes?') 
INSERT Fable(FableID, Title, Moral, FableText)
  VALUES (23, 'The Horse and Groom', 'A man may smile yet be a villain.', 'A groom used to spend whole days in currycombing and rubbing down his Horse, but at the same time stole his oats and sold them for his own profit.  "Alas!"  said the Horse, "if you really wish me to be in good condition, you should groom me less, and feed me more."') 
INSERT Fable(FableID, Title, Moral, FableText)
  VALUES (24, 'The Serpent and the Eagle', 'One good turn deserves another.', 'An Eagle swooped down upon a Serpent and seized it in his talons with the intention of carrying it off and devouring it. But the Serpent was too quick for him and had its coils round him in a moment; and then there ensued a life-and-death struggle between the two. A countryman, who was a witness of the encounter, came to the assistance of the eagle, and succeeded in freeing him from the Serpent and enabling him to escape. In revenge, the Serpent spat some of his poison into the man''s drinking-horn. Heated with his exertions, the man was about to slake his thirst with a draught from the horn, when the Eagle knocked it out of his hand, and spilled its contents upon the ground.') 
INSERT Fable(FableID, Title, Moral, FableText)
  VALUES (25, 'The Shepherd''s Boy and the Wolf', 'There is no believing a liar, even when he speaks the truth.', 'A shepherd-boy, who watched a flock of sheep near a village, brought out the villagers three or four times by crying out, "Wolf! Wolf!"  and when his neighbors came to help him, laughed at them for their pains.  The Wolf, however, did truly come at last.  The Shepherd-boy, now really alarmed, shouted in an agony of terror:  "Pray, do come and help me; the Wolf is killing the sheep"; but no one paid any heed to his cries, nor rendered any assistance.  The Wolf, having no cause of fear, at his leisure lacerated or destroyed the whole flock.')  

USE Aesop
SELECT Title, Len(FableText) AS Length
  FROM Fable 
  ORDER BY 
    CASE 
      WHEN SubString(Title, 1,3) = 'The'  
        THEN SubString(Title, 5, Len(Title)-4)
      ELSE Title 
    END

USE MASTER





