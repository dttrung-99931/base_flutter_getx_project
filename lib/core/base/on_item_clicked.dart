enum EditAction { Delete, Click, Update }
typedef OnItemEdited<T> = Function(T model, EditAction action);
