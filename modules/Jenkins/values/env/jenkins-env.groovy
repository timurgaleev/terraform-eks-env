#!/usr/bin/groovy
import groovy.transform.Field
@Field
def role = "devops"
@Field
def cluster = "EKS-DEMO"
@Field
def base_domain = "timzu.com"
@Field
def slack_token = "REPLACEME/REPLACEME/REPLACEME"
@Field
def jenkins = "jenkins.timzu.com"
@Field
def archiva = "archiva.timzu.com"
@Field
def chartmuseum = "chartmuseum.timzu.com"
@Field
def nexus = "nexus.timzu.com"
@Field
def sonarqube = "sonarqube.timzu.com"
@Field
def registry = "249565476171.dkr.ecr.eu-central-1.amazonaws.com"
return this