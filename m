From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH v3 08/16] KVM: arm64: handle ITS related GICv3
 redistributor registers
Date: Thu, 22 Oct 2015 18:46:18 +0300
Message-ID: <015d01d10ce0$cb7009a0$62501ce0$@samsung.com>
References: <1444229726-31559-1-git-send-email-andre.przywara@arm.com>
 <1444229726-31559-9-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <1444229726-31559-9-git-send-email-andre.przywara@arm.com>
Content-language: ru
Sender: kvm-owner@vger.kernel.org
To: 'Andre Przywara' <andre.przywara@arm.com>, marc.zyngier@arm.com, christoffer.dall@linaro.org
Cc: eric.auger@linaro.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

 During my work on live migration i found a big bug in your implementation.

> -----Original Message-----
> From: kvm-owner@vger.kernel.org [mailto:kvm-owner@vger.kernel.org] On Behalf Of Andre Przywara
> Sent: Wednesday, October 07, 2015 5:55 PM
> To: marc.zyngier@arm.com; christoffer.dall@linaro.org
> Cc: eric.auger@linaro.org; p.fedin@samsung.com; kvmarm@lists.cs.columbia.edu; linux-arm-
> kernel@lists.infradead.org; kvm@vger.kernel.org
> Subject: [PATCH v3 08/16] KVM: arm64: handle ITS related GICv3 redistributor registers
> 
> In the GICv3 redistributor there are the PENDBASER and PROPBASER
> registers which we did not emulate so far, as they only make sense
> when having an ITS. In preparation for that emulate those MMIO
> accesses by storing the 64-bit data written into it into a variable
> which we later read in the ITS emulation.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
> Changelog v2..v3:
> - rename vgic_handle_base_register to vgic_reg64_access()
> 
>  include/kvm/arm_vgic.h      |  8 ++++++++
>  virt/kvm/arm/vgic-v3-emul.c | 44 ++++++++++++++++++++++++++++++++++++++++++++
>  virt/kvm/arm/vgic.c         | 31 +++++++++++++++++++++++++++++++
>  virt/kvm/arm/vgic.h         |  2 ++
>  4 files changed, 85 insertions(+)
> 
> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index 067ad09..06c33bc 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -272,6 +272,14 @@ struct vgic_dist {
>  	/* Virtual irq to hwirq mapping */
>  	spinlock_t		irq_phys_map_lock;
>  	struct list_head	irq_phys_map_list;
> +
> +	/* Address of LPI configuration table shared by all redistributors */
> +	u64			propbaser;
> +
> +	/* Addresses of LPI pending tables per redistributor */
> +	u64			*pendbaser;
> +
> +	bool			lpis_enabled;
>  };
> 
>  struct vgic_v2_cpu_if {
> diff --git a/virt/kvm/arm/vgic-v3-emul.c b/virt/kvm/arm/vgic-v3-emul.c
> index a8cf669..6939f7c 100644
> --- a/virt/kvm/arm/vgic-v3-emul.c
> +++ b/virt/kvm/arm/vgic-v3-emul.c
> @@ -651,6 +651,38 @@ static bool handle_mmio_cfg_reg_redist(struct kvm_vcpu *vcpu,
>  	return vgic_handle_cfg_reg(reg, mmio, offset);
>  }
> 
> +/* We don't trigger any actions here, just store the register value */
> +static bool handle_mmio_propbaser_redist(struct kvm_vcpu *vcpu,
> +					 struct kvm_exit_mmio *mmio,
> +					 phys_addr_t offset)
> +{
> +	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
> +	int mode = ACCESS_READ_VALUE;
> +
> +	/* Storing a value with LPIs already enabled is undefined */
> +	mode |= dist->lpis_enabled ? ACCESS_WRITE_IGNORED : ACCESS_WRITE_VALUE;
> +	vgic_reg64_access(mmio, offset, &dist->propbaser, mode);
> +
> +	return false;
> +}
> +
> +/* We don't trigger any actions here, just store the register value */
> +static bool handle_mmio_pendbaser_redist(struct kvm_vcpu *vcpu,
> +					 struct kvm_exit_mmio *mmio,
> +					 phys_addr_t offset)
> +{
> +	struct kvm_vcpu *rdvcpu = mmio->private;
> +	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
> +	int mode = ACCESS_READ_VALUE;
> +
> +	/* Storing a value with LPIs already enabled is undefined */
> +	mode |= dist->lpis_enabled ? ACCESS_WRITE_IGNORED : ACCESS_WRITE_VALUE;

 Here you store lpis_enabled globally, and this is plain wrong.

 Linux kernel separately programs PENDBASER and enables LPIs on every CPU. Therefore, after CPU #0 is initialized (this happens much
earlier than everything else), dist->lpis_enabled is set to true, and subsequent PROPBASER writes, even for different
redistributors, will be ignored. As a result, you'll get dist->pendbaser[n] == NULL forever, where n > 0. And your
its_sync_lpi_pending_table() actually reads some garbage from physical address 0 of the guest.

 Attempts to write data to that region silently corrupts random qemu data during migration, that's how i discovered it.

> +	vgic_reg64_access(mmio, offset,
> +			  &dist->pendbaser[rdvcpu->vcpu_id], mode);
> +
> +	return false;
> +}
> +
>  #define SGI_base(x) ((x) + SZ_64K)
> 
>  static const struct vgic_io_range vgic_redist_ranges[] = {
> @@ -679,6 +711,18 @@ static const struct vgic_io_range vgic_redist_ranges[] = {
>  		.handle_mmio    = handle_mmio_raz_wi,
>  	},
>  	{
> +		.base		= GICR_PENDBASER,
> +		.len		= 0x08,
> +		.bits_per_irq	= 0,
> +		.handle_mmio	= handle_mmio_pendbaser_redist,
> +	},
> +	{
> +		.base		= GICR_PROPBASER,
> +		.len		= 0x08,
> +		.bits_per_irq	= 0,
> +		.handle_mmio	= handle_mmio_propbaser_redist,
> +	},
> +	{
>  		.base           = GICR_IDREGS,
>  		.len            = 0x30,
>  		.bits_per_irq   = 0,
> diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
> index 4219f22..11bf692 100644
> --- a/virt/kvm/arm/vgic.c
> +++ b/virt/kvm/arm/vgic.c
> @@ -471,6 +471,37 @@ void vgic_reg_access(struct kvm_exit_mmio *mmio, u32 *reg,
>  	}
>  }
> 
> +/* handle a 64-bit register access */
> +void vgic_reg64_access(struct kvm_exit_mmio *mmio, phys_addr_t offset,
> +		       u64 *basereg, int mode)
> +{
> +	u32 reg;
> +	u64 breg;
> +
> +	switch (offset & ~3) {
> +	case 0x00:
> +		breg = *basereg;
> +		reg = lower_32_bits(breg);
> +		vgic_reg_access(mmio, &reg, offset & 3, mode);
> +		if (mmio->is_write && (mode & ACCESS_WRITE_VALUE)) {
> +			breg &= GENMASK_ULL(63, 32);
> +			breg |= reg;
> +			*basereg = breg;
> +		}
> +		break;
> +	case 0x04:
> +		breg = *basereg;
> +		reg = upper_32_bits(breg);
> +		vgic_reg_access(mmio, &reg, offset & 3, mode);
> +		if (mmio->is_write && (mode & ACCESS_WRITE_VALUE)) {
> +			breg  = lower_32_bits(breg);
> +			breg |= (u64)reg << 32;
> +			*basereg = breg;
> +		}
> +		break;
> +	}
> +}
> +
>  bool handle_mmio_raz_wi(struct kvm_vcpu *vcpu, struct kvm_exit_mmio *mmio,
>  			phys_addr_t offset)
>  {
> diff --git a/virt/kvm/arm/vgic.h b/virt/kvm/arm/vgic.h
> index a093f5c..104f780 100644
> --- a/virt/kvm/arm/vgic.h
> +++ b/virt/kvm/arm/vgic.h
> @@ -71,6 +71,8 @@ void vgic_reg_access(struct kvm_exit_mmio *mmio, u32 *reg,
>  		     phys_addr_t offset, int mode);
>  bool handle_mmio_raz_wi(struct kvm_vcpu *vcpu, struct kvm_exit_mmio *mmio,
>  			phys_addr_t offset);
> +void vgic_reg64_access(struct kvm_exit_mmio *mmio, phys_addr_t offset,
> +		       u64 *basereg, int mode);
> 
>  static inline
>  u32 mmio_data_read(struct kvm_exit_mmio *mmio, u32 mask)
> --
> 2.5.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia


