# Next Release

## 1.4.1 (01/27/2014)

* Remove at_exit shutdown hook

## 1.4.0 (01/19/2014)

* Remove explicit setting of dispatcher

## 1.3.1 (08/21/2013)

* Ignore delay job rake task
* Add document to use newrelic-rake without rails

## 1.3.0 (03/24/2013)

* Add a NewRelic::Rake.started to promise starting newrelic agent only
  once.

## 1.2.0 (03/19/2013)

* Force dispatcher to rake.
* Shutdown agent at exit.

## 1.1.0 (03/15/2013)

* Make sure #method_tracer is there by the time we start tracking.
* Add tests.

## 1.0.0 (10/11/2012)

* Initial public release
