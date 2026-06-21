const fs = require('fs');
const text = fs.readFileSync('lib/screens/reading_screen.dart', 'utf8');
let count = 0;
for (let i = 0; i < text.length; i++) {
  if (text[i] === '{') count++;
  else if (text[i] === '}') {
    count--;
    if (count < 0) {
      const line = text.slice(0, i).split('\n').length;
      console.log('Negative count at line', line);
      count = 0; // reset
    }
    if (count === 0) {
      const line = text.slice(0, i).split('\n').length;
      console.log('Top-level closed at line', line);
    }
  }
}
