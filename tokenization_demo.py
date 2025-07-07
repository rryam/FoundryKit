#!/usr/bin/env python3

# Simulating real tokenizer behavior
# This shows why character-level constraints don't work

def mock_tokenize(text):
    """Simplified tokenizer that shows the real problem"""
    # Real tokenizers learn subword patterns from data
    # These are realistic examples of how text gets tokenized
    token_map = {
        '{"name":': [123, 456],      # Common JSON pattern -> single token
        '{"nam': [789],              # Partial, but still a token
        'e":': [234],                # Completion 
        '"hello': [567],             # Quote + word start
        ' world"': [890],            # Space + word + quote
        '{': [1],                    # Single char
        '"': [2],                    # Single char  
        'name': [3],                 # Word
        ':': [4],                    # Single char
        'hello': [5],                # Word
        'world': [6],                # Word
        '}': [7],                    # Single char
    }
    
    # Greedy longest match (like real tokenizers)
    tokens = []
    i = 0
    while i < len(text):
        best_match = None
        best_len = 0
        
        for pattern, token_list in token_map.items():
            if text[i:].startswith(pattern) and len(pattern) > best_len:
                best_match = token_list
                best_len = len(pattern)
        
        if best_match:
            tokens.extend(best_match)
            i += best_len
        else:
            # Unknown character -> special token
            tokens.append(999)
            i += 1
    
    return tokens

def demonstrate_problem():
    print("=== The Tokenization Problem ===\n")
    
    test_cases = [
        '{"name":',     # Valid JSON start
        '{"nam',        # Invalid JSON, but valid token
        'e":',          # Completes to valid
        '"hello',       # String start
        ' world"',      # String end
    ]
    
    for text in test_cases:
        tokens = mock_tokenize(text)
        print(f"Text: {repr(text):12} -> Tokens: {tokens}")
    
    print("\n=== Why Character-Level Constraints Fail ===")
    print("1. '{"nam' is invalid JSON but tokenizes to [789]")
    print("2. You can't predict that token 789 is invalid without")
    print("   knowing what comes next")
    print("3. Character constraints would reject 'm' in position 5,")
    print("   but the tokenizer already committed to token 789")

if __name__ == "__main__":
    demonstrate_problem() 