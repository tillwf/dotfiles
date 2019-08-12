#!/usr/bin/env ruby
require "json";

# Change github credentials and organization name
github = {:user => "<username>", :pass => "<pass>", :org => "<org>"}

repos = `curl --user "username:pass" https://api.github.com/orgs/<organization>/repos\?per_page\=200\&type\=private`
for repo in JSON.load(repos)
    puts "\n+++ Starting with " + repo["name"]
    %x[git clone #{repo["ssh_url"]}]
    branches = %x[cd #{repo["name"]} && git branch -r]
    branches = branches.split(/\n/).map{ |branch| branch.split(" ").pop.split("/").pop }.uniq
    default = branches[0]
    branches.each{|branch| puts %x[cd #{repo["name"]} && git checkout #{branch} && git submodule update --init --recursive]}
    # Change to default branch and clone the wiki
    puts %x[cd #{repo["name"]} && git checkout #{default} && git fetch --all && git pull --all && git clone #{repo["ssh_url"].gsub(".git", ".wiki.git")} wiki]
end