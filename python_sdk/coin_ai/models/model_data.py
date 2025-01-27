# coin_ai/models/model_data.py

import torch
import torch.nn as nn
import torch.optim as optim
import numpy as np

# Define a simple neural network model
class SimpleNN(nn.Module):
    def __init__(self):
        super(SimpleNN, self).__init__()
        self.layer1 = nn.Linear(10, 32)  # Input layer (10 features to 32 nodes)
        self.layer2 = nn.Linear(32, 16)  # Hidden layer (32 nodes to 16)
        self.output_layer = nn.Linear(16, 1)  # Output layer (16 nodes to 1 output)
        self.sigmoid = nn.Sigmoid()  # Sigmoid activation for binary output

    def forward(self, x):
        x = torch.relu(self.layer1(x))
        x = torch.relu(self.layer2(x))
        x = self.sigmoid(self.output_layer(x))
        return x

# Create some dummy data to train the model
X_train = torch.tensor(np.random.rand(100, 10), dtype=torch.float32)  # 100 samples, 10 features
y_train = torch.tensor(np.random.randint(0, 2, size=(100, 1)), dtype=torch.float32)  # Random binary labels

# Create the model, loss function, and optimizer
model = SimpleNN()
loss_fn = nn.BCELoss()  # Binary Cross Entropy for binary classification
optimizer = optim.Adam(model.parameters())

# Train the model
for epoch in range(5):
    optimizer.zero_grad()
    predictions = model(X_train)
    loss = loss_fn(predictions, y_train)
    loss.backward()
    optimizer.step()

# Save the model to a binary file (model_data.bin)
torch.save(model.state_dict(), 'coin_ai/models/model_data.bin')

print("Model saved to model_data.bin")
