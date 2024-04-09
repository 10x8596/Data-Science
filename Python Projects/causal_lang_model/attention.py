# Causal language modeling predicts the next token 
# in a sequence of tokens, and the model can only attend 
# to tokens on the left. This means the model cannot see 
# future tokens. GPT-2 is an example of a causal language model.

import torch
import torch.nn.functional as F

def scaled_dot_product_attention(query, key, value):
    # Calculate the dot product between query and key
    scores = torch.matmul(query, key.transpose(-2, -1))

    # Scale the scores by square root of 'dk' (the dimension of the keys)
    dk = key.size(-1) # get the size of the key's last dimension
    scaled_scores= scores / torch.sqrt(torch.tensor(dk).float())

    # Apply the softmax function to the scaled scores to get the attention weights
    attention_weights = F.softmax(scaled_scores, dim=-1)

    # Multiply the weights by the value vectors to get the output
    output = torch.matmul(attention_weights, value)

    return output, attention_weights

# Test the function
device = "cuda" if torch.cuda.is_available() else "cpu"
query = torch.randn(3, 8, device=device)
key = torch.randn(3, 8, device=device)
value = torch.randn(3, 8, device=device)

output, attention_weights = scaled_dot_product_attention(query, key, value)
print("Output shape: ", output.shape)
print("Attention weights shape: ", attention_weights.shape)