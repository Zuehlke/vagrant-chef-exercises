
## Chef TDD: Ruby-level Linting with Cookstyle

Lint checks find easy to catch bugs and ensure a consistent coding style. For linting Chef cookbooks
on Ruby code level you usually use:

 * [cookstyle](https://docs.chef.io/cookstyle.html)
 * (which is based on [rubocop](https://github.com/rubocop-hq/rubocop))

### Running Cookstyle Linting

Run the `cookstyle` to check for issues on Ruby level:
```
$ cookstyle .
Inspecting 6 files
.C....

Offenses:

metadata.rb:10:10: C: Style/StringLiterals: Prefer single-quoted strings when you don't need string interpolation or special symbols.
supports "ubuntu"
         ^^^^^^^^

6 files inspected, 1 offense detected
```

And ooops, it already found some issues that we introduced earlier.

### Manual Correction

We could simply correct that manually in our `metadata.rb` by using single quotes:
```ruby
...
supports 'ubuntu'
```

Now that we run cookstyle again:
```
$ cookstyle .
Inspecting 6 files
......

6 files inspected, no offenses detected
```

### Auto-Correction

Another option would have been to auto-correct the offenses that cookstyle finds. In order to do that, you would have run `cookstyle --auto-correct` instead:
```
$ cookstyle --auto-correct .
Inspecting 6 files
.C....

Offenses:

metadata.rb:10:10: C: Style/StringLiterals: Prefer single-quoted strings when you don't need string interpolation or special symbols.
supports "ubuntu"
         ^^^^^^^^

6 files inspected, 1 offense detected, 1 offense corrected
```

Seems we are all fine again now!
```
$ cookstyle .
Inspecting 6 files
......

6 files inspected, no offenses detected
```

### Exclusions

Finally, we could also have excluded specific rules or even complete files via a `.rubocop.yml` configuration file, e.g. like this one:
```yaml
Style/StringLiterals:
  Enabled: false
```

Also this would also make it pass again:
```
$ cookstyle .
Inspecting 6 files
......

6 files inspected, no offenses detected
```
