+++
title = "About"
path = "about"
template = "about.html"

[extra]
semweb_prefixes = [
    {name = "foaf", href = "http://xmlns.com/foaf/0.1/"},
    {name = "schema", href = "https://schema.org/"},
    {name = "owl", href = "http://www.w3.org/2002/07/owl#"},
    {name = "wd", href = "http://www.wikidata.org/entity/"},
    {name = "wdt", href = "http://www.wikidata.org/prop/direct/"}
]

semweb_about = "https://dandellion.xyz/about#me"
semweb_type = "foaf:Person"
+++

<link about="http://dandellion.xyz/about" rel="foaf:primaryTopic" href="http://dandellion.xyz/about#me"/>
<meta property="owl:sameAs" resource="http://dandellion.xyz/about#me"/>

# About me
Hey I'm <span property="foaf:nick">Dan</span>! I like computers and all things computing! I'm a certified Computer electronics technician,
and I am currently a third-year student taking computer engineering at NTNU in Trondheim.

## Early life

I've been interested in computers for as long as I can remember, and have been using linux based distributions as my personal choice for operating systems since the 7th grade.  
I took an edx course in introduction to computer science (CS50) in secondary school, where I was introduced to C as my first "real" text-based programming language
(Until then I had worked mostly in LabView-like languages like robolab, and scratch, with small amounts of bash).

<span property="wdt:P54 schema:memberOf" resource="http://robotix.info/#organization">
I was in a <span about="http://robotix.info/#organization" typeof="schema:SportsOrganization" property="schema:sport" resource="wd:Q170978">robotics</span> club programming LEGO mindstorms and competing in
<span about="wd:Q445067" property="schema:competitor" resource="http://robotix.info/#organization">FIRST LEGO LEAGUE</span>
</span> from I was 11 until I was too old to compete, where I then transitioned into an instructor role.   
This experience proved useful when I taught children how to program during my local makerspace's summer school, and later as an outside instructor for an elementary school.

## High-School

During high-school I was active in [Horten Folkeverksted](https://folkeverkstedet.com/)
where I had the role of infrastructure-responsible and member of the board.  
I held presentations during our yearly event "Sommer:hack". Holding talks about
<a property="foaf:topic_interest" resource="wd:Q22906785" href="https://matrix.org">Matrix</a>, 
<a property="foaf:topic_interest" resource="wd:Q7041957" href="https://nixos.org">Nix</a>,
and also being responsible for hosting the <span property="foaf:topic_interest" resource="wd:Q67328602">CTF competition</span> with an introduction to "ethical hacking".  

I took electrical engineering and specialized into "computers and electronics" where I learned a lot about electronic components
and also got to dabble with programming microcontrollers.
I'm hoping to post about the big project we did that year at some point, but cutting it short, we made a big rubix-cube out of RGB LEDs, 3D-printing, and steel.  
In my third year I was the leader for our youth company, which did electronics repair (but mostly helped pentioners with their computers).
I was also on the board of the student council.

## University

After I moved to Trondheim I joined Drift at <a property="schema:memberOf" resource="wd:Q113262282" href="https://www.pvv.ntnu.no/">Programvareverkstedet</a>,
where we maintain an extremely large amount of legacy infrastructure (Our DNS-server is a MicroVAX II from 1985) - But also have a lot of fun!  
I've held a course in <span property="foaf:topic_interest" resource="wd:Q21998874">NixOS</a> and managed to convert a fair few to using nix for their projects.
I later became Drift's coordinator, and am responsible for our matrix-server.

Here I also met my friends in <a property="schema:memberOf" resource="http://wackattack.eu/#organization" href="https://wackattack.eu">WackAttack</span></a>
a <span about="http://wackattack.eu/#organization" typeof="schema:SportsOrganization" property="schema:sport" resource="wd:Q7969355">CTF-team</span>
which won the student division and coming a close 6th overall at Equinor CTF 2023.

I had a brief stint with [hackerspace-ntnu](https://www.hackerspace-ntnu.no/), [AbelLAN](https://abakus.no/pages/grupper/49-abellan),
and am a member of <a property="schema:memberOf" resource="wd:Q97265498" href="https://www.omegav.ntnu.no/">Omega Verksted</a>

I live with a lot of people (>100!), and have a senior role where I am responsible for our email lists, networking, website and internal tools.


# Hobbies

In my spare time I maintain my own infrastructure which has gone through many a variation but has settled on a (of course) NixOS based config.
Through this homelab I maintain and host most of the services I use day to day.

I also program in my spare time, making software that scratches whatever itch I might have.
In the most recent years I have worked mostly on infrastructure as code via <a property="foaf:topic_interest" resource="wd:Q21998874" href="https://nixos.org">NixOS</a> (writing modules), and making and maintaining packages.
But I've also done some small things like writing a distributed video encoding service for <span property="foaf:topic_interest" resource="wd:Q26046105">AV1</span>, and a couple of matrix bots.

My favorite programming language is <span property="foaf:topic_interest" resource="wd:Q575650">Rust</span>, but I really want to learn Haskell and Erlang/Elixir as well.

I sometimes play video games, though mostly <span property="foaf:topic_interest" resource="wd:Q105729297">Minecraft</span> and <span property="foaf:topic_interest" resource="wd:Q771541">Dota 2</span>!  
I enjoy listening to music, watching movies, <span property="foaf:topic_interest" resource="wd:Q1107">Anime</span>, and playing boardgames.

Bonus point if you know what my avatar refers to!

# Featured Projects

* [My dotfiles](https://github.com/dali99/nix-dotfiles)
* [nixos-matrix-modules](https://github.com/dali99/nixos-matrix-modules)
* [AV1Master](https://github.com/dali99/AV1Master)
* [matrix-wug](https://github.com/dali99/matrix-wug)
* [stickerpack-dimension-migration-tool](https://github.com/dali99/stickerpack-dimension-migration-tool)

I'm also an active contributor to [nixpkgs](https://github.com/NixOS/nixpkgs) where I've:

<details>

* [Maintained](https://github.com/NixOS/nixpkgs/commits/master/pkgs/applications/graphics/hydrus/default.nix?author=dali99) and [improved](https://github.com/NixOS/nixpkgs/pull/131298) the hydrus package.
* [Fixed a systemd unit-name regression](https://github.com/NixOS/nixpkgs/pull/177273) and [made sure services didn't have too long descriptions](https://github.com/NixOS/nixpkgs/pull/157022)
* [Upgraded liquidsoap from 1.x to 2.x](https://github.com/NixOS/nixpkgs/pull/140777)
* [Broke gstreamer by adding butteraugli and vmaf support to libaom](https://github.com/NixOS/nixpkgs/pull/159461), [but fixed it again for both gstreamer and libjxl](https://github.com/NixOS/nixpkgs/pull/177374)
* Fixed static compilation of [libjxl](https://github.com/NixOS/nixpkgs/pull/179102) and [libaom](https://github.com/NixOS/nixpkgs/pull/179266) (with lots of help)
* [Introduced the .mailmap file](https://github.com/NixOS/nixpkgs/pull/179266)
* [Made a module for bluemap](https://github.com/NixOS/nixpkgs/pull/312518)
* Active in the nixpkgs matrix team

</details>

# Contact Information

e-mail: <a property="foaf:mbox" href="mailto:daniel.olsen99@gmail.com">daniel.olsen99@gmail.com</a>  
matrix: <a rel="foaf:account" typeof="foaf:OnlineAccount" resource="matrix:u/dandellion:dodsorf.as" href="https://matrix.to/#/@dandellion:dodsorf.as">@dandellion:dodsorf.as</a>, [URI](matrix:u/dandellion:dodsorf.as)  
IRC: Dandellion on [IRCNet](https://www.ircnet.com)  
XMPP: <a rel="foaf:account" typeof="OnlineAccount" href="xmpp:dandellion_dodsorf.as@matrix.org">dandellion_dodsorf.as@matrix.org</a>  

# Other platforms

You can find me on [github](https://github.com/dali99), [linkedin](https://www.linkedin.com/in/dandellion)
