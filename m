From: wanghaibin <wanghaibin.wang@huawei.com>
Subject: Re: [PATCH v2 0/4] kvm: arm/arm64: vgic: APRn uaccess support.
Date: Tue, 8 Aug 2017 21:06:24 +0800
Message-ID: <5989B750.90108@huawei.com>
References: <1500287012-16996-1-git-send-email-wanghaibin.wang@huawei.com>
 <20170721132703.GJ16350@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 76D9D40CE9
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Aug 2017 09:06:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5MH87Sd91i2U for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Aug 2017 09:06:50 -0400 (EDT)
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 241BB49C48
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Aug 2017 09:06:45 -0400 (EDT)
In-Reply-To: <20170721132703.GJ16350@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, wu.wubin@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On 2017/7/21 21:27, Christoffer Dall wrote:

> Hi Wanghaibin,
> 
> On Mon, Jul 17, 2017 at 06:23:28PM +0800, wanghaibin wrote:
>> v2: Split the patch again to make it easier for review
>>     some fixes were proposed by Marc
>>
>> v1: the problem describe:
>> https://lists.cs.columbia.edu/pipermail/kvmarm/2017-July/026295.html
> 
> please also include the same description in the cover letter for future
> revisions of this patch series.  People may not remember the context
> (like me) or others may jump in as reviewers at a later time, and having
> to go back and look at an old posting via a link is not very friendly to
> the review process.
> 


OK, I'll do it next time.

This problem describe as follows:

In the case (GICv2 on GICv3 migration), I did the test on my board as follow:
vm boot => migrate to destination => shutdown at destination => start at destination
=> migrate back to source ... go round and begin again;

I tested many times, but unlucky, there maybe failed by accident when shutdown the vm
at destination. (GICv3 on GICv3 migration, 1000+ times, That's OK).
while failed,  we can watch the interrupts in the vm, some vcpus of the vm can not
receive the virt timer interrupt. And, these vcpus will 100% with top tool at host.

vgic_state debug file at destination shows(a active virt timer interrupt) that:
VCPU 0 TYP   ID TGT_ID PLAEHC     HWID   TARGET SRC PRI VCPU_ID
---------------------------------------------------------------
            ....................
       PPI   25      0 000001        0        1   0 160      -1
       PPI   26      0 000001        0        1   0 160      -1
       PPI   27      0 011111       27        1   0 160       0


I added log to print ICH* registers for VCPU0 at destination:
**HCR:0x1, VMCR:0xf0ec0001,SRE:0x0, ELRSR:0xe**
-----AP0R:0: 0x0------
-----AP0R:1: 0x0------
-----AP0R:2: 0x0------
-----AP0R:3: 0x0------
-----AP1R:0: 0x0------
-----AP1R:1: 0x0------
-----AP1R:2: 0x0------
-----AP1R:3: 0x0------
-----LR:0: 0xa0a0001b0000001b------
-----LR:1: 0x0------
-----LR:2: 0x0------
-----LR:3: 0x0------

and the ICH_AP1R0 value is 0x10000 at source.

At present, QEMU have supproted GICC_APRn put/set interface for emulated GICv2,
and kvm does not support the uaccess interface. This patchset try to support this.

Thanks.

> Thanks,
> -Christoffer
> 
>>
>> wanghaibin (4):
>>   kvm: arm/arm64: vgic: Implement the vGICv2 GICC_APRn uaccess
>>     interface.
>>   kvm: arm/arm64: vgic-v2: Add GICH_APRn accessors for GICv2
>>   kvm: arm/arm64: vgic-v3: add ICH_AP[01]Rn accessors for GICv3
>>   kvm: arm/arm64: vgic: clean up vGICv3 ICC_APRn sysreg uaccess
>>
>>  arch/arm64/kvm/vgic-sys-reg-v3.c | 25 +++++--------------------
>>  virt/kvm/arm/vgic/vgic-mmio-v2.c | 22 ++++++++++++++++++++--
>>  virt/kvm/arm/vgic/vgic-mmio.c    | 28 ++++++++++++++++++++++++++++
>>  virt/kvm/arm/vgic/vgic-v2.c      | 18 ++++++++++++++++++
>>  virt/kvm/arm/vgic/vgic-v3.c      | 20 ++++++++++++++++++++
>>  virt/kvm/arm/vgic/vgic.h         |  7 +++++++
>>  6 files changed, 98 insertions(+), 22 deletions(-)
>>
>> -- 
>> 1.8.3.1
>>
>>
>> _______________________________________________
>> kvmarm mailing list
>> kvmarm@lists.cs.columbia.edu
>> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> 
> .
> 
