From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v4 18/21] KVM: ARM64: Add PMU overflow interrupt routing
Date: Tue, 01 Dec 2015 16:57:30 +0000
Message-ID: <565DD17A.50009@arm.com>
References: <1446186123-11548-1-git-send-email-zhaoshenglong@huawei.com>	<1446186123-11548-19-git-send-email-zhaoshenglong@huawei.com> <20151130182258.684c9df6@arm.com> <565DB021.3020901@huawei.com> <565DB3A5.3030701@arm.com> <565DB935.5040609@linaro.org> <565DBF8D.1070006@arm.com> <565DCA24.7000908@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <565DCA24.7000908@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Shannon Zhao <shannon.zhao@linaro.org>, Shannon Zhao <zhaoshenglong@huawei.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, christoffer.dall@linaro.org, will.deacon@arm.com, alex.bennee@linaro.org, wei@redhat.com, cov@codeaurora.org, peter.huangpeng@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On 01/12/15 16:26, Shannon Zhao wrote:
> 
> 
> On 2015/12/1 23:41, Marc Zyngier wrote:
>>> The reason is that when guest clear the overflow register, it will trap
>>>> to kvm and call kvm_pmu_sync_hwstate() as you see above. At this moment,
>>>> the overflow register is still overflowed(that is some bit is still 1).
>>>> So We need to use some flag to mark we already inject this interrupt.
>>>> And if during guest handling the overflow, there is a new overflow
>>>> happening, the pmu->irq_pending will be set ture by
>>>> kvm_pmu_perf_overflow(), then it needs to inject this new interrupt, right?
>> I don't think so. This is a level interrupt, so the level should stay
>> high as long as the guest hasn't cleared all possible sources for that
>> interrupt.
>>
>> For your example, the guest writes to PMOVSCLR to clear the overflow
>> caused by a given counter. If the status is now 0, the interrupt line
>> drops. If the status is still non zero, the line stays high. And I
>> believe that writing a 1 to PMOVSSET would actually trigger an
>> interrupt, or keep it high if it has already high.
>>
> Right, writing 1 to PMOVSSET will trigger an interrupt.
> 
>> In essence, do not try to maintain side state. I've been bitten.
> 
> So on VM entry, it check if PMOVSSET is zero. If not, call 
> kvm_vgic_inject_irq to set the level high. If so, set the level low.
> On VM exit, it seems there is nothing to do.

It is even simpler than that:

- When you get an overflow, you inject an interrupt with the level set to 1.
- When the overflow register gets cleared, you inject the same interrupt
with the level set to 0.

I don't think you need to do anything else, and the world switch should
be left untouched.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
