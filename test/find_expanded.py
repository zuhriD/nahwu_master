import os
import re

def check_file(filepath):
    with open(filepath, 'r') as f:
        content = f.read()
    
    # Remove comments
    content = re.sub(r'//.*', '', content)
    content = re.sub(r'/\*.*?\*/', '', content, flags=re.DOTALL)
    
    # Very simple check: find Column followed by Expanded or Spacer inside it
    # This is a heuristic
    if 'Column' in content and ('Expanded' in content or 'Spacer' in content):
        print(f"Checking {filepath}...")
        lines = content.split('\n')
        for i, line in enumerate(lines):
            if 'Expanded(' in line or 'Spacer(' in line:
                # Look backwards for Column or Row
                j = i
                while j >= 0:
                    if 'Row(' in lines[j] or 'Row (' in lines[j]:
                        break
                    if 'Column(' in lines[j] or 'Column (' in lines[j]:
                        print(f"  Found potential Column -> Expanded/Spacer at line {i+1}: {line.strip()}")
                        break
                    j -= 1

for root, _, files in os.walk('lib'):
    for file in files:
        if file.endswith('.dart'):
            check_file(os.path.join(root, file))
