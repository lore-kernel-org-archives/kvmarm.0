From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v3 17/55] KVM: arm/arm64: vgic-new: Add IRQ sync/flush
 framework
Date: Thu, 12 May 2016 16:08:31 +0100
Message-ID: <57349C6F.8050406@arm.com>
References: <1462531568-9799-1-git-send-email-andre.przywara@arm.com>
 <1462531568-9799-18-git-send-email-andre.przywara@arm.com>
 <20160512114651.GB2370@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C1E249B1D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 May 2016 11:05:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WpXhcNsfH2qh for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 May 2016 11:05:01 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 24D3D49B1A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 May 2016 11:05:00 -0400 (EDT)
In-Reply-To: <20160512114651.GB2370@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 12/05/16 12:46, Christoffer Dall wrote:
> On Fri, May 06, 2016 at 11:45:30AM +0100, Andre Przywara wrote:
>> From: Marc Zyngier <marc.zyngier@arm.com>
>>
>> Implement the framework for syncing IRQs between our emulation and
>> the list registers, which represent the guest's view of IRQs.
>> This is done in kvm_vgic_flush_hwstate and kvm_vgic_sync_hwstate,
>> which gets called on guest entry and exit.
>> The code talking to the actual GICv2/v3 hardware is added in the
>> following patches.
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
>> Signed-off-by: Eric Auger <eric.auger@linaro.org>
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>> ---
> 
> [...]
> 
>> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
>> index 4fb20fd..c6f8b9b 100644
>> --- a/virt/kvm/arm/vgic/vgic.c
>> +++ b/virt/kvm/arm/vgic/vgic.c
> 
> [...]
> 
>> +
>> +/* Requires the VCPU's ap_list_lock to be held. */
>> +static void vgic_flush_lr_state(struct kvm_vcpu *vcpu)
>> +{
>> +	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
>> +	struct vgic_irq *irq;
>> +	int count = 0;
>> +
>> +	DEBUG_SPINLOCK_BUG_ON(!spin_is_locked(&vgic_cpu->ap_list_lock));
>> +
>> +	if (unlikely(!vcpu->kvm->arch.vgic.enabled))
>> +		goto out_clean;
> 
> 
> I know I said I reviewed this, but thinking about this more carefully,
> doesn't the enable bit actually tell us if forwarding of pending
> interrupts is enabled, but not whether or not the vgic exists?
> 
> So you could imagine a guest that turns off the GIC, but still has
> active interrupts that it wants to disable/EOI, in the case of
> shutdown/reboot for example, or is this architecturally not allowed?

I guess you are right, the spec talks only about GICD.CTLR[Enable]
controlling the forwarding of pending interrupts to the CPU interface.
If you don't want interrupts at all, I guess you disable the CPU interface.

So we just don't put pending IRQs in the LR, but only active ones.
I am coding this right now.

Cheers,
Andre

> 
> If it is, then we should, at least theoretically, still forward active
> interrupts in LRs despite the enabled bit being clear, but modify the
> oracle to take the global enable bit into account.
> 
> Thanks,
> -Christoffer
