From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 17/55] KVM: arm/arm64: vgic-new: Add IRQ sync/flush
 framework
Date: Thu, 12 May 2016 13:46:51 +0200
Message-ID: <20160512114651.GB2370@cbox>
References: <1462531568-9799-1-git-send-email-andre.przywara@arm.com>
 <1462531568-9799-18-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1462531568-9799-18-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, May 06, 2016 at 11:45:30AM +0100, Andre Przywara wrote:
> From: Marc Zyngier <marc.zyngier@arm.com>
> 
> Implement the framework for syncing IRQs between our emulation and
> the list registers, which represent the guest's view of IRQs.
> This is done in kvm_vgic_flush_hwstate and kvm_vgic_sync_hwstate,
> which gets called on guest entry and exit.
> The code talking to the actual GICv2/v3 hardware is added in the
> following patches.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---

[...]

> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
> index 4fb20fd..c6f8b9b 100644
> --- a/virt/kvm/arm/vgic/vgic.c
> +++ b/virt/kvm/arm/vgic/vgic.c

[...]

> +
> +/* Requires the VCPU's ap_list_lock to be held. */
> +static void vgic_flush_lr_state(struct kvm_vcpu *vcpu)
> +{
> +	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
> +	struct vgic_irq *irq;
> +	int count = 0;
> +
> +	DEBUG_SPINLOCK_BUG_ON(!spin_is_locked(&vgic_cpu->ap_list_lock));
> +
> +	if (unlikely(!vcpu->kvm->arch.vgic.enabled))
> +		goto out_clean;


I know I said I reviewed this, but thinking about this more carefully,
doesn't the enable bit actually tell us if forwarding of pending
interrupts is enabled, but not whether or not the vgic exists?

So you could imagine a guest that turns off the GIC, but still has
active interrupts that it wants to disable/EOI, in the case of
shutdown/reboot for example, or is this architecturally not allowed?

If it is, then we should, at least theoretically, still forward active
interrupts in LRs despite the enabled bit being clear, but modify the
oracle to take the global enable bit into account.

Thanks,
-Christoffer

> +
> +	if (compute_ap_list_depth(vcpu) > kvm_vgic_global_state.nr_lr) {
> +		vgic_set_underflow(vcpu);
> +		vgic_sort_ap_list(vcpu);
> +	}
> +
> +	list_for_each_entry(irq, &vgic_cpu->ap_list_head, ap_list) {
> +		spin_lock(&irq->irq_lock);
> +
> +		if (unlikely(vgic_target_oracle(irq) != vcpu))
> +			goto next;
> +
> +		/*
> +		 * If we get an SGI with multiple sources, try to get
> +		 * them in all at once.
> +		 */
> +		do {
> +			vgic_populate_lr(vcpu, irq, count++);
> +		} while (irq->source && count < kvm_vgic_global_state.nr_lr);
> +
> +next:
> +		spin_unlock(&irq->irq_lock);
> +
> +		if (count == kvm_vgic_global_state.nr_lr)
> +			break;
> +	}
> +
> +out_clean:
> +	vcpu->arch.vgic_cpu.used_lrs = count;
> +
> +	/* Nuke remaining LRs */
> +	for ( ; count < kvm_vgic_global_state.nr_lr; count++)
> +		vgic_clear_lr(vcpu, count);
> +}
> +
