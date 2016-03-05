手动制作gem并且使用rspec进行单元测试

1.使用bundle gem 创建脚手架
junjunlocal:projects Admin$ bundle gem mygem
Creating gem 'mygem'...
Code of conduct enabled in config
MIT License enabled in config
      create  mygem/Gemfile
      create  mygem/.gitignore
      create  mygem/lib/mygem.rb
      create  mygem/lib/mygem/version.rb
      create  mygem/mygem.gemspec
      create  mygem/Rakefile
      create  mygem/README.md
      create  mygem/bin/console
      create  mygem/bin/setup
      create  mygem/CODE_OF_CONDUCT.md
      create  mygem/LICENSE.txt
      create  mygem/.travis.yml
Initializing git repo in /User/junjun/projects/mygem

2.在lib/mygem/目录中添加我们的业务逻辑类Caculator,并且修改lib/mygem.rb
junjunlocal:mygem Admin$ tree 
.
├── CODE_OF_CONDUCT.md
├── Gemfile
├── LICENSE.txt
├── README.md
├── Rakefile
├── bin
│   ├── console
│   └── setup
├── lib
│   ├── mygem
│   │   ├── caculator.rb
│   │   └── version.rb
│   └── mygem.rb
└── mygem.gemspec

3 directories, 11 files

#caculator.rb
module Mygem
 class Caculator
    def self.add(n1,n2)
       n1 + n2
    end
 end
end

#lib/mygem.rb
require "mygem/version"
require "mygem/caculator.rb"

module Mygem
  # Your code goes here...
end

~        

3.修改 mygem/mygem.gemspec,添加rspec用于测试，添加依赖库fileutils
# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mygem/version'

Gem::Specification.new do |spec|
  spec.name          = "mygem"
  spec.version       = Mygem::VERSION
  spec.authors       = ["andy"]
  spec.email         = ["lalala@yahoo.com.cn"]

  spec.summary       = %q{手动创建gem demo}
  spec.description   = %q{手动创建gem demo}
  spec.homepage      = "http://coder.com"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  #添加依赖的库gem install 的时会自动去下载依赖 
  spec.add_dependency 'fileutils'

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  
  #添加rspec 用于写单元测试 
  spec.add_development_dependency "rspec", "~> 3.2"
  
end

4.单元测试,添加spec/caculator_spec.rb测试文件
junjunlocal:mygem Admin$ tree
.
├── CODE_OF_CONDUCT.md
├── Gemfile
├── LICENSE.txt
├── README.md
├── Rakefile
├── bin
│   ├── console
│   └── setup
├── lib
│   ├── mygem
│   │   ├── caculator.rb
│   │   └── version.rb
│   └── mygem.rb
├── mygem.gemspec
└── spec
    └── caculator_spec.rb

4 directories, 12 files


spec/caculator_spec.rb 内容:
#encoding:utf-8
#测试代码

require 'Mygem'

describe Mygem::Caculator do
      n1 = 10
      n2 = 11

      #这个测试会成功
      it  "test add : #{n1+n2}" do
        ret = Mygem::Caculator.add(n1,n2)
        expect(ret).to eql(n1+n2)
      end

      #这个测试用例会fail
      it  "test add : #{n1+n2}" do
        ret = Mygem::Caculator.add(n1,n2)
        expect(ret).to eql(n1+n2+1)
      end
end

5.测试我们的gem,运行bundle install 加载gem依赖的东西
junjunlocal:mygem Admin$ bundle install
Fetching gem metadata from https://ruby.taobao.org/....
Fetching version metadata from https://ruby.taobao.org/..
Resolving dependencies...
Using rake 10.5.0
Using bundler 1.10.5
Using diff-lcs 1.2.5
Installing rmagick 2.15.4 with native extensions
Installing fileutils 0.7
Using mygem 0.1.0 from source at .
Installing rspec-support 3.4.1
Installing rspec-core 3.4.3
Installing rspec-expectations 3.4.0
Installing rspec-mocks 3.4.1
Installing rspec 3.4.0
Bundle complete! 4 Gemfile dependencies, 11 gems now installed.
Use `bundle show [gemname]` to see where a bundled gem is installed.

可以看到 我们依赖的fileutils已经自动安装了,并且mygem也自动包括进来了
 Installing fileutils 0.7
 Using mygem 0.1.0 from source at .


6.运行测试用例 一个通过一个挂掉符合我们的语气
junjunlocal:mygem Admin$ pwd
/User/junjun/projects/mygem
junjunlocal:mygem Admin$ bundle exec rspec  
.F

Failures:

  1) Mygem::Caculator test add : 21
     Failure/Error: expect(ret).to eql(n1+n2+1)

       expected: 22
            got: 21

       (compared using eql?)
     # ./spec/caculator_spec.rb:19:in `block (2 levels) in <top (required)>'

Finished in 0.03537 seconds (files took 0.16785 seconds to load)
2 examples, 1 failure

Failed examples:

rspec ./spec/caculator_spec.rb:17 # Mygem::Caculator test add : 21


7.打gem包
junjunlocal:mygem Admin$ gem build mygem.gemspec 
WARNING:  description and summary are identical
WARNING:  open-ended dependency on fileutils (>= 0) is not recommended
  if fileutils is semantically versioned, use:
    add_runtime_dependency 'fileutils', '~> 0'
WARNING:  See http://guides.rubygems.org/specification-reference/ for help
  Successfully built RubyGem
  Name: mygem
  Version: 0.1.0
  File: mygem-0.1.0.gem

8.在irb中测试gem包
junjunlocal:mygem Admin$ gem install mygem-0.1.0.gem 
Successfully installed mygem-0.1.0
Parsing documentation for mygem-0.1.0
Installing ri documentation for mygem-0.1.0
Done installing documentation for mygem after 0 seconds
1 gem installed
junjunlocal:mygem Admin$ irb 
1.9.3-p545 :001 > require 'mygem'
 => true 
1.9.3-p545 :003 > Mygem::Caculator.add(1,2)
 => 3 
1.9.3-p545 :004 > 













