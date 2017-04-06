From: Xie XiuQi <xiexiuqi@huawei.com>
Subject: Re: [PATCH v3 4/8] APEI: GHES: reserve a virtual page for SEI context
Date: Thu, 6 Apr 2017 17:25:32 +0800
Message-ID: <9feb4506-5038-ce43-f0e5-0c5c279abc41@huawei.com>
References: <1490869877-118713-1-git-send-email-xiexiuqi@huawei.com>
 <1490869877-118713-5-git-send-email-xiexiuqi@huawei.com>
 <58DE8252.7070709@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <58DE8252.7070709@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: James Morse <james.morse@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, wuquanming@huawei.com, kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, rostedt@goodmis.org, gengdongjiu@huawei.com, wangxiongfeng2@huawei.com, linux-acpi@vger.kernel.org, christoffer.dall@linaro.org, shiju.jose@huawei.com, zhengqiang10@huawei.com, kvmarm@lists.cs.columbia.edu, fu.wei@linaro.org, hanjun.guo@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi James,

Thanks for your comments.

On 2017/4/1 0:22, James Morse wrote:
> Hi Xie XiuQi,
> 
> On 30/03/17 11:31, Xie XiuQi wrote:
>> On arm64 platform, SEI may interrupt code which had interrupts masked.
>> But SEI could be masked, so it's not treated as NMI, however SEA is
>> treated as NMI.
>>
>> So, the  memory area used to transfer hardware error information from
>> BIOS to Linux can be determined only in NMI, SEI(arm64), IRQ or timer
>> handler.
>>
>> In this patch, we add a virtual page for SEI context.
> 
> I don't think this is the best way of solving the interaction problem. If we
> ever need to add another notification method this gets even more complicated,
> and the ioremap code has to know how these methods can interact.
> 
> 
>> diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
>> index 045d101..b1f9b1f 100644
>> --- a/drivers/acpi/apei/ghes.c
>> +++ b/drivers/acpi/apei/ghes.c
>> @@ -155,54 +162,55 @@ static void ghes_ioremap_exit(void)
> 
>> -static void __iomem *ghes_ioremap_pfn_irq(u64 pfn)
>> -{
>> -	unsigned long vaddr, paddr;
>> -	pgprot_t prot;
>> -
>> -	vaddr = (unsigned long)GHES_IOREMAP_IRQ_PAGE(ghes_ioremap_area->addr);
>> +	if (in_nmi()) {
>> +		raw_spin_lock(&ghes_ioremap_lock_nmi);
>> +		vaddr = (unsigned long)GHES_IOREMAP_NMI_PAGE(ghes_ioremap_area->addr);
>> +	} else if (this_cpu_read(sei_in_process)) {
> 
>> +		spin_lock_irqsave(&ghes_ioremap_lock_sei, flags);
> 
> I think this one should be a raw_spin_lock. I'm pretty sure this is for RT-linux
> where spin_lock() on a contented lock will call schedule() in the same way
> mutex_lock() does. If interrupts were masked by arch code then you need to use
> raw_spin_lock.
> So now we need to know how we got in here, we interrupted the SError handler so
> this should only be Synchronous External Abort. Having to know how we got here
> is another problem with this approach.
> 
> 
> As suggested earlier[0], I think the best way is to allocate one page of virtual
> address space per struct ghes, and move the locks out to the notify calls, which
> can know how they are called.
> 
> I've pushed a branch to:
> http://www.linux-arm.org/git?p=linux-jm.git;a=commit;h=refs/heads/apei_ioremap_rework/v1
> 

Good! I could rebase on your patch next time.

> I intend to post those patches as an RFC series later in the cycle, I've only
> build tested it so far.
> 
> 
> Thanks,
> 
> James
> 
>> +		vaddr = (unsigned long)GHES_IOREMAP_SEI_PAGE(ghes_ioremap_area->addr);
>> +	} else {
>> +		spin_lock_irqsave(&ghes_ioremap_lock_irq, flags);
>> +		vaddr = (unsigned long)GHES_IOREMAP_IRQ_PAGE(ghes_ioremap_area->addr);
>> +	}
> 
> 
> [0] https://lkml.org/lkml/2017/3/20/434
> 
> 
> .
> 

-- 
Thanks,
Xie XiuQi
