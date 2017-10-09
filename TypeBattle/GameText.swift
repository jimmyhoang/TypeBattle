//
//  GameText.swift
//  TypeBattle
//
//  Created by Fernando Jinzenji on 2017-10-08.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//

import Foundation

enum GameTextType {
    case poem
    case quote
}

class GameText {
    
    static let poems = [
        "From fairest creatures we desire increase, that thereby beauty's rose might never die, but as the riper should by time decease, his tender heir might bear his memory: But thou contracted to thine own bright eyes, Feed'st thy light's flame with self-substantial fuel, Making a famine where abundance lies.",
        "When forty winters shall besiege thy brow, And dig deep trenches in thy beauty's field, Thy youth's proud livery so gazed on now, Will be a tatter'd weed of small worth held:Then being asked, where all thy beauty lies, Where all the treasure of thy lusty days; To say, within thine own deep sunken eyes, Were an all-eating shame, and thriftless praise.",
        "Look in thy glass and tell the face thou viewest Now is the time that face should form another; Whose fresh repair if now thou not renewest, Thou dost beguile the world, unbless some mother. For where is she so fair whose unear'd womb Disdains the tillage of thy husbandry? Or who is he so fond will be the tomb, Of his self-love to stop posterity?",
        "Unthrifty loveliness, why dost thou spend Upon thy self thy beauty's legacy? Nature's bequest gives nothing, but doth lend, And being frank she lends to those are free: Then, beauteous niggard, why dost thou abuse The bounteous largess given thee to give? Profitless usurer, why dost thou use So great a sum of sums, yet canst not live?",
        "Those hours, that with gentle work did frame The lovely gaze where every eye doth dwell, Will play the tyrants to the very same And that unfair which fairly doth excel; For never-resting time leads summer on To hideous winter, and confounds him there; Sap checked with frost, and lusty leaves quite gone, Beauty o'er-snowed and bareness everywhere.",
        "Then let not winter's ragged hand deface, In thee thy summer, ere thou be distill'd: Make sweet some vial; treasure thou some place With beauty's treasure ere it be self-kill'd. That use is not forbidden usury, Which happies those that pay the willing loan; That's for thy self to breed another thee.",
        "Lo! in the orient when the gracious light Lifts up his burning head, each under eye Doth homage to his new-appearing sight, Serving with looks his sacred majesty; And having climb'd the steep-up heavenly hill, Resembling strong youth in his middle age, Yet mortal looks adore his beauty still, Attending on his golden pilgrimage.",
        "Music to hear, why hear'st thou music sadly? Sweets with sweets war not, joy delights in joy: Why lov'st thou that which thou receiv'st not gladly, Or else receiv'st with pleasure thine annoy? If the true concord of well-tuned sounds, By unions married, do offend thine ear, They do but sweetly chide thee.",
        "Is it for fear to wet a widow's eye, That thou consum'st thy self in single life? Ah! if thou issueless shalt hap to die, The world will wail thee like a makeless wife;The world will be thy widow and still weep That thou no form of thee hast left behind, When every private widow well may keep By children's eyes, her husband's shape in mind: Look!",
        "For shame! deny that thou bear'st love to any, Who for thy self art so unprovident. Grant, if thou wilt, thou art belov'd of many, But that thou none lov'st is most evident: For thou art so possess'd with murderous hate, That 'gainst thy self thou stick'st not to conspire, Seeking that beauteous roof to ruinate Which to repair should be thy chief desire.",
        "As fast as thou shalt wane, so fast thou grow'st, In one of thine, from that which thou departest; And that fresh blood which youngly thou bestow'st, Thou mayst call thine when thou from youth convertest, Herein lives wisdom, beauty, and increase; Without this folly, age, and cold decay.",
        "When I do count the clock that tells the time, And see the brave day sunk in hideous night; When I behold the violet past prime And sable curls, all silvered o'er with white; When lofty trees I barren of leaves, Which erst from heat did canopy the herd, And summer's green all girded up in sheaves, Borne on the bier with white and bristly beard.",
        "O! that you were your self; but, love you are No longer yours, than you your self here live: Against this coming end you should prepare, And your sweet semblance to some other give: So should that beauty which you hold in lease Find no determination; then you were Yourself again, after yourself's decease, When your sweet issue your sweet form should bear.",
        "Not from the stars do I my judgement pluck; And yet methinks I have astronomy, But not to tell of good or evil luck, Of plagues, of dearths, or seasons' quality; Nor can I fortune to brief minutes tell, Pointing to each his thunder, rain and wind.",
        "How can I then return in happy plight, That am debarre'd the benefit of rest? When day's oppression is not eas'd by night, But day by night and night by day oppress'd, And each, though enemies to either's reign, Do in consent shake hands to torture me, The one by toil, the other to complain How far I toil, still farther off from thee.",
        "When in disgrace with fortune and men's eyes I all alone beweep my outcast state, And trouble deaf heaven with my bootless cries, And look upon myself, and curse my fate, Wishing me like to one more rich in hope, Featur'd like him, like him with friends possess'd, Desiring this man's art, and that man's scope, With what I most enjoy contented least",
        "When to the sessions of sweet silent thought I summon up remembrance of things past, I sigh the lack of many a thing I sought, And with old woes new wail my dear time's waste: Then can I drown an eye, unused to flow, For precious friends hid in death's dateless night, And weep afresh love's long since cancell'd woe, And moan the expense of many a vanish'd sight.",
        "How careful was I when I took my way, Each trifle under truest bars to thrust, That to my use it might unused stay From hands of falsehood, in sure wards of trust! But thou, to whom my jewels trifles are, Most worthy comfort, now my greatest grief, Thou best of dearest, and mine only care, Art left the prey of every vulgar thief.",
        "That time of year thou mayst in me behold When yellow leaves, or none, or few, do hang Upon those boughs which shake against the cold, Bare ruin'd choirs, where late the sweet birds sang. In me thou see'st the twilight of such day As after sunset fadeth in the west; Which by and by black night doth take away, Death's second self, that seals up all in rest.",
        "Say that thou didst forsake me for some fault, And I will comment upon that offence: Speak of my lameness, and I straight will halt, Against thy reasons making no defence.",
        "Euripides, and Sophocles to us, Pacuvius, Accius, him of Cordova dead, To live again, to hear thy buskin tread, And shake a stage; or, when thy socks were on, Leave thee alone for the comparison Of all that insolent Greece or haughty Rome Sent forth, or since did from their ashes come."
    ]
    
    static let quotes = [
        "A healthy creative process should be able to give a coherent rationale to a client as to why you designed what you designed.",
        "Interesting things never happen to me. I happen to them.",
        "Stop. I'm not going to take any more input until I've made something with what I got.",
        "I like nonsense, it wakes up the brain cells. Fantasy is a necessary ingredient in living, It's a way of looking at life through the wrong end of a telescope. Which is what I do, and that enables you to laugh at life's realities.",
        "Having a style is like being in jail.",
        "Remember to always be yourself. Unless you suck.",
        "Be who you are and say what you feel because those who mind don't matter and those who matter don't mind.",
        "Questions about whether design is necessary or affordable are quite beside the point: design is inevitable. The alternative to good design is bad design, not no design at all.",
        "It is important not to let the perfect become the enemy of the good, even when you can agree on what perfect is. Doubly so when you can't. As unpleasant as it is to be trapped by past mistakes, you can't make any progress by being afraid of your own shadow during design.",
        "Whether you think you can or whether you think you can't, you are right.",
        "If it sounds good, you'll hear it. If it looks good, you'll see it. If it's marketed right, you'll buy it. But if it's real, you'll feel it.",
        "At the age of six I wanted to be a cook. At seven I wanted to be Napoleon. And my ambition has been growing steadily ever since.",
        "If you spend an hour now, you can save five later.",
        "Solving any problem is more important than being right.",
        "Where do new ideas come from? The answer is simple: differences. Creativity comes from unlikely juxtapositions.",
        "Rules can be broken, but never ignored.",
        "Great ideas can be found in every leaf, in every tree, in every blade of grass. Oh, no, wait, I was thinking of chlorophyll.",
        "A drawing should have no unnecessary lines and a machine no unnecessary parts.",
        "Few people are capable of expressing with equanimity opinions which differ from the prejudices of their social environment. Most people are even incapable of forming such opinions.",
        "A camel is a horse designed by a committee.",
        "You can't improvise on nothing man; you've gotta improvise on something.",
        "Everything was just a wild guess. And it takes a while to get confident that you're guessing pretty good.",
        "I want to risk hitting my head on the ceiling of my talent. I want to really test it out and say okay, you're not that good. You just reached the level here. I don't ever want to fail, but I want to risk failure every time out of the gate.",
        "A mystery is the most stimulating force in unleashing the imagination.",
        "My adventure has all been in my mind. The great adventure has been thinking. I love to think about things. I think that the lack of drama in my life has produced a platform for me to be fundamentally adventurous in my thinking.",
        "However beautiful the strategy, you should occasionally look at the results.",
        "We ourselves feel that what we are doing is just a drop in the ocean. But the ocean would be less because of that missing drop.",
        "The work you do while you procrastinate is probably the work you should be doing for the rest of your life.",
        "My secret is being not terrible at a lot of things.",
        "Every child is an artist. The challenge is to remain an artist after you grow up.",
        "Better to be tentative than to be recklessly sure; to be an apprentice at sixty, than to present oneself as a doctor at ten.",
        "I never let my schooling get in the way of my education.",
        "The optimist proclaims that we live in the best of all possible worlds; and the pessimist fears this is true.",
        "But remember, there are beginnings in endings, through destruction comes life and you have the same strength in you that makes the phoenix rise from the flames.",
        "Honesty is the best policy, unless you work in advertising.",
        "High degrees of specialization may be rendering us unable to see the connections between the things we design and their consequences as they ripple out into the biosphere.",
        "Be a first rate version of yourself, not a second rate version of someone else.",
        "If you see a snake, just kill it. Don't appoint a committee on snakes.",
        "I have no data yet. It is a capital mistake to theorize before one has data. Insensibly one begins to twist facts to suit theories, instead of theories to suit facts.",
        "Suppose I showed you two rooms where in one a group of programmers was developing a program to monitor a heart patient and keep him alive until the doctors arrive if something goes wrong and in the other a group of street people was using Microsoft Word to write letters to their parole officers. You would not be able to tell the rooms apart.",
        "How often have I said to you that when you have eliminated the impossible, whatever remains, however improbable, must be the truth? We know that he did not come through the door, the window, or the chimney. We also know that he could not have been concealed in the room, as there is no concealment possible. When, then, did he come?",
        "I wish there was a way to know you're in the good old days before you've actually left them.",
        "There's a lot of beauty in ordinary things. Isn't that kind of the point?",
        "The way a team plays as a whole determines its success. You may have the greatest bunch of individual stars in the world, but if they don't play together, the club won't be worth a dime.",
        "When you're good at something, you'll tell everyone. When you're great at something, they'll tell you.",
        "We have time to grow old. The air is full of our cries. But habit is a great deadener. At me too someone is looking, of me too someone is saying, he is sleeping, he knows nothing, let him sleep on.",
        "Think like a wise man but communicate in the language of the people.",
        "Observation and imitation are so often the steps to creative maturation. An insightful person can turn these into innovation.",
        "The major difference between a thing that might go wrong and a thing that cannot possibly go wrong is that when a thing that cannot possibly go wrong goes wrong it usually turns out to be impossible to get at or repair.",
        "There's a point when you're done simplifying. Otherwise, things get really complicated."
    ]
    
    
    
    class func getRandomText (type: GameTextType) -> String {
        
        switch type {
        case .poem:
            let index = Int(arc4random_uniform(20))
            return poems[index].lowercased()
        case .quote:
            let index = Int(arc4random_uniform(50))
            return quotes[index].lowercased()
        }
    }
}
