#!/bin/bash
cd terraform || exit 1
echo yes | terraform apply
