From: wanghaibin <wanghaibin.wang@huawei.com>
Subject: Re: [PATCH] kvm: arm/arm64: vgic: Fix the sequence principle about
 vgic save/restore.
Date: Tue, 6 Jun 2017 11:23:19 +0800
Message-ID: <59362027.4020302@huawei.com>
References: <1496658604-20036-1-git-send-email-wanghaibin.wang@huawei.com>
 <e8c54af6-c774-a37e-a14f-04d422fe5234@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DE95040C49
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Jun 2017 23:21:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ytpfwNL0cLI6 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  5 Jun 2017 23:21:21 -0400 (EDT)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B2F2D40962
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Jun 2017 23:21:20 -0400 (EDT)
In-Reply-To: <e8c54af6-c774-a37e-a14f-04d422fe5234@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: cdall@linaro.org, kvmarm@lists.cs.columbia.edu, wu.wubin@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On 2017/6/5 21:56, Marc Zyngier wrote:

> On 05/06/17 11:30, wanghaibin wrote:
>> At present, take GICv3 as as an example, our implementation is that, the operation
>> of the recovery ICH_HCR register is prior to the recovery of ICH_LRn registers in vgic
>> state restore. Thus, the ICH_LRn registers are 0, and if ICH_HCR.UIE is configured to 1,
>> a large number of unnecessary maintenance interrupts will be triggered.
> 
> Is that a theoretical problem? Or something you've actually observed?


I observed this problem with that boot a android vm (with 4 vcpus) on my hisilicon D03 board (4 LRs support).
Boot the android vm will failed because of any virtual interrupts can't deliver to the vm timely.

I watched the maintenance interrupt (/proc/interrupts, GICv3 hwirq:25), and the number can up to 200000+ per second.
(sorry for my express fault, the large number of unnecessary maintenance interrupts means this).

> 
> At the point where we restore the vgic state, interrupts are disabled.
> And by the time we enter the guest, we fully expect the HW to be in a
> stable state, and no spurious interrupt would be delivered.


At that point where restore the vgic state,  it's true that interrupts are disabled (local_irq_disable),
but in my opinion, here maybe a maintenance interrupt pending at physical redist (at that point it can be delivered).
and it will be delivered at the moment that current vcpu's ctxt restore and entry (eret, here, PSTATE.I maybe unmask).
Thus, the vcpu will be kicked out immediately. At the next vgic state restore point, go round and begin again.

Thanks.

> 
> I also dispute the "large number of unnecessary maintenance interrupts".
> This large number is at most *one*.
> 
> Or am I missing something obvious?



> 
> Thanks,
> 
> 	M.
