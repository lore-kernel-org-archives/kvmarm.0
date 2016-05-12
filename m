From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 27/55] KVM: arm/arm64: vgic-new: Add PRIORITY registers
 handlers
Date: Thu, 12 May 2016 10:10:33 +0100
Message-ID: <57344889.1050802@arm.com>
References: <1462531568-9799-1-git-send-email-andre.przywara@arm.com>
 <1462531568-9799-28-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1462531568-9799-28-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 06/05/16 11:45, Andre Przywara wrote:
> The priority register handlers are shared between the v2 and v3
> emulation, so their implementation goes into vgic-mmio.c, to be
> easily referenced from the v3 emulation as well later.
> There is a corner case when we change the priority of a pending
> interrupt which we don't handle at the moment.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
> Changelog v1 .. v2:
> - adapt to new MMIO framework
> 
>  virt/kvm/arm/vgic/vgic-mmio-v2.c |  2 +-
>  virt/kvm/arm/vgic/vgic-mmio.c    | 39 +++++++++++++++++++++++++++++++++++++++
>  virt/kvm/arm/vgic/vgic-mmio.h    |  7 +++++++
>  3 files changed, 47 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
> index 054b52d..2e17250 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
> @@ -84,7 +84,7 @@ static const struct vgic_register_region vgic_v2_dist_registers[] = {
>  	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ACTIVE_CLEAR,
>  		vgic_mmio_read_active, vgic_mmio_write_cactive, 1),
>  	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_PRI,
> -		vgic_mmio_read_raz, vgic_mmio_write_wi, 8),
> +		vgic_mmio_read_priority, vgic_mmio_write_priority, 8),
>  	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_TARGET,
>  		vgic_mmio_read_raz, vgic_mmio_write_wi, 8),
>  	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_CONFIG,
> diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
> index dbf683e..d7fe9e6 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio.c
> @@ -282,6 +282,45 @@ retry:
>  	}
>  }
>  
> +unsigned long vgic_mmio_read_priority(struct kvm_vcpu *vcpu,
> +				      gpa_t addr, unsigned int len)
> +{
> +	u32 intid = addr & 0x3ff;
> +	int i;
> +	u64 val = 0;
> +
> +	for (i = 0; i < len; i++) {
> +		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
> +
> +		val |= (u64)irq->priority << (i * 8);
> +	}
> +
> +	return val;
> +}
> +
> +/*
> + * We currently don't handle changing the priority of an interrupt that
> + * is already pending on a VCPU. If there is a need for this, we would
> + * need to make this VCPU exit and re-evaluate the priorities, potentially
> + * leading to this interrupt getting presented now to the guest (if it has
> + * been masked by the priority mask before).
> + */
> +void vgic_mmio_write_priority(struct kvm_vcpu *vcpu,
> +			      gpa_t addr, unsigned int len,
> +			      unsigned long val)
> +{
> +	u32 intid = addr & 0x3ff;
> +	int i;
> +
> +	for (i = 0; i < len; i++) {
> +		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
> +
> +		spin_lock(&irq->irq_lock);
> +		irq->priority = (val >> (i * 8)) & 0xff;

This is wrong. We should only write the number of bits of priority we
actually emulate. And given that we use a common framework for v2 and
v3, this should probably be 5 bits (32 priorities should be enough for
everybody).

I'll try and cook something.

	M.
-- 
Jazz is not dead. It just smells funny...
