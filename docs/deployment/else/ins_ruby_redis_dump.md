# 安装ruby-2.6和redis-dump

---

> 系统：CentOS 7.6



```sh
# 1. 安装ruby-install
wget https://github.com/postmodern/ruby-install/archive/v0.7.0.tar.gz
tar -xf v0.7.0.tar.gz
cd ruby-install-0.7.0/
make install

# 安装ruby
ruby-install ruby

# 安装redis-dump
gem install redis-dump

# ln -s /opt/rubies/ruby-2.6.3/bin/* /usr/bin/
export PATH=/opt/rubies/ruby-2.6.3/bin:$PATH
```

