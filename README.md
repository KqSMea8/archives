Busybook
========
[![Build Status](https://travis-ci.org/seiyanuta/busybook.svg?branch=master)](https://travis-ci.org/seiyanuta/busybook)
[![Coverage Status](https://coveralls.io/repos/github/seiyanuta/busybook/badge.svg?branch=master)](https://coveralls.io/github/seiyanuta/busybook?branch=master)
[![Code Climate](https://codeclimate.com/github/seiyanuta/busybook/badges/gpa.svg)](https://codeclimate.com/github/seiyanuta/busybook)
[![Dependency Status](https://gemnasium.com/seiyanuta/busybook.svg)](https://gemnasium.com/seiyanuta/busybook)

Busybook is a CalDAV server out of the box powered by Ruby on Rails.

## Quickstart
```
$ git clone https://github.com/seiyanuta/busybook
$ cd busybook

$ cp config/database.yml.config database.yml
$ vim database.yml

$ sudo docker build -t busybook .
# sudo docker run -i --name=busybook busybook

$ sudo docker exec -it rake user:add
```

## Backup
Busybook stores all data in the database so simply you can backup and restore by RDBMS's command like [pg_dump](http://www.postgresql.org/docs/9.5/static/app-pgdump.html).

## Supported clients
- OS X 10.11 (El Capitan): Calendar and Reminder
- iOS 9: Calendar and Reminder

## Compliance
- [RFC4918: HTTP Extensions for Web Distributed Authoring and Versioning (WebDAV)](http://tools.ietf.org/html/rfc4918)
  - supports `GET`, `PUT`, `DELETE`, `OPTIONS`, `MKCALENDAR`, `PROPFIND`, `MOVE`, `COPY`, and `PROPPATCH` HTTP methods
  - does *not* support `HEAD`, `POST`, `LOCK`, `UNLOCK`, and `MKCOL` HTTP methods
- [RFC4791: Calendaring Extensions to WebDAV (CalDAV)](http://tools.ietf.org/html/rfc4791)
  - supports `REPORT` HTTP method and its `time-range` comp-filter
  - supports `MKCALENDAR` HTTP method
- [RFC5545: iCalendar](http://tools.ietf.org/html/rfc5545)
  - supports `VEVENT` and `VTODO`
  - does *not* support `VJOURNAL`
- [caldav-ctag-03: Calendar Collection Entity Tag (CTag) in CalDAV](https://trac.calendarserver.org/browser/CalendarServer/trunk/doc/Extensions/caldav-ctag.txt)
  - supported
- [RFC3744: WebDAV Access Control Protocol](https://tools.ietf.org/html/rfc3744)
  - supports some pseudo PROPFIND responses for Apple's implementations
- [RFC5785: Defining Well-Known Uniform Resource Identifiers (URIs)](https://tools.ietf.org/html/rfc5785)
  - supported
- [RFC6638: Scheduling Extensions to CalDAV](http://tools.ietf.org/html/rfc6638)
  - *not* supported

## License
Public domain

## Changelog
- **v0.6.0**
  - fix /.well-known redirection
  - add Dockerfile
  - some improvements
- **v0.5.0**
  - init: update command
  - bug fixes
- **v0.4.0**
  - refactor
- **v0.3.0**
  - remove cli tool
  - add a init script for Debian and Ubuntu
- **v0.2.1**
  - bug fixes
- **v0.2.0**
  - add busybook CLI
  - support Well-Known URI
- **v0.1.1**
  - fix implementation of calendar-query
- **v0.1.0**
  - support iOS
  - support calendar-query REPORT request
  - export a calendar as a .ics file
