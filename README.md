idid
----

[![npm version](https://badge.fury.io/js/idid.svg)](http://badge.fury.io/js/idid)
[![dependencies](https://david-dm.org/jviotti/idid.png)](https://david-dm.org/jviotti/idid.png)
[![Build Status](https://travis-ci.org/jviotti/idid.svg?branch=master)](https://travis-ci.org/jviotti/idid)

![iDoneThis](https://github.com/jviotti/idid/raw/master/images/banner.png)

[![NPM](https://nodei.co/npm/idid.png?downloads=true&downloadRank=true&stars=true)](https://nodei.co/npm/idid/)

Cool and simple CLI for [iDoneThis](https://idonethis.com/) (non-official).

`idid` is simple, because only allows creating dones in a single team, with an easy interface, no bells and whistles.

`idid` is cool, for obvious reasons, no need for an explanation here :)

![Screenshot of idid in action](https://github.com/jviotti/idid/raw/master/images/screenshot.png)

Installation
------------

`idid` is a [Nodejs](https://nodejs.org) application, and is distributed from `npm`, which stands for "Node Package Manager".


Head over to [https://nodejs.org](https://nodejs.org) to install both Nodejs and `npm`.

Install `idid` by running:

```sh
$ npm install -g idid
```

Configuration
-------------

Configuration happens in `$HOME/.idid.json` on UNIX based operating systems and in `%HOMEPATH%\_idid.json` on Windows.

If you're struggling to find the correct location for your configuration file, running `$ idid -h` will print the place `idid` is expecting the configuration file:

```sh
$ idid -h
...
Edit /Users/jviotti/.idid.json to modify the default token and team.
...
```

The configuration file takes two fields:

- `token`: The account token, used for authentication. You can find yours at [https://idonethis.com/api/token/](https://idonethis.com/api/token/).
- `team`: The team where you want to post your dones to. Notice the team name sometimes doesn't match the display name shown in the website. To make sure you have the correct team name, open your team URL in [iDoneThis web interface](https://idonethis.com/), and see the resulting URL. For example, I have a personal team called "Work", but the URL is `https://idonethis.com/cal/work-td3a/`, therefore, I'll use `work-td3a` as my team in my configuration file.

Be careful of writing invalid JSON to the configuration file, or you will get an "invalid" error. Remember that the keys should be surrounded with double quotes as well.

An example of a configuration would be:

```json
{
  "token": "1234123412341234123412341234123412341234",
  "team": "work-td3a"
}
```

Please don't hesitate in [opening an ticket](https://github.com/jviotti/idid/issues/new) if you need any help setting up `idid.`

Contribute
----------

- Issue Tracker: [github.com/jviotti/idid/issues](https://github.com/jviotti/idid/issues)
- Source Code: [github.com/jviotti/idid](https://github.com/jviotti/idid)

Before submitting a PR, please make sure that you include tests, and that [coffeelint](http://www.coffeelint.org/) runs without any warning:

```sh
$ gulp lint
```

Support
-------

If you're having any problem, please [raise an issue](https://github.com/jviotti/idid/issues/new) on GitHub.

License
-------

The project is licensed under the MIT license.
