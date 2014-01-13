#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

# Emits Git metadata for use in a Zsh prompt.
#
# AUTHOR:
#    Ben Hoskings
#   https://github.com/benhoskings/dot-files/blob/master/files/bin/git_cwd_info
#
# MODIFIED:
#    Geoffrey Grosenbach http://peepcode.com
#    Michael Kessler http://www.netzpiraten.ch

# The methods that get called more than once are memoized.

def git_repo_path
  @git_repo_path ||= `git rev-parse --git-dir 2>/dev/null`.strip
end

def in_git_repo
  !git_repo_path.empty? &&
  git_repo_path != '~' &&
  git_repo_path != "#{ENV['HOME']}/.git"
end

def git_parse_branch
  @git_parse_branch ||= `~/.bin/git-current-branch`.chomp
end

def git_head_commit_id
  `git rev-parse --short HEAD 2>/dev/null`.strip
end

def git_cwd_dirty
  "%{\e[33m%}✗%{\e[0m%}" unless git_repo_path == '.' || `git ls-files -m`.strip.empty?
end

def git_cwd_untracked
  "%{\e[32m%}✚%{\e[0m%}" unless git_repo_path == '.' || `git ls-files --other --exclude-standard`.strip.empty?
end

def git_cwd_removed
  "%{\e[31m%}−%{\e[0m%}" unless git_repo_path == '.' || `git ls-files -d`.strip.empty?
end

def rebasing_etc
  if File.exists?(File.join(git_repo_path, 'BISECT_LOG'))
    "%{\e[31m%}+bisect%{\e[0m%}"
  elsif File.exists?(File.join(git_repo_path, 'MERGE_HEAD'))
    "%{\e[31m%}+merge%{\e[0m%}"
  elsif %w[rebase rebase-apply rebase-merge ../.dotest].any? {|d| File.exists?(File.join(git_repo_path, d)) }
    "%{\e[31m%}+rebase%{\e[0m%}"
  end
end

if in_git_repo
  print "%{\e[33m%}#{git_parse_branch} %{\e[0m%}#{git_head_commit_id}%{\e[31m%}#{rebasing_etc} #{git_cwd_dirty}#{git_cwd_untracked}#{git_cwd_removed} "
end
