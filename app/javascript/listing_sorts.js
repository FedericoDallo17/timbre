// A sort dimension can only be used once, regardless of direction.
const dimension = (value) => value.replace(/_(low|high)$/, "")

const updateSortControls = (controls) => {
  const selects = [...controls.querySelectorAll("select")]
  selects.forEach((select) => {
    const used = new Set(selects.filter((other) => other !== select && other.value)
      .map((other) => dimension(other.value)))
    for (const option of select.options) {
      option.disabled = Boolean(option.value) && used.has(dimension(option.value))
    }
  })
}

const initializeSortControls = () => {
  document.querySelectorAll("[data-sort-controls]").forEach(updateSortControls)
}

document.addEventListener("turbo:load", initializeSortControls)
document.addEventListener("DOMContentLoaded", initializeSortControls)
document.addEventListener("change", (event) => {
  const controls = event.target.closest("[data-sort-controls]")
  if (controls) updateSortControls(controls)
})
document.addEventListener("reset", (event) => {
  // The browser restores default values after dispatching reset.
  queueMicrotask(() => {
    event.target.querySelectorAll("[data-sort-controls]").forEach(updateSortControls)
  })
})
