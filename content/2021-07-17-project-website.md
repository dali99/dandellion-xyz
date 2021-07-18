+++
title = "Project Showcase: Blog"
date = 2021-07-17
updated = 2021-07-18

slug = "projet-blog"
[taxonomies]
categories = ["Technical", "All"]
tags = ["Nix", "Zola", "Web Assembly", "Python", "Matrix"]
+++

I'm going to write a series of blog posts on some of the projects I've worked on, 
and what would be better to start with than this very website?

<!-- more -->

## Zola

For the blog I used the static site generator [Zola](https://www.getzola.org/), 
it's rust based and I think it keeps a nice balance between "keeping it simple"
and having nice quality of life features. After trying things like [Gatsby](https://www.gatsbyjs.com/), 
[Jekyll](https://jekyllrb.com/), and [Hugo](https://gohugo.io/)
I've found myself really enjoying this one. A very good first impression!

Zola has a themes feature like most SSGs, I'm using my own fork of [even](https://github.com/dali99/even), 
which's only current difference from upstream is that it has a python webassembly [shortcode](https://www.getzola.org/documentation/content/shortcodes/) and a commenting system.

I picked `even` mostly for its \\(\KaTeX\\) support and simple design.

## Python WASM

{% python() %}
print("Hello World")
{% end %}

Try running the code above with the `Run` button!  
The codeblock is even editable by the user. Click inside and edit it to print your name 
or something!

This works by using [Pyodide](https://pyodide.org/), a complete python interperator compiled to WASM!  
It uses some magic from [pyodide/pyodide#8 (comment)](https://github.com/pyodide/pyodide/issues/8#issuecomment-772024841) to reroute stdout to the fake console.  

You should definetly play around with it, it even handles `input()`! (click cancel to send EOF or whatever)

I plan on maybe using this with stuff like matplotlib to generate some cool interactive graphs in the future.

While very cool, hitting that run button does download like 8MB of js and wasm data. 
So I decided not to preload  it, and rather  grab it when ran whilst providing a warning by the button. 
Luckilly future presses of should be cached by your browser... I hope...

## Cactus Comments

I'm a big fan of [Matrix](https://matrix.org/), so when [Cactus Comments](https://cactus.chat/) was announced in [#twim:matrix.org](matrix:r/twim:matrix.org?via=matrix.org&via=dodsorf.as) I had to jump on it.

Embedding it was super easy and I think it really exemplifies that matrix is a useful tool for many more things than chat!

When you comment, I get a ping over matrix, and I can reply or react to the comments right in my chat program. 

To check out the comment system of this post you can join the matrix room at [#comments_dandellion-xyz_UHJvamVjdCBTaG93Y2FzZTogQmxvZw==:cactus.chat](matrix:r/comments_dandellion-xyz_UHJvamVjdCBTaG93Y2FzZTogQmxvZw==:cactus.chat).  
(I originally used the slug for the identifier for these comment boxes, but changed it to base64 of the title. Not the smartest choice I've ever made...)

## Building

For development I have a nix-shell with zola in it and just clone the theme into themes manually.  
But for deploying the website I actually made a cute litle package for it which is used together with the nginx module:
```nix
let
  even = pkgs.fetchFromGitHub {
    owner = "dali99";
    repo = "even";
    rev = "730a85d3fa1d54569cc8d7d2d162461d955572ce";
    sha256 = "0d04xas3mml0n1j64d4gl292bbhdrn02cmjxpjqglbimd4y4cn64";
  };
  dandellion-xyz = pkgs.stdenv.mkDerivation {
    pname = "dandellion-xyz";
    version = "2021-03-04";
    nativeBuildInputs = [ pkgs.unstable.zola ];

    src = pkgs.fetchFromGitHub {
      owner = "dali99";
      repo = "dandellion-xyz";
      rev = "169945c0a2bfc142f21beedd5de73918e5118e7e";
      sha256 = "0vjllyas7s8lzhqbn907xg9ma97339qf4iq8bl6fmdd0nfksbivf";
    };

    buildPhase = ''
      mkdir themes
      ln -s ${even} themes/even
      zola build
    '';

    installPhase = ''
      mkdir -p $out
      mv public/* $out/
    '';
  };
in
{
  services.nginx.virtualHosts."dandellion.xyz" = {
    enableACME = true;
    forceSSL = true;

    root = dandellion-xyz;
  };
}
```

This works well, but has the downside of me needing to change those hashes every time I want to update the site.
No push-to-deploy gitops stuff going on here. Not to mention having to rebuild the entire system just to deploy a website!

I'll probably look into setting something with a litte better UX in the future. 
Maybe I'll let [Hydra](https://github.com/NixOS/hydra) build it

For now though it's not _too_ too bad, and it gives me some incentive to proof-read my stuff before pushing it live...

## Wrap up

And that's all, result is served with [nginx](https://www.nginx.com/), with certs from [Let's Encrypt](https://letsencrypt.org/), running on [NixOS](https://nixos.org/)

In the future I hope to take some time to move some of the files currently served from the CDNs so stuff won't randomly break, 
and to change that awful comic sans title the website seems to fall back to on Windows. (Finding out about that was a little embarassing)

Thanks for reading. Hopefully I'll have some more interesting blogposts in the future!  
Feel free to ask questions in the comments!
