# Multi-Dataset Environmental Sound Classification System
## ESC-50 / UrbanSound8K / FSD50K  
## MFCC-SVM and Log-Mel-CNN with Real-Time Audio Recognition

This repository provides a complete environmental sound classification system supporting multiple datasets and two training pipelines. The project includes dataset preprocessing, feature extraction, model training, evaluation, GUI dataset selection, and real-time microphone prediction.

The architecture is modular and suitable for academic use (e.g., ELEC5305), research, or production prototyping.

---

# 1. Features

## 1.1 Supported Datasets
- ESC-50  
- UrbanSound8K  
- FSD50K (dev set)

Users may train on any combination of the above datasets using the GUI selection interface.

## 1.2 Two Training Pipelines
### MFCC + SVM (traditional machine learning)
- Uses 13 MFCC coefficients  
- Feature vector: concatenated mean + standard deviation (26-dim)  
- Trains an ECOC multi-class SVM  
- Fast training, low computational cost

### Log-Mel Spectrogram + CNN (deep learning)
- Generates fixed 128×128 log-mel images  
- Trains a lightweight CNN  
- Higher accuracy than SVM  
- Fully automatic pipeline for multiple datasets

## 1.3 Real-Time Audio Prediction
The script `recordAndPredict.m` automatically:
- Records microphone audio
- Determines model type (SVM or CNN)
- Extracts the correct feature representation
- Produces the predicted class label

## 1.4 Provided GUI Tools
- `main_train_svm_selectable_gui.m`  
- `main_train_cnn_selectable_gui.m`  
Both allow training without modifying any code.

---

# 2. Project Structure

(base) davidwang@Mac elec5305-project-530534486 % tree -a -L 3
.
├── .DS_Store
├── .git
├── .gitignore
├── config
│   └── config.m
├── data
│   ├── .DS_Store
│   ├── ESC-50
│   │   ├── .circleci
│   │   ├── .DS_Store
│   │   ├── .github
│   │   ├── .gitignore
│   │   ├── audio
│   │   ├── esc50.gif
│   │   ├── LICENSE
│   │   ├── meta
│   │   ├── pytest.ini
│   │   ├── README.md
│   │   ├── requirements.txt
│   │   └── tests
│   ├── FSD50K
│   │   ├── .DS_Store
│   │   ├── dev_audio
│   │   └── metadata
│   ├── melspec_combined_cnn
│   │   ├── .DS_Store
│   │   ├── esc50
│   │   └── us8k
│   └── urbansound8k
│       ├── .DS_Store
│       ├── audio
│       ├── FREESOUNDCREDITS.txt
│       ├── metadata
│       ├── UrbanSound8K_README.txt
│       └── UrbanSound8K.tar.gz
├── main_live_demo_gui.m
├── main_train_cnn_selectable_gui.m
├── main_train_svm_selectable_gui.m
├── models
│   ├── .DS_Store
│   ├── model_cnn_esc50_us8k.mat
│   └── model_esc50_us8k_mfcc_svm.mat
├── README.md
├── results
└── src
    ├── .DS_Store
    ├── dataset
    │   ├── getDatasetConfig.m
    │   ├── loadEsc50Meta.m
    │   ├── loadFSD50KMeta.m
    │   └── loadUS8KMeta.m
    ├── features
    │   ├── .DS_Store
    │   ├── buildMelSpecForDataset.m
    │   ├── extractFixedMFCC_dataset.m
    │   ├── extractFixedMFCC.m
    │   ├── extractMelSpec_CNN.m
    │   ├── extractMelSpec_dataset.m
    │   └── extractMelSpec.m
    ├── inference
    │   ├── .DS_Store
    │   ├── predictCNN.m
    │   ├── predictSVM_generic.m
    │   └── recordAndPredict.m
    ├── train
    │   ├── .DS_Store
    │   ├── evaluateModel.m
    │   ├── main_train_cnn_core.m
    │   ├── main_train_cnn_selectable.m
    │   ├── main_train_svm_core.m
    │   ├── main_train_svm_selectable.m
    │   ├── trainBaselineSVM_2way.m
    │   ├── trainCNN_selectable.m
    │   └── trainCNN.m
    └── utils
        ├── plotConfusionNice.m
        └── saveExperimentResult.m


---

# 3. Installation

## 3.1 MATLAB Requirements
Required toolboxes:
- Audio Toolbox
- Signal Processing Toolbox
- Deep Learning Toolbox
- Parallel Computing Toolbox

## 3.2 Download Datasets
Place datasets under `data/` as follows:

data/ESC-50/
data/urbansound8k/
data/FSD50K/

# 4. Training Models
## 4.1 Train SVM (MFCC)
Start GUI:
main_train_svm_selectable_gui

Pipeline Summary:
- Load selected datasets
- Extract fixed MFCC (13 coefficients → 26 features)
- Train ECOC-SVM
- Save model

Example Model Output:
models/model_esc50_us8k_mfcc_svm.mat

## 4.2 Train CNN (Log-Mel)
Start GUI:
main_train_cnn_selectable_gui

Pipeline Summary:
- Load selected datasets
- Generate 128 × 128 log-mel spectrograms
- Train CNN
- Save model

CNN Architecture (Simplified):
Input (128 × 128 × 1)
Conv → BatchNorm → ReLU → MaxPool
Conv → BatchNorm → ReLU → MaxPool
Conv → BatchNorm → ReLU
FullyConnected
Softmax
ClassificationLayer

Example Output Model:
models/model_cnn_esc50_us8k.mat

# 5. Live Demo GUI
This project provides a ready-to-use graphical interface for real-time audio recognition.

## 5.1 Launch the GUI
main_live_demo_gui

## 5.2 Features
- Load trained SVM or CNN models
- Record audio using the microphone
- Automatically extract MFCC (for SVM) or Log-Mel (for CNN)
- Display the predicted label
- Easy testing without command-line inputs

## 5.3 Usage Instructions
- Click “Load Model” and choose a .mat model file
- Click “Record and Predict”
- Speak or play a sound near the microphone
- The predicted class appears immediately

This GUI is intended for demonstration, experiments, and user testing.

# 6. Real-Time Audio Prediction
Run:
recordAndPredict("models/model_cnn_esc50_us8k.mat", 3);

Function behavior:
- Detects model type
- Extracts MFCC or Log-Mel automatically
- Returns predicted label

Example output:
Using model: model_cnn_esc50_us8k.mat
Recording 3.0 seconds...
Predicted Sound: dog_bark

# 7. .gitignore

OS:
.DS_Store
.idea/
.vscode/

MATLAB autosave:
*.asv
*.m~
*.autosave

Simulink/codegen/cache:
slprj/
codegen/
cachedir/

Generated spectrogram folders:
data/melspec_*/
data/melspec_all/
data/melspec_combined*/
data/melspec_temp/

Results:
results/*.png
results/*.mat

Keep trained models:
!models/*.mat

# 8. Dataset Information
Dataset	        Description	                    License	    Link:
ESC-50	        50-class environmental sounds	CC BY 4.0	https://github.com/karoldvl/ESC-50
UrbanSound8K	8732 labeled sound excerpts	    CC BY 4.0	https://urbansounddataset.weebly.com
FSD50K	        50k general-purpose audio clips	CC BY 4.0	https://zenodo.org/record/4060432

# 9. License
This project is distributed under the MIT License.
