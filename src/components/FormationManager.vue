<template>
  <div class="formation-manager bg-gray-700 rounded-lg p-4 shadow-xl absolute top-4 right-4 z-40 w-80" :class="{ minimized: isMinimized }">
    <button @click="isMinimized = !isMinimized" class="absolute top-1 right-1 bg-gray-800 text-white rounded px-2 py-1 text-xs z-40">
      {{ isMinimized ? '⤢' : '—' }}
    </button>
    <h3 v-show="!isMinimized" class="text-white font-semibold mb-2">Formations</h3>
    <div v-show="!isMinimized" class="mb-3 flex gap-2">
      <input
        v-model="formationName"
        placeholder="Formation name"
        class="flex-1 px-3 py-2 bg-gray-600 text-white rounded border border-gray-500 focus:border-blue-400 focus:outline-none"
      />
      <button
        @click="saveFormation"
        :disabled="!formationName.trim()"
        class="px-3 py-2 bg-blue-600 text-white rounded hover:bg-blue-700 disabled:bg-gray-500 disabled:cursor-not-allowed"
      >
        Save
      </button>
    </div>
    <div v-show="!isMinimized" class="mb-3">
      <label class="text-white text-sm block mb-1">Saved Formations:</label>
      <select
        v-model="selectedFormation"
        class="w-full px-3 py-2 bg-gray-600 text-white rounded border border-gray-500 focus:border-blue-400 focus:outline-none"
      >
        <option value="">Select formation</option>
        <option
          v-for="formation in savedFormations"
          :key="formation.id"
          :value="formation.id"
        >
          {{ formation.name }}
        </option>
      </select>
    </div>
    <div v-if="selectedFormationData && !isMinimized" class="mb-3 flex gap-2">
      <button
        @click="loadFormation"
        class="px-3 py-2 bg-green-600 text-white rounded hover:bg-green-700 text-sm flex-1"
      >
        Load
      </button>
      <button
        @click="deleteFormation"
        class="px-3 py-2 bg-red-600 text-white rounded hover:bg-red-700 text-sm flex-1"
      >
        Delete
      </button>
    </div>
  </div>
</template>

<script>
export default {
  name: "FormationManager",
  props: {
    getCurrentFormation: Function, // () => { players: {...}, ball: {...} }
    setFormation: Function // (formation) => void
  },
  data() {
    return {
      isMinimized: false,
      formationName: "",
      savedFormations: [],
      selectedFormation: "",
      nextFormationId: 1
    };
  },
  computed: {
    selectedFormationData() {
      return this.savedFormations.find(f => f.id === this.selectedFormation);
    }
  },
  mounted() {
    this.loadFormationsFromStorage();
  },
  methods: {
    saveFormation() {
      if (!this.formationName.trim() || !this.getCurrentFormation) return;
      const formation = {
        id: this.nextFormationId++,
        name: this.formationName.trim(),
        data: this.getCurrentFormation(),
        createdAt: new Date().toISOString()
      };
      this.savedFormations.push(formation);
      this.saveFormationsToStorage();
      this.formationName = "";
    },
    loadFormation() {
      if (this.selectedFormationData && this.setFormation) {
        this.setFormation(this.selectedFormationData.data);
      }
    },
    deleteFormation() {
      if (!this.selectedFormation) return;
      this.savedFormations = this.savedFormations.filter(f => f.id !== this.selectedFormation);
      this.selectedFormation = "";
      this.saveFormationsToStorage();
    },
    saveFormationsToStorage() {
      try {
        localStorage.setItem('tacticalboard_formations', JSON.stringify({
          formations: this.savedFormations,
          nextId: this.nextFormationId
        }));
      } catch (error) {
        console.error('Failed to save formations:', error);
      }
    },
    loadFormationsFromStorage() {
      try {
        const data = localStorage.getItem('tacticalboard_formations');
        if (data) {
          const parsed = JSON.parse(data);
          this.savedFormations = parsed.formations || [];
          this.nextFormationId = parsed.nextId || 1;
        }
      } catch (error) {
        console.error('Failed to load formations:', error);
      }
    }
  }
};
</script>

<style scoped>
.formation-manager {
  min-width: 280px;
}
  .formation-manager.minimized {
    width: 40px;
    min-width: 0;
    height: 40px;
    overflow: hidden;
    background: transparent;
    box-shadow: none;
  }
</style>
