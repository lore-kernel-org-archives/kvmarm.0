From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 7/8] KVM: arm/arm64: Avoid accessing GICH registers
Date: Wed, 10 Feb 2016 17:43:54 +0000
Message-ID: <56BB76DA.4080905@arm.com>
References: <1454931622-14902-1-git-send-email-marc.zyngier@arm.com>
 <1454931622-14902-8-git-send-email-marc.zyngier@arm.com>
 <20160210124506.GN5171@cbox> <56BB3C74.9000105@arm.com>
 <20160210173054.GR5171@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160210173054.GR5171@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 10/02/16 17:30, Christoffer Dall wrote:
> On Wed, Feb 10, 2016 at 01:34:44PM +0000, Marc Zyngier wrote:
>> On 10/02/16 12:45, Christoffer Dall wrote:
>>> On Mon, Feb 08, 2016 at 11:40:21AM +0000, Marc Zyngier wrote:
>>>> GICv2 registers are *slow*. As in "terrifyingly slow". Which is bad.
>>>> But we're equaly bad, as we make a point in accessing them even if
>>>> we don't have any interrupt in flight.
>>>>
>>>> A good solution is to first find out if we have anything useful to
>>>> write into the GIC, and if we don't, to simply not do it. This
>>>> involves tracking which LRs actually have something valid there.
>>>>
>>>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>>>> ---
>>>>  arch/arm64/kvm/hyp/vgic-v2-sr.c | 71 ++++++++++++++++++++++++++++-------------
>>>>  include/kvm/arm_vgic.h          |  2 ++
>>>>  2 files changed, 51 insertions(+), 22 deletions(-)
>>>>
>>>> diff --git a/arch/arm64/kvm/hyp/vgic-v2-sr.c b/arch/arm64/kvm/hyp/vgic-v2-sr.c
>>>> index e717612..874a08d 100644
>>>> --- a/arch/arm64/kvm/hyp/vgic-v2-sr.c
>>>> +++ b/arch/arm64/kvm/hyp/vgic-v2-sr.c
>>>> @@ -38,28 +38,40 @@ void __hyp_text __vgic_v2_save_state(struct kvm_vcpu *vcpu)
>>>>  
>>>>  	nr_lr = vcpu->arch.vgic_cpu.nr_lr;
>>>>  	cpu_if->vgic_vmcr = readl_relaxed(base + GICH_VMCR);
>>>> -	cpu_if->vgic_misr = readl_relaxed(base + GICH_MISR);
>>>> -	eisr0  = readl_relaxed(base + GICH_EISR0);
>>>> -	elrsr0 = readl_relaxed(base + GICH_ELRSR0);
>>>> -	if (unlikely(nr_lr > 32)) {
>>>> -		eisr1  = readl_relaxed(base + GICH_EISR1);
>>>> -		elrsr1 = readl_relaxed(base + GICH_ELRSR1);
>>>> -	} else {
>>>> -		eisr1 = elrsr1 = 0;
>>>> -	}
>>>> +
>>>> +	if (vcpu->arch.vgic_cpu.live_lrs) {
>>>> +		eisr0  = readl_relaxed(base + GICH_EISR0);
>>>> +		elrsr0 = readl_relaxed(base + GICH_ELRSR0);
>>>> +		cpu_if->vgic_misr = readl_relaxed(base + GICH_MISR);
>>>> +		cpu_if->vgic_apr    = readl_relaxed(base + GICH_APR);
>>>> +
>>>> +		if (unlikely(nr_lr > 32)) {
>>>> +			eisr1  = readl_relaxed(base + GICH_EISR1);
>>>> +			elrsr1 = readl_relaxed(base + GICH_ELRSR1);
>>>> +		} else {
>>>> +			eisr1 = elrsr1 = 0;
>>>> +		}
>>>> +
>>>>  #ifdef CONFIG_CPU_BIG_ENDIAN
>>>> -	cpu_if->vgic_eisr  = ((u64)eisr0 << 32) | eisr1;
>>>> -	cpu_if->vgic_elrsr = ((u64)elrsr0 << 32) | elrsr1;
>>>> +		cpu_if->vgic_eisr  = ((u64)eisr0 << 32) | eisr1;
>>>> +		cpu_if->vgic_elrsr = ((u64)elrsr0 << 32) | elrsr1;
>>>>  #else
>>>> -	cpu_if->vgic_eisr  = ((u64)eisr1 << 32) | eisr0;
>>>> -	cpu_if->vgic_elrsr = ((u64)elrsr1 << 32) | elrsr0;
>>>> +		cpu_if->vgic_eisr  = ((u64)eisr1 << 32) | eisr0;
>>>> +		cpu_if->vgic_elrsr = ((u64)elrsr1 << 32) | elrsr0;
>>>>  #endif
>>>> -	cpu_if->vgic_apr    = readl_relaxed(base + GICH_APR);
>>>>  
>>>> -	writel_relaxed(0, base + GICH_HCR);
>>>> +		for (i = 0; i < nr_lr; i++)
>>>> +			if (vcpu->arch.vgic_cpu.live_lrs & (1UL << i))
>>>> +				cpu_if->vgic_lr[i] = readl_relaxed(base + GICH_LR0 + (i * 4));
>>>>  
>>>> -	for (i = 0; i < nr_lr; i++)
>>>> -		cpu_if->vgic_lr[i] = readl_relaxed(base + GICH_LR0 + (i * 4));
>>>> +		writel_relaxed(0, base + GICH_HCR);
>>>> +
>>>> +		vcpu->arch.vgic_cpu.live_lrs = 0;
>>>> +	} else {
>>>> +		cpu_if->vgic_eisr = 0;
>>>> +		cpu_if->vgic_elrsr = ~0UL;
>>>> +		cpu_if->vgic_misr = 0;
>>>> +	}
>>>>  }
>>>>  
>>>>  /* vcpu is already in the HYP VA space */
>>>> @@ -70,15 +82,30 @@ void __hyp_text __vgic_v2_restore_state(struct kvm_vcpu *vcpu)
>>>>  	struct vgic_dist *vgic = &kvm->arch.vgic;
>>>>  	void __iomem *base = kern_hyp_va(vgic->vctrl_base);
>>>>  	int i, nr_lr;
>>>> +	u64 live_lrs = 0;
>>>>  
>>>>  	if (!base)
>>>>  		return;
>>>>  
>>>> -	writel_relaxed(cpu_if->vgic_hcr, base + GICH_HCR);
>>>> -	writel_relaxed(cpu_if->vgic_vmcr, base + GICH_VMCR);
>>>> -	writel_relaxed(cpu_if->vgic_apr, base + GICH_APR);
>>>> -
>>>>  	nr_lr = vcpu->arch.vgic_cpu.nr_lr;
>>>> +
>>>>  	for (i = 0; i < nr_lr; i++)
>>>> -		writel_relaxed(cpu_if->vgic_lr[i], base + GICH_LR0 + (i * 4));
>>>> +		if (cpu_if->vgic_lr[i] & GICH_LR_STATE)
>>>> +			live_lrs |= 1UL << i;
>>>> +
>>>> +	if (live_lrs) {
>>>> +		writel_relaxed(cpu_if->vgic_hcr, base + GICH_HCR);
>>>> +		writel_relaxed(cpu_if->vgic_apr, base + GICH_APR);
>>>> +		for (i = 0; i < nr_lr; i++) {
>>>> +			u32 val = 0;
>>>> +
>>>> +			if (live_lrs & (1UL << i))
>>>> +				val = cpu_if->vgic_lr[i];
>>>> +
>>>> +			writel_relaxed(val, base + GICH_LR0 + (i * 4));
>>>> +		}
>>>> +	}
>>>> +
>>>> +	writel_relaxed(cpu_if->vgic_vmcr, base + GICH_VMCR);
>>>
>>> couldn't you optimize this out by storing the last read value and
>>> compare if anything changed?  (you'd have to invalidate the cached value
>>> on vcpu_put obviously).
>>
>> Yeah, very good point. Only the guest can update this, so we could even
>> move it to vcpu_load/vcpu_put entirely, and never save/restore it inside
>> the run loop.
> 
> If vcpu_load is called *after* loading incoming state on migration, this
> should work, yes.

Hmmm. That could be an issue, actually. I need to check if we do a
vcpu_load on SET_ONE_REG access. If we do, then vcpu_put will overwrite
the value we've written in the shadow copies by reading back the old
value from the HW.

I'll investigate when I get the time.

>>
>> I'll keep that for a further patch, as it requires a bit of infrastructure.
>>
> Sounds good.
> 
> We can probably also optimize the writing of the LRs further, but I
> figure it's not worth it as the interrupt delivery path is the slow path
> anyway and we should care about optimizing the common case.
> 
> I wouldn't think saving 2-3 writes to some LRs would be measurable for
> interrupt delivery anyhow.

I found out that some other simple optimizations did save about 800
cycles for a single interrupt injection, which is about 10% of the
complete exit/enter path.

Guilty ones are the maintenance interrupt status registers (MISR, EISR),
and zeroing of LRs. That's with GICv2 though, and GICv3 seems less
sensitive to that kind of thing...

But I agree with you: this is a fairly slow path overall, and we'll
quickly approach the point of diminishing returns.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
