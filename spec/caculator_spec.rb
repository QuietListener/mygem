#encoding:utf-8
#测试代码

require 'mygem'

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
