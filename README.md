# Egg

This is an example of programming for programming's sake, a utility that will do in one minute what you could do without its help in one minute -- and it took a day to write. Well, I was bored.

Egg is a simple utility for preparing your workspace for a new project. You choose where to put it, what to call it, and the type of project it will be, and Egg will create the working directory and the start file(s), and will launch your editor of choice.
--------------------------------------------------------------------------------------------------
<u>Settings</u>

Before first use of Egg, you will need open its configuration file, called nest.egg, with a text editor, and enter some basic information.

Egg needs a list of your preferred editors, the location of your coding workshop, and where your template files are stored. Some sample data is included with the nest.egg distributed with Egg. It is laid out like this ...

   Editors:codium geany gedit nano
	Templates:/home/elizabeth/Coding/Templates/
	Workshop:/home/elizabeth/Coding/
    
Only edit after the colons - and do not delete the labels or the colons.

List your editor or editors in a space-separated list after the 'Editors:' label, all on one line.
Enter the full path to a directory where template files are kept. Your editor may have created some.
Enter the full path to the base directory of your coding workshop.

After this first entry, you can edit nest.egg externally any time as desired, or from within Egg by selecting Settings from the menu.
--------------------------------------------------------------------------------------------------
<u>Application</u>

Note that **Egg** sources the **Lister** library of simple interfaces, written for use in a text-based environment, so make sure that a copy of lister.sh is also present in your working directory. A copy of **Lister** is distributed with Egg for your convenience. The current version of lister.sh was advanced to 2.00b on 2023/10/12, and Egg ships with this version.

**Egg** is kept as basic as possible - you're a programmer, you know what to do.
--------------------------------------------------------------------------------------------------
The program described herein is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details. A copy of the GNU General Public License is available from:
The Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

Egg is free software; you can redistribute it and/or modify it under the terms of the
GNU General Public License as published by the Free Software Foundation; either version 2 of
the License, or (at your option) any later version.

Elizabeth Mills 2023.10.12
