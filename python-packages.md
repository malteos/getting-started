# Build and distribute Python packagees

```bash
# build package
python -m build

# publish to testpypi
twine upload --repository testpypi dist/*

# publish to pypi
twine upload dist/*

# install as editable package
pip install -e .



```
