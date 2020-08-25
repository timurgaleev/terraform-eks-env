#!/usr/bin/groovy
import groovy.transform.Field
@Field
def role = "devops"
@Field
def cluster = "EKS-DEMO"
@Field
def base_domain = "supersite.dot"
@Field
def slack_token = "REPLACEME/REPLACEME/REPLACEME"
@Field
def jenkins = "jenkins.supersite.dot"
@Field
def archiva = "archiva.supersite.dot"
@Field
def chartmuseum = "chartmuseum.supersite.dot"
@Field
def nexus = "nexus.supersite.dot"
@Field
def sonarqube = "sonarqube.supersite.dot"
@Field
def registry = "249565476171.dkr.ecr.eu-central-1.amazonaws.com"
return this