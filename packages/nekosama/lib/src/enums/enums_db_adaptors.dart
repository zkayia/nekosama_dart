

int enumToDb<T extends Enum>(T enumValue) => enumValue.index;

T enumFromDb<T extends Enum>(List<T> values, int dbValue) =>
	values.elementAt(dbValue);
