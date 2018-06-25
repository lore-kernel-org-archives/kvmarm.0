From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 4/4] KVM: arm/arm64: vgic: Allow VMs to configure
 interrupt groups
Date: Mon, 25 Jun 2018 09:19:07 +0100
Message-ID: <2f5feed6-c026-1871-25e4-943123c8b977@arm.com>
References: <20180624221103.15055-1-christoffer.dall@arm.com>
 <20180624221103.15055-5-christoffer.dall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180624221103.15055-5-christoffer.dall@arm.com>
Content-Language: en-GB
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Christoffer Dall <christoffer.dall@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 24/06/18 23:11, Christoffer Dall wrote:
> Implement the required MMIO accessors for GICv2 and GICv3 for the
> IGROUPR distributor and redistributor registers.
> 
> This can allow guests to change behavior compared to running on previous
> versions of KVM, but only to align with the architecture and hardware
> implementations.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> ---
>  virt/kvm/arm/vgic/vgic-mmio-v2.c |  2 +-
>  virt/kvm/arm/vgic/vgic-mmio-v3.c |  2 +-
>  virt/kvm/arm/vgic/vgic-mmio.c    | 38 ++++++++++++++++++++++++++++++++
>  virt/kvm/arm/vgic/vgic-mmio.h    |  6 +++++
>  4 files changed, 46 insertions(+), 2 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
> index 8d18f89397d3..ff3834d16ac9 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
> @@ -362,7 +362,7 @@ static const struct vgic_register_region vgic_v2_dist_registers[] = {
>  		vgic_mmio_read_v2_misc, vgic_mmio_write_v2_misc, 12,
>  		VGIC_ACCESS_32bit),
>  	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_IGROUP,
> -		vgic_mmio_read_raz, vgic_mmio_write_wi, NULL, NULL, 1,
> +		vgic_mmio_read_group, vgic_mmio_write_group, NULL, NULL, 1,
>  		VGIC_ACCESS_32bit),
>  	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ENABLE_SET,
>  		vgic_mmio_read_enable, vgic_mmio_write_senable, NULL, NULL, 1,
> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> index 287784095b5b..76e422859745 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> @@ -451,7 +451,7 @@ static const struct vgic_register_region vgic_v3_dist_registers[] = {
>  		vgic_mmio_read_rao, vgic_mmio_write_wi, 4,
>  		VGIC_ACCESS_32bit),
>  	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_IGROUPR,
> -		vgic_mmio_read_rao, vgic_mmio_write_wi, NULL, NULL, 1,
> +		vgic_mmio_read_group, vgic_mmio_write_group, NULL, NULL, 1,
>  		VGIC_ACCESS_32bit),
>  	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ISENABLER,
>  		vgic_mmio_read_enable, vgic_mmio_write_senable, NULL, NULL, 1,

I think you're missing the GICR_IGROUPR accessor in the redistributor
(despite mentioning it in the commit message).

> diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
> index ff9655cfeb2f..ae31bd0dd365 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio.c
> @@ -40,6 +40,44 @@ void vgic_mmio_write_wi(struct kvm_vcpu *vcpu, gpa_t addr,
>  	/* Ignore */
>  }
>  
> +unsigned long vgic_mmio_read_group(struct kvm_vcpu *vcpu,
> +				   gpa_t addr, unsigned int len)
> +{
> +	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
> +	u32 value = 0;
> +	int i;
> +
> +	/* Loop over all IRQs affected by this read */
> +	for (i = 0; i < len * 8; i++) {
> +		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
> +
> +		if (irq->group)
> +			value |= BIT(i);
> +
> +		vgic_put_irq(vcpu->kvm, irq);
> +	}
> +
> +	return value;
> +}
> +
> +void vgic_mmio_write_group(struct kvm_vcpu *vcpu, gpa_t addr,
> +			   unsigned int len, unsigned long val)
> +{
> +	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
> +	int i;
> +	unsigned long flags;
> +
> +	for (i = 0; i < len * 8; i++) {
> +		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
> +
> +		spin_lock_irqsave(&irq->irq_lock, flags);
> +		irq->group = !!(val & BIT(i));
> +		vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
> +
> +		vgic_put_irq(vcpu->kvm, irq);
> +	}
> +}
> +
>  /*
>   * Read accesses to both GICD_ICENABLER and GICD_ISENABLER return the value
>   * of the enabled bit, so there is only one function for both here.
> diff --git a/virt/kvm/arm/vgic/vgic-mmio.h b/virt/kvm/arm/vgic/vgic-mmio.h
> index 5693f6df45ec..10798625f9ce 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio.h
> +++ b/virt/kvm/arm/vgic/vgic-mmio.h
> @@ -134,6 +134,12 @@ unsigned long vgic_mmio_read_rao(struct kvm_vcpu *vcpu,
>  void vgic_mmio_write_wi(struct kvm_vcpu *vcpu, gpa_t addr,
>  			unsigned int len, unsigned long val);
>  
> +unsigned long vgic_mmio_read_group(struct kvm_vcpu *vcpu, gpa_t addr,
> +				   unsigned int len);
> +
> +void vgic_mmio_write_group(struct kvm_vcpu *vcpu, gpa_t addr,
> +			   unsigned int len, unsigned long val);
> +
>  unsigned long vgic_mmio_read_enable(struct kvm_vcpu *vcpu,
>  				    gpa_t addr, unsigned int len);
>  
> 

Otherwise looks good.

	M.
-- 
Jazz is not dead. It just smells funny...
