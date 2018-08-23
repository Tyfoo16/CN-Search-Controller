# CN-Search-Controller
Pin Yin Characters Search controller Demo 

Example of search controller that able to search with pinyin input.

It able to read from pinyin characters with or without space and acronym characters.

Examples:

Input : yi qian ling yi ye
Output: 一千零一夜 

Input : yiqianlingyiye
Output: 一千零一夜 

Input : yqlyy
Output: 一千零一夜 

It also will show how to serialize unicode characters from json string and convert human readable words.

3 types of sample data provided.
- Unicode Characters in JSON string
- Raw UInt16 Binary 
- Local data list with chinese words 

You can play around in simulator with chinese pinyin keyboard.
*To add new keyboard, go Settings > General > Keyboard > Keyboards
