
# PopScope Widget Demo

A small Flutter app that shows how `PopScope` stops a user from leaving a screen by mistake.

## What is PopScope?

`PopScope` is a widget that controls the **back action** of a screen (the back button, the back arrow, and the back gesture).
You can block it, and then ask the user, for example: "You have unsaved changes. Do you want to leave?"

## Why is it useful?

Imagine a user types a long task title and presses back by mistake. Without `PopScope`, the text is lost with no warning.
It is useful for forms, payment screens, and "press back again to exit".

## How it works

```dart
PopScope(
  canPop: !(protect && hasChanges),   // false = block the back action
  onPopInvokedWithResult: (didPop, result) {
    if (didPop) return;               // the screen already closed
    _askBeforeLeaving();              // it was blocked, so ask the user
  },
  child: Scaffold(...),
)
```

| Part | Meaning |
|---|---|
| `canPop` | `true` lets the screen close, `false` blocks it |
| `onPopInvokedWithResult` | Runs every time the user tries to go back |
| `didPop` | `true` if the screen really closed, `false` if it was blocked |
| `child` | The screen you want to protect (usually the `Scaffold`) |


## Things to remember

- `canPop` is a `bool`, not a function, because Flutter must know the answer **before** the user presses back. That is why the dialog is shown inside the callback.
- `Navigator.pop(context)` is **not** blocked by `PopScope`. The **Save** and **Leave** buttons use it to close the screen.
- After an `await`, check `mounted` (or `context.mounted`) before you use the screen again.
- `PopScope` replaces the old `WillPopScope`. Old tutorials may still use the old name.

## Limits

`PopScope` only controls the back action. It cannot stop the user from closing the whole app, or the phone from stopping the app.