import sys

from os import path


def print_err(*args, **kwargs):
    print(*args, file=sys.stderr, **kwargs)


ENV_FILE_PATH = "/opt/adsb/.env"  # FIXME


class Env:
    def __init__(
        self,
        name: str,
        value: str = None,
        is_mandatory: bool = True,
        default: str = "",
        default_call: callable = None,
        value_call: callable = None,
        tags: list = None,
    ):
        self._name = name
        self._value = value
        self._is_mandatory = is_mandatory
        self._default = default
        self._value_call = value_call
        self._tags = tags
        self._file = ENV_FILE_PATH

        if default_call:
            self._default = default_call()

        # Always reconcile from file
        self._reconcile(value=None, pull=True)

    def _reconcile(self, value, pull: bool = False):
        print_err(f"reconcile for {self.name} in {self._file}")
        if not path.isfile(self._file):
            # Let's create it
            open(self._file, "w").close()

        value_in_file = self._get_value_from_file()
        if pull and value_in_file:
            self._value = value_in_file
            return

        if self.value == value_in_file:
            return  # do not write to file if value is the same
        self._write_value_to_file()

    def _get_values_from_file(self):
        ret = {}
        try:
            with open(self._file, "r") as f:
                for line in f.readlines():
                    if line.strip().startswith("#"):
                        continue
                    key, var = line.partition("=")[::2]
                    ret[key.strip()] = var.strip()
        except:
            pass

        return ret

    def _get_value_from_file(self):
        return self._get_values_from_file().get(self._name, None)

    def _write_value_to_file(self):
        print_err(f"write_value_to_file for {self.name}")
        values = self._get_values_from_file()
        values[self._name] = self.value
        with open(self._file, "w") as f:
            for key, value in values.items():
                f.write(f"{key}={value}\n")

    def __str__(self):
        return f"Env({self._name}, {self._value})"

    @property
    def name(self):
        return self._name

    @property
    def is_mandatory(self) -> bool:
        return self._is_mandatory

    @property
    def is_bool(self) -> bool:
        # if it has is_enabled in the tags, it is a bool and we
        # accept True/False in setter,
        # and write 0/1 to file.
        return "is_enabled" in self._tags

    @property
    def value(self):
        value = None
        if self.is_bool:
            value = True if self._value == "1" else False
        elif self._value_call:
            value = self._value_call()
        elif self._value:
            value = self._value
        else:
            value = self._default
        if value != self._value:
            self._value = value
            self._reconcile(value)
        return value

    @value.setter
    def value(self, value):
        print_err(f"setting value of {self.name} to {value}...")
        # mess with value in case we are a bool
        if self.is_bool:
            value = True if value == "1" else False

        if value != self._value:
            self._value = value
            self._reconcile(value)

    @property
    def tags(self):
        if not self._tags:
            return []
        return self._tags
