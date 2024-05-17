# MMORPG Project with TFS and OTC

This repository contains the implementation for a Tibia based game project, with The Forgotten Server as the main server and the Open Tibia Client for the client side. Additional included tools (Resources) include Object Builder, for sprite editing, Z Note AAC for the host server website template and Uniform Server Zero as a WAMP solution to run such a project on a local machine.

This project is the submission for the assignment that I was provided by Tavernlight games, the studio behind Ravendawn, which is arguably one of the most refined, popular and ambitious MMORPG experiences based on Tibia that we have seen till date.

> The implementation for all the trials provided has been done collectively in the attached server/client. I will go over each trial in detail in indivisual markdowns, and link the relevant resources, files, results and code there.

# Software / Tech Stack

The primary basis for the implementation include TFS & OTC, both of which are Open Source software

### The Forgotten Server - v 1.4.2

> The Forgotten Server is a free and open-source MMORPG server emulator written in C++. It is a fork of the OpenTibia Server project. To connect to the server, you can use OTClient. _(Github)_

TFS handles the server side of the game, with a robust set of features and a lot of flexibility.
Local setup involves:

1. Downloading TFS/Compiling it from the main repository.
   - Here I went with the pre-compiled TFS build, since the requirement was version 1.4, and the current branch contained v1.5.
2. Setting up a local server environment based on any XAMP/WAMP solution, and add the server side webpage to it.
   - I have used Uniform server for this purpose, along with ZNoteAAC.
3. Create the main database (SQL required) for the project, and import relevant schemas.
   - `schema.sql` in the TFS folder is essential for any TFS project.
   - `znote.sql` is also required if ZNote is being used.
4. Setting up required Configurations in `config.lua` file.
5. Finally, run the server and create any accounts and characters!

The scripting is primarily done in `Lua`, and source code is in `C++` if any modification is required. In the scope of the assignment, I did not see any need to modify the source code, and was successfully able to implement all server side questions in Lua itself.

### Open Tibia Client - v 0.6.6

> Otclient is an alternative Tibia client for usage with otserv. It aims to be complete and flexible, for that it uses LUA scripting for all game interface functionality and configurations files with a syntax similar to CSS for the client interface design. Users can also create new mods and extend game interface for their own purposes. Otclient is written in C++11 and heavily scripted in lua. _(Github)_

OT Client has been used as the client side for this project.
Local setup involves:

1. Downloading OTC/Compiling it from the main repository.
   - Here, I compiled the latest version from the GitHub repository. (Windows)
2. Setting up the `things` folder, with a desired version of spr and dat files.
   - I have used the data files for version 10.98, though OTC supports most versions (except more recent ones)
3. Login to the account and select the desired character
   - Must be done after creating it via the ZNote website hosted on Uniform Server
4. Add/Use any additional tools if required.
   - The current project contains Object Builder, an amazing tool to edit/add sprites and game objects.

# Assignment Links

I believe I may have gone overboard in places, trying to explain things much more than developers actually need. Still, it may be considered valid for the assignment's purpose, as in my view they are meant to reflect my understanding of the code I write, moreso than making already proficient developers' understand. I think they may prove very helpful for anyone who is completely new to this kind of project as well!

1. **Code Implementation based tests** (Q1 - Q4) - [Link to Assignment](https://github.com/PrateekTh/TFS-OTC-Implementation/blob/main/assignments/questions.md)

2. Custom Spells (Q5) - [Link to Assignment](https://github.com/PrateekTh/TFS-OTC-Implementation/blob/main/assignments/spells.md)
3. Custom Shader Effects - Client (Q6)
4. Creating Simple Modules - Client (Q7)

# Conclusion

I can feel that there was an array of things that I did not know or realise earlier, before working on this game, that I have now learned, and find myself immensely intrigued by.

- One of the primary things here has to be my experience with Lua. Though I have not gone over the benchmarks for speed yet, but with the amount of simplicity and power it offers, I can clearly understand why it is becoming the go-to language for several development projects.

- While going through the source code, and implementing various features, I learned so much more about MMORPGs. Though I always knew they are vast (and definitely not easy to make), but now I have a better grasp over what goes into setting up a seamless experience. It certainly is more complex than I could have figured, but it has several avenues and it makes me quite excited to think about the possibilities, that we as developers can execute to enhance player experience!

- The importance of proper documentation, is also something that I realised here. The Open Tibia project (especially OTC) is technically robust, and contains several features and once you look into it, quite structured source code. But due to there being quite sparse documentation in most places, most of these features are underutilized. While deciphering source code was an experience in itself, I cannot help but recognised the importance of well made documentation.

All in all, this project was a blast to work on, and I liked so many parts of it that I could not cover them all if I tried. I hope it is fun for anyone who goes through it!
