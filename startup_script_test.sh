#!/bin/sh
redis-server --daemonize yes
npm test; echo $? > exit_code
