import os

def check_file(filepath):
    with open(filepath, 'r') as f:
        lines = f.readlines()
        
    for i, line in enumerate(lines):
        if 'Expanded(' in line or 'Spacer(' in line:
            # We found an Expanded or Spacer. Let's look up to find its parent.
            # Very naive, but let's print 10 lines before it to inspect manually.
            pass

def find_horizontal_scroll_or_row():
    for root, _, files in os.walk('lib'):
        for file in files:
            if not file.endswith('.dart'): continue
            path = os.path.join(root, file)
            with open(path, 'r') as f:
                content = f.read()
            
            if 'SingleChildScrollView' in content and 'scrollDirection: Axis.horizontal' in content:
                print(f"Found horizontal scroll in {path}")
                
            # Regex for Row inside Row? Hard to do with regex.
            
find_horizontal_scroll_or_row()
