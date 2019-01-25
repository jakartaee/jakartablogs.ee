# jakartablogs.ee

The [jakartablogs.ee](https://jakartablogs.ee) website is generated with [Planet Venus](https://github.com/rubys/venus).

Welcome to the blog home of open source, cloud native Java innovation! Read posts from our global community on Jakarta EE news, 
technologies, best practices, and compatible products.

## Add your blog
Want to become a Jakarta Blogs author? To add your blog to the feed, please have a look at our [guidelines](#guidelines) and then open a [GitHub issue](https://github.com/jakartaee/jakartablogs.ee/issues/new?template=add_blog.md) or create a pull request with your feed-specific information.

## Guidelines

We (the admins) generally ask ourselves the following questions before adding a feed to Jakarta Blogs:

* Is the feed written by a real person?
* Is the person an EE4J committer or contributor?
* Is the ratio of off-topic postings not too high?
* Are the off-topic postings covered by the Jakarta Blogs tag line?
* Does the feed promote a company or a commercial product?
* Does the feed add more value to Jakarta Blogs and the Jakarta EE community than it does for the feed owner?
* Is there more than just a welcome posting?
* Does the feed contain advertisements?
 
### Instructions
1. By opening a GitHub issue
2. By creating a pull request

The issue or pull request must include a picture (185x185), the RSS feed url for the blog and the full name of the author.

If the contributor chose to submit a pull request, this information must be added to planet/planet.ini file as follows:

~~~~
[https://blogs.eclipse.org/blog/180/feed]
name = Tanja Obradovic
picture = tanja-obradovic.jpg
~~~~

Pictures must be added to the planet/theme/authors folder.

## Getting started (Local development)

How to run the application:

```bash
docker-compose build && docker-compose up -d
```

## Contributing

1. [Fork](https://help.github.com/articles/fork-a-repo/) the [jakartaee/jakartablogs.ee](https://github.com/jakartaee/jakartablogs.ee) repository
2. Clone repository: `git clone https://github.com/[your_github_username]/jakartablogs.ee.git`
3. Create your feature branch: `git checkout -b my-new-feature`
4. Commit your changes: `git commit -m 'Add some feature' -s`
5. Push feature branch: `git push origin my-new-feature`
6. Submit a pull request

### Declared Project Licenses

This program and the accompanying materials are made available under the terms
of the Eclipse Public License v. 2.0 which is available at
http://www.eclipse.org/legal/epl-2.0.

SPDX-License-Identifier: EPL-2.0

## Related projects

### [EclipseFdn/solstice-assets](https://github.com/EclipseFdn/solstice-assets)

Images, less and JavaScript files for the Eclipse Foundation look and feel.

## Bugs and feature requests

Have a bug or a feature request? Please search for existing and closed issues. If your problem or idea is not addressed yet, [please open a new issue](https://github.com/jakartaee/jakartablogs.ee/issues/new).

## Author

**Christopher Guindon (Eclipse Foundation)**

- <https://twitter.com/chrisguindon>
- <https://github.com/chrisguindon>

## Trademarks

* Jakarta and Jakarta EE are Trademarks of the Eclipse Foundation, Inc.
* Eclipse® is a Trademark of the Eclipse Foundation, Inc.
* Eclipse Foundation is a Trademark of the Eclipse Foundation, Inc.

## Copyright and license

Copyright 2018 the [Eclipse Foundation, Inc.](https://www.eclipse.org) and the [jakartablogs.ee authors](https://github.com/jakartaee/jakartablogs.ee/graphs/contributors). Code released under the [Eclipse Public License Version 2.0 (EPL-2.0)](https://github.com/jakartaee/jakartablogs.ee/blob/src/LICENSE).
