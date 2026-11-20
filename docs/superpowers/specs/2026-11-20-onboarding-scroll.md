# Onboarding neighborhood scroll

The wheel must scroll the neighborhood list over labels, inter-row/inter-column gaps and padding, regardless of cursor shape. Reaching the list boundary must not chain into document scrolling. Keep selection, search filtering, responsive columns and accessible grouping unchanged.

Use an ordinary inner scroll container rather than overflowing the fieldset and its browser-generated anonymous content box. Keep the fieldset/legend relationship; give the inner container a keyboard tab stop and an accessible name.
