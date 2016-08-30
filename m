From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC PATCH v3 1/5] arm/arm64: vgic-new: Implement support for
 userspace access
Date: Tue, 30 Aug 2016 12:50:25 +0200
Message-ID: <20160830105025.GG10162@cbox>
References: <1472037609-4164-1-git-send-email-vijay.kilari@gmail.com>
 <1472037609-4164-2-git-send-email-vijay.kilari@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0BE6741267
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Aug 2016 06:40:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2IcIxpgNbydZ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 30 Aug 2016 06:40:03 -0400 (EDT)
Received: from mail-wm0-f45.google.com (mail-wm0-f45.google.com [74.125.82.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9523B40FA2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Aug 2016 06:40:03 -0400 (EDT)
Received: by mail-wm0-f45.google.com with SMTP id i5so28721274wmg.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Aug 2016 03:48:08 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1472037609-4164-2-git-send-email-vijay.kilari@gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: vijay.kilari@gmail.com
Cc: marc.zyngier@arm.com, Vijaya Kumar K <Vijaya.Kumar@cavium.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Aug 24, 2016 at 04:50:05PM +0530, vijay.kilari@gmail.com wrote:
> From: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
> 
> Read and write of some registers like ISPENDR and ICPENDR
> from userspace requires special handling when compared to
> guest access for these registers.
> 
> Refer to Documentation/virtual/kvm/devices/arm-vgic-its.txt
> for handling of ISPENDR, ICPENDR registers handling.
> 
> Add infrastructure to support guest and userspace read
> and write for the required registers
> 
> Signed-off-by: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
> ---
>  virt/kvm/arm/vgic/vgic-mmio-v2.c |  5 ++-
>  virt/kvm/arm/vgic/vgic-mmio-v3.c | 40 ++++++++++++++----
>  virt/kvm/arm/vgic/vgic-mmio.c    | 87 ++++++++++++++++++++++++++++++++++++----
>  virt/kvm/arm/vgic/vgic-mmio.h    | 25 ++++++++++++
>  4 files changed, 139 insertions(+), 18 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
> index b44b359..cd37159 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
> @@ -421,9 +421,10 @@ static int vgic_uaccess(struct kvm_vcpu *vcpu, struct vgic_io_device *dev,
>  
>  	if (is_write) {
>  		vgic_data_host_to_mmio_bus(buf, len, *val);
> -		ret = kvm_io_gic_ops.write(vcpu, &dev->dev, offset, len, buf);
> +		ret = vgic_mmio_uaccess_write(vcpu, &dev->dev, offset,
> +					      len, buf);
>  	} else {
> -		ret = kvm_io_gic_ops.read(vcpu, &dev->dev, offset, len, buf);
> +		ret = vgic_mmio_uaccess_read(vcpu, &dev->dev, offset, len, buf);
>  		if (!ret)
>  			*val = vgic_data_mmio_bus_to_host(buf, len);
>  	}
> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> index ff668e0..dd0d602 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> @@ -367,6 +367,26 @@ static void vgic_mmio_write_pendbase(struct kvm_vcpu *vcpu,
>  		.write = wr,						\
>  	}
>  
> +#define REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED_UACCESS(off, rd, wr, ur, \
> +							uw, bpi, acc)	\
> +	{								\
> +		.reg_offset = off,					\
> +		.bits_per_irq = bpi,					\
> +		.len = (bpi * VGIC_NR_PRIVATE_IRQS) / 8,		\
> +		.access_flags = acc,					\
> +		.read = vgic_mmio_read_raz,				\
> +		.write = vgic_mmio_write_wi,				\
> +	}, {								\
> +		.reg_offset = off + (bpi * VGIC_NR_PRIVATE_IRQS) / 8,	\
> +		.bits_per_irq = bpi,					\
> +		.len = (bpi * (1024 - VGIC_NR_PRIVATE_IRQS)) / 8,	\
> +		.access_flags = acc,					\
> +		.read = rd,						\
> +		.write = wr,						\
> +		.uaccess_read = ur,					\
> +		.uaccess_write = uw,					\
> +	}
> +
>  static const struct vgic_register_region vgic_v3_dist_registers[] = {
>  	REGISTER_DESC_WITH_LENGTH(GICD_CTLR,
>  		vgic_mmio_read_v3_misc, vgic_mmio_write_v3_misc, 16,
> @@ -380,11 +400,13 @@ static const struct vgic_register_region vgic_v3_dist_registers[] = {
>  	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ICENABLER,
>  		vgic_mmio_read_enable, vgic_mmio_write_cenable, 1,
>  		VGIC_ACCESS_32bit),
> -	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ISPENDR,
> -		vgic_mmio_read_pending, vgic_mmio_write_spending, 1,
> +	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED_UACCESS(GICD_ISPENDR,
> +		vgic_mmio_read_pending, vgic_mmio_write_spending,
> +		vgic_mmio_read_soft_pending, vgic_mmio_write_spending, 1,
>  		VGIC_ACCESS_32bit),
> -	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ICPENDR,
> -		vgic_mmio_read_pending, vgic_mmio_write_cpending, 1,
> +	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED_UACCESS(GICD_ICPENDR,
> +		vgic_mmio_read_pending, vgic_mmio_write_cpending,
> +		vgic_mmio_read_soft_pending, vgic_mmio_write_cpending, 1,
>  		VGIC_ACCESS_32bit),
>  	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ISACTIVER,
>  		vgic_mmio_read_active, vgic_mmio_write_sactive, 1,
> @@ -443,11 +465,13 @@ static const struct vgic_register_region vgic_v3_sgibase_registers[] = {
>  	REGISTER_DESC_WITH_LENGTH(GICR_ICENABLER0,
>  		vgic_mmio_read_enable, vgic_mmio_write_cenable, 4,
>  		VGIC_ACCESS_32bit),
> -	REGISTER_DESC_WITH_LENGTH(GICR_ISPENDR0,
> -		vgic_mmio_read_pending, vgic_mmio_write_spending, 4,
> +	REGISTER_DESC_WITH_LENGTH_UACCESS(GICR_ISPENDR0,
> +		vgic_mmio_read_pending, vgic_mmio_write_spending,
> +		vgic_mmio_read_soft_pending, vgic_mmio_write_spending, 4,
>  		VGIC_ACCESS_32bit),
> -	REGISTER_DESC_WITH_LENGTH(GICR_ICPENDR0,
> -		vgic_mmio_read_pending, vgic_mmio_write_cpending, 4,
> +	REGISTER_DESC_WITH_LENGTH_UACCESS(GICR_ICPENDR0,
> +		vgic_mmio_read_pending, vgic_mmio_write_cpending,
> +		vgic_mmio_read_soft_pending, vgic_mmio_write_cpending, 4,
>  		VGIC_ACCESS_32bit),
>  	REGISTER_DESC_WITH_LENGTH(GICR_ISACTIVER0,
>  		vgic_mmio_read_active, vgic_mmio_write_sactive, 4,
> diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
> index 3bad3c5..dcf5d25 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio.c
> @@ -100,6 +100,26 @@ void vgic_mmio_write_cenable(struct kvm_vcpu *vcpu,
>  	}
>  }
>  
> +unsigned long vgic_mmio_read_soft_pending(struct kvm_vcpu *vcpu,
> +					  gpa_t addr, unsigned int len)
> +{
> +	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
> +	u32 value = 0;
> +	int i;
> +
> +	/* Loop over all IRQs affected by this read */
> +	for (i = 0; i < len * 8; i++) {
> +		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
> +
> +		if (irq->config == VGIC_CONFIG_LEVEL && irq->soft_pending)
> +			value |= (1U << i);
> +		if (irq->config != VGIC_CONFIG_LEVEL && irq->pending)
> +			value |= (1U << i);
> +	}
> +
> +	return value;
> +}
> +
>  unsigned long vgic_mmio_read_pending(struct kvm_vcpu *vcpu,
>  				     gpa_t addr, unsigned int len)
>  {
> @@ -468,6 +488,62 @@ static bool check_region(const struct vgic_register_region *region,
>  	return false;
>  }
>  
> +static const struct vgic_register_region *
> +	vgic_get_mmio_region(struct vgic_io_device *iodev, gpa_t addr, int len)
> +{
> +	const struct vgic_register_region *region;
> +
> +	region = vgic_find_mmio_region(iodev->regions, iodev->nr_regions,
> +				       addr - iodev->base_addr);
> +	if (!region || !check_region(region, addr, len))
> +		return NULL;
> +
> +	return region;
> +}
> +
> +int vgic_mmio_uaccess_read(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
> +			   gpa_t addr, int len, void *val)
> +{
> +	struct vgic_io_device *iodev = kvm_to_vgic_iodev(dev);
> +	const struct vgic_register_region *region;
> +	struct kvm_vcpu *r_vcpu;
> +	unsigned long data;
> +
> +	region = vgic_get_mmio_region(iodev, addr, len);
> +	if (!region) {
> +		memset(val, 0, len);
> +		return 0;
> +	}
> +
> +	r_vcpu = iodev->redist_vcpu ? iodev->redist_vcpu : vcpu;
> +	if (region->uaccess_read != NULL)
> +		data = region->uaccess_read(r_vcpu, addr, len);
> +	else
> +		data = region->read(r_vcpu, addr, len);
> +	vgic_data_host_to_mmio_bus(val, len, data);
> +	return 0;
> +}
> +
> +int vgic_mmio_uaccess_write(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
> +			    gpa_t addr, int len, const void *val)
> +{
> +	struct vgic_io_device *iodev = kvm_to_vgic_iodev(dev);
> +	const struct vgic_register_region *region;
> +	struct kvm_vcpu *r_vcpu;
> +	unsigned long data = vgic_data_mmio_bus_to_host(val, len);
> +
> +	region = vgic_get_mmio_region(iodev, addr, len);
> +	if (!region)
> +		return 0;
> +
> +	r_vcpu = iodev->redist_vcpu ? iodev->redist_vcpu : vcpu;
> +	if (region->uaccess_write != NULL)

nit: we use the form if (!region->uaccess_write) most other places,
please use this instead.

Thanks,
-Christoffer
