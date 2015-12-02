From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: Re: [PATCH v4 18/21] KVM: ARM64: Add PMU overflow interrupt routing
Date: Wed, 2 Dec 2015 17:49:23 +0800
Message-ID: <565EBEA3.8080500@huawei.com>
References: <1446186123-11548-1-git-send-email-zhaoshenglong@huawei.com>	<1446186123-11548-19-git-send-email-zhaoshenglong@huawei.com>
 <20151130182258.684c9df6@arm.com> <565DB021.3020901@huawei.com>
 <565DB3A5.3030701@arm.com> <565DB935.5040609@linaro.org>
 <565DBF8D.1070006@arm.com> <565DCA24.7000908@linaro.org>
 <565DD17A.50009@arm.com> <565E5A13.2080706@huawei.com>
 <565EAFC4.2040301@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2108C49630
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Dec 2015 04:52:12 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oB78mrNr2cRN for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Dec 2015 04:52:10 -0500 (EST)
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [119.145.14.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5FE0A48532
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Dec 2015 04:52:08 -0500 (EST)
In-Reply-To: <565EAFC4.2040301@arm.com>
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
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, will.deacon@arm.com, Shannon Zhao <shannon.zhao@linaro.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu



On 2015/12/2 16:45, Marc Zyngier wrote:
> On 02/12/15 02:40, Shannon Zhao wrote:
>> > 
>> > 
>> > On 2015/12/2 0:57, Marc Zyngier wrote:
>>> >> On 01/12/15 16:26, Shannon Zhao wrote:
>>>> >>>
>>>> >>>
>>>> >>> On 2015/12/1 23:41, Marc Zyngier wrote:
>>>>>> >>>>> The reason is that when guest clear the overflow register, it will trap
>>>>>>> >>>>>> to kvm and call kvm_pmu_sync_hwstate() as you see above. At this moment,
>>>>>>> >>>>>> the overflow register is still overflowed(that is some bit is still 1).
>>>>>>> >>>>>> So We need to use some flag to mark we already inject this interrupt.
>>>>>>> >>>>>> And if during guest handling the overflow, there is a new overflow
>>>>>>> >>>>>> happening, the pmu->irq_pending will be set ture by
>>>>>>> >>>>>> kvm_pmu_perf_overflow(), then it needs to inject this new interrupt, right?
>>>>> >>>> I don't think so. This is a level interrupt, so the level should stay
>>>>> >>>> high as long as the guest hasn't cleared all possible sources for that
>>>>> >>>> interrupt.
>>>>> >>>>
>>>>> >>>> For your example, the guest writes to PMOVSCLR to clear the overflow
>>>>> >>>> caused by a given counter. If the status is now 0, the interrupt line
>>>>> >>>> drops. If the status is still non zero, the line stays high. And I
>>>>> >>>> believe that writing a 1 to PMOVSSET would actually trigger an
>>>>> >>>> interrupt, or keep it high if it has already high.
>>>>> >>>>
>>>> >>> Right, writing 1 to PMOVSSET will trigger an interrupt.
>>>> >>>
>>>>> >>>> In essence, do not try to maintain side state. I've been bitten.
>>>> >>>
>>>> >>> So on VM entry, it check if PMOVSSET is zero. If not, call 
>>>> >>> kvm_vgic_inject_irq to set the level high. If so, set the level low.
>>>> >>> On VM exit, it seems there is nothing to do.
>>> >>
>>> >> It is even simpler than that:
>>> >>
>>> >> - When you get an overflow, you inject an interrupt with the level set to 1.
>>> >> - When the overflow register gets cleared, you inject the same interrupt
>>> >> with the level set to 0.
>>> >>
>>> >> I don't think you need to do anything else, and the world switch should
>>> >> be left untouched.
>>> >>
>> > 
>> > On 2015/7/17 23:28, Christoffer Dall wrote:>> > +		
>> > kvm_vgic_inject_irq(vcpu->kvm, vcpu->vcpu_id,
>>>>> >>>> +					    pmu->irq_num, 1);
>>> >> what context is this overflow handler function?  kvm_vgic_inject_irq
>>> >> grabs a mutex, so it can sleep...
>>> >>
>>> >> from a quick glance at the perf core code, it looks like this is in
>>> >> interrupt context, so that call to kvm_vgic_inject_irq looks bad.
>>> >>
>> > 
>> > But as Christoffer said before, it's not good to call
>> > kvm_vgic_inject_irq directly in interrupt context. So if we just kick
>> > the vcpu here and call kvm_vgic_inject_irq on VM entry, is this fine?
> Possibly. I'm slightly worried that inject_irq itself is going to kick
> the vcpu again for no good reason. 
Yes, this will introduce a extra kick. What's the impact of kicking a
kicked vcpu?

> I guess we'll find out (and maybe
> we'll add a kvm_vgic_inject_irq_no_kick_please() helper...).
And add a parameter "bool kick" for vgic_update_irq_pending ?

-- 
Shannon
