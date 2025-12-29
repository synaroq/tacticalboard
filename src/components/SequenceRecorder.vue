<template>
  <div class="sequence-recorder absolute top-4 left-4 z-30" :class="{ minimized: isMinimized }">
    <button @click="isMinimized = !isMinimized" class="absolute top-1 right-1 bg-gray-800 text-white rounded px-2 py-1 text-xs z-40">
      {{ isMinimized ? '⤢' : '—' }}
    </button>
    <!-- Recording Controls -->
    <div v-show="!isMinimized" class="bg-gray-700 rounded-lg p-4 shadow-xl">
      <div class="flex items-center gap-3 mb-3">
        <h3 class="text-white font-semibold">Play Sequences</h3>
        <div
          v-if="isRecording"
          class="w-3 h-3 bg-red-500 rounded-full animate-pulse"
        ></div>
      </div>
      
      <!-- Control Buttons -->
      <div class="flex gap-2 mb-3">
        <button
          @click="startRecording"
          :disabled="isRecording || isPlaying"
          class="px-3 py-2 bg-red-600 text-white rounded hover:bg-red-700 disabled:bg-gray-500 disabled:cursor-not-allowed flex items-center gap-2"
        >
          <font-awesome-icon :icon="['fas', 'record-vinyl']" />
          Record
        </button>
        
        <button
          @click="stopRecording"
          :disabled="!isRecording"
          class="px-3 py-2 bg-gray-600 text-white rounded hover:bg-gray-700 disabled:bg-gray-500 disabled:cursor-not-allowed"
        >
          <font-awesome-icon :icon="['fas', 'stop']" />
          Stop
        </button>
        
        <button
          @click="playSequence"
          :disabled="isRecording || isPlaying || !selectedSequence"
          class="px-3 py-2 bg-green-600 text-white rounded hover:bg-green-700 disabled:bg-gray-500 disabled:cursor-not-allowed flex items-center gap-2"
        >
          <font-awesome-icon :icon="['fas', 'play']" />
          Play
        </button>
        
        <button
          @click="pausePlayback"
          :disabled="!isPlaying"
          class="px-3 py-2 bg-yellow-600 text-white rounded hover:bg-yellow-700 disabled:bg-gray-500 disabled:cursor-not-allowed"
        >
          <font-awesome-icon :icon="['fas', 'pause']" />
          Pause
        </button>
      </div>

      <!-- Save Sequence -->
      <div v-if="currentSequence.actions.length > 0 && !isRecording" class="mb-3">
        <div class="flex gap-2">
          <input
            v-model="sequenceName"
            placeholder="Sequence name"
            class="flex-1 px-3 py-2 bg-gray-600 text-white rounded border border-gray-500 focus:border-blue-400 focus:outline-none"
          />
          <button
            @click="saveSequence"
            :disabled="!sequenceName.trim()"
            class="px-3 py-2 bg-blue-600 text-white rounded hover:bg-blue-700 disabled:bg-gray-500 disabled:cursor-not-allowed"
          >
            Save
          </button>
        </div>
      </div>

      <!-- Sequence List -->
      <div class="mb-3">
        <label class="text-white text-sm block mb-1">Saved Sequences:</label>
        <select
          v-model="selectedSequence"
          class="w-full px-3 py-2 bg-gray-600 text-white rounded border border-gray-500 focus:border-blue-400 focus:outline-none"
        >
          <option value="">Select sequence</option>
          <option
            v-for="sequence in savedSequences"
            :key="sequence.id"
            :value="sequence.id"
          >
            {{ sequence.name }} ({{ sequence.actions.length }} actions)
          </option>
        </select>
      </div>

      <!-- Sequence Actions -->
      <div v-if="selectedSequenceData" class="mb-3">
        <button
          @click="deleteSequence"
          class="px-3 py-2 bg-red-600 text-white rounded hover:bg-red-700 text-sm"
        >
          <font-awesome-icon :icon="['fas', 'trash']" />
          Delete
        </button>
      </div>

      <!-- Playback Controls -->
      <div v-if="isPlaying" class="mb-3">
        <div class="flex items-center gap-2 mb-2">
          <label class="text-white text-sm">Speed:</label>
          <input
            v-model.number="playbackSpeed"
            type="range"
            min="0.25"
            max="3"
            step="0.25"
            class="flex-1"
          />
          <span class="text-white text-sm">{{ playbackSpeed }}x</span>
        </div>
        <div class="bg-gray-600 rounded h-2">
          <div
            class="bg-green-500 h-2 rounded transition-all"
            :style="{ width: playbackProgress + '%' }"
          ></div>
        </div>
        <div class="text-white text-xs mt-1">
          Action {{ currentActionIndex + 1 }} of {{ selectedSequenceData?.actions.length || 0 }}
        </div>
      </div>

      <!-- Recording Status -->
      <div v-if="isRecording" class="text-red-400 text-sm">
        Recording... {{ currentSequence.actions.length }} actions captured
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: "SequenceRecorder",
  data() {
    return {
      isMinimized: false,
      isRecording: false,
      isPlaying: false,
      currentSequence: {
        actions: []
      },
      savedSequences: [],
      selectedSequence: "",
      sequenceName: "",
      playbackSpeed: 1,
      playbackProgress: 0,
      currentActionIndex: 0,
      playbackInterval: null,
      nextSequenceId: 1
    };
  },
  computed: {
    selectedSequenceData() {
      return this.savedSequences.find(seq => seq.id === this.selectedSequence);
    }
  },
  mounted() {
    this.loadSequencesFromStorage();
  },
  methods: {
    startRecording() {
      this.isRecording = true;
      this.currentSequence = {
        actions: [],
        startTime: Date.now()
      };
      this.$emit('recording-started');
    },

    stopRecording() {
      this.isRecording = false;
      this.$emit('recording-stopped', this.currentSequence);
    },

    recordAction(actionData) {
      if (this.isRecording) {
        const action = {
          ...actionData,
          timestamp: Date.now() - this.currentSequence.startTime
        };
        this.currentSequence.actions.push(action);
      }
    },

    saveSequence() {
      if (!this.sequenceName.trim() || this.currentSequence.actions.length === 0) return;
      
      const sequence = {
        id: this.nextSequenceId++,
        name: this.sequenceName.trim(),
        actions: [...this.currentSequence.actions],
        createdAt: new Date().toISOString()
      };
      
      this.savedSequences.push(sequence);
      this.saveSequencesToStorage();
      this.sequenceName = "";
      this.currentSequence = { actions: [] };
    },

    async playSequence() {
      if (!this.selectedSequenceData || this.isPlaying) return;
      
      this.isPlaying = true;
      this.currentActionIndex = 0;
      this.playbackProgress = 0;
      
      const sequence = this.selectedSequenceData;
      this.$emit('playback-started', sequence);
      
      // Reset board to initial state
      this.$emit('reset-board');
      
      for (let i = 0; i < sequence.actions.length; i++) {
        if (!this.isPlaying) break;
        
        const action = sequence.actions[i];
        const nextAction = sequence.actions[i + 1];
        
        // Execute the action
        this.$emit('execute-action', action);
        this.currentActionIndex = i;
        this.playbackProgress = ((i + 1) / sequence.actions.length) * 100;
        
        // Calculate delay to next action
        const delay = nextAction 
          ? (nextAction.timestamp - action.timestamp) / this.playbackSpeed 
          : 500;
        
        await this.sleep(Math.max(delay, 50)); // Minimum 50ms delay
      }
      
      this.isPlaying = false;
      this.playbackProgress = 100;
      this.$emit('playback-finished');
    },

    pausePlayback() {
      this.isPlaying = false;
      this.$emit('playback-paused');
    },

    deleteSequence() {
      if (!this.selectedSequence) return;
      
      this.savedSequences = this.savedSequences.filter(
        seq => seq.id !== this.selectedSequence
      );
      this.selectedSequence = "";
      this.saveSequencesToStorage();
    },

    sleep(ms) {
      return new Promise(resolve => setTimeout(resolve, ms));
    },

    saveSequencesToStorage() {
      try {
        localStorage.setItem('tacticalboard_sequences', JSON.stringify({
          sequences: this.savedSequences,
          nextId: this.nextSequenceId
        }));
      } catch (error) {
        console.error('Failed to save sequences:', error);
      }
    },

    loadSequencesFromStorage() {
      try {
        const data = localStorage.getItem('tacticalboard_sequences');
        if (data) {
          const parsed = JSON.parse(data);
          this.savedSequences = parsed.sequences || [];
          this.nextSequenceId = parsed.nextId || 1;
        }
      } catch (error) {
        console.error('Failed to load sequences:', error);
      }
    },

    clearAllSequences() {
      this.savedSequences = [];
      this.selectedSequence = "";
      this.saveSequencesToStorage();
    }
  }
};
</script>

<style scoped>
.sequence-recorder {
  min-width: 280px;
}

@keyframes pulse {
  0%, 100% {
    opacity: 1;
  }
  50% {
    opacity: 0.5;
  }
}

.animate-pulse {
  animation: pulse 1s cubic-bezier(0.4, 0, 0.6, 1) infinite;
}
  .sequence-recorder.minimized {
    width: 40px;
    min-width: 0;
    height: 40px;
    overflow: hidden;
    background: transparent;
    box-shadow: none;
  }
</style>