From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v4 06/12] KVM: arm64: implement basic ITS register handlers
Date: Thu, 7 Apr 2016 15:35:56 +0100
Message-ID: <5706704C.5060307@arm.com>
References: <1458958450-19662-1-git-send-email-andre.przywara@arm.com>
 <1458958450-19662-7-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DE161410D7
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Apr 2016 10:34:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OQAefzk2PcCS for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Apr 2016 10:34:35 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C0F44053F
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Apr 2016 10:34:35 -0400 (EDT)
In-Reply-To: <1458958450-19662-7-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 26/03/16 02:14, Andre Przywara wrote:
> Add emulation for some basic MMIO registers used in the ITS emulation.
> This includes:
> - GITS_{CTLR,TYPER,IIDR}
> - ID registers
> - GITS_{CBASER,CREADR,CWRITER}
>   those implement the ITS command buffer handling
> 
> Most of the handlers are pretty straight forward, but CWRITER goes
> some extra miles to allow fine grained locking. The idea here
> is to let only the first instance iterate through the command ring
> buffer, CWRITER accesses on other VCPUs meanwhile will be picked up
> by that first instance and handled as well. The ITS lock is thus only
> hold for very small periods of time and is dropped before the actual

s/hold/held/

> command handler is called.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  include/kvm/vgic/vgic.h            |   3 +
>  include/linux/irqchip/arm-gic-v3.h |   8 ++
>  virt/kvm/arm/vgic/its-emul.c       | 272 ++++++++++++++++++++++++++++++++++++-
>  virt/kvm/arm/vgic/vgic.h           |   6 +
>  virt/kvm/arm/vgic/vgic_init.c      |   2 +
>  5 files changed, 284 insertions(+), 7 deletions(-)
> 
> diff --git a/include/kvm/vgic/vgic.h b/include/kvm/vgic/vgic.h
> index c79bed5..bafea11 100644
> --- a/include/kvm/vgic/vgic.h
> +++ b/include/kvm/vgic/vgic.h
> @@ -115,6 +115,9 @@ struct vgic_io_device {
>  struct vgic_its {
>  	bool			enabled;
>  	spinlock_t		lock;
> +	u64			cbaser;
> +	int			creadr;
> +	int			cwriter;

Irk. Please use explicitly sized types.

>  };
>  
>  struct vgic_dist {
> diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
> index a813c3e..7011b98 100644
> --- a/include/linux/irqchip/arm-gic-v3.h
> +++ b/include/linux/irqchip/arm-gic-v3.h
> @@ -179,15 +179,23 @@
>  #define GITS_BASER			0x0100
>  #define GITS_IDREGS_BASE		0xffd0
>  #define GITS_PIDR2			GICR_PIDR2
> +#define GITS_PIDR4			0xffd0
> +#define GITS_CIDR0			0xfff0
> +#define GITS_CIDR1			0xfff4
> +#define GITS_CIDR2			0xfff8
> +#define GITS_CIDR3			0xfffc
>  
>  #define GITS_TRANSLATER			0x10040
>  
>  #define GITS_CTLR_ENABLE		(1U << 0)
>  #define GITS_CTLR_QUIESCENT		(1U << 31)
>  
> +#define GITS_TYPER_PLPIS		(1UL << 0)
> +#define GITS_TYPER_IDBITS_SHIFT		8
>  #define GITS_TYPER_DEVBITS_SHIFT	13
>  #define GITS_TYPER_DEVBITS(r)		((((r) >> GITS_TYPER_DEVBITS_SHIFT) & 0x1f) + 1)
>  #define GITS_TYPER_PTA			(1UL << 19)
> +#define GITS_TYPER_HWCOLLCNT_SHIFT	24
>  
>  #define GITS_CBASER_VALID		(1UL << 63)
>  #define GITS_CBASER_nCnB		(0UL << 59)
> diff --git a/virt/kvm/arm/vgic/its-emul.c b/virt/kvm/arm/vgic/its-emul.c
> index 49dd5e4..de8d360 100644
> --- a/virt/kvm/arm/vgic/its-emul.c
> +++ b/virt/kvm/arm/vgic/its-emul.c
> @@ -31,23 +31,263 @@
>  #include "vgic.h"
>  #include "vgic_mmio.h"
>  
> +#define BASER_BASE_ADDRESS(x) ((x) & 0xfffffffff000ULL)
> +
> +static int vgic_mmio_read_its_ctlr(struct kvm_vcpu *vcpu,
> +				   struct kvm_io_device *this,
> +				   gpa_t addr, int len, void *val)
> +{
> +	struct vgic_its *its = &vcpu->kvm->arch.vgic.its;
> +	u32 reg;
> +
> +	reg = GITS_CTLR_QUIESCENT;

So your ITS is always in a quiescent state? Even when you're processing
the command queue? You'll have to convince me...

> +	if (its->enabled)
> +		reg |= GITS_CTLR_ENABLE;
> +
> +	write_mask32(reg, addr & 3, len, val);
> +
> +	return 0;
> +}
> +
> +static int vgic_mmio_write_its_ctlr(struct kvm_vcpu *vcpu,
> +				    struct kvm_io_device *this,
> +				    gpa_t addr, int len, const void *val)
> +{
> +	struct vgic_its *its = &vcpu->kvm->arch.vgic.its;
> +	struct vgic_io_device *iodev = container_of(this,
> +						    struct vgic_io_device, dev);
> +
> +        if (addr - iodev->base_addr == 0)

whitespace issue.

> +		its->enabled = !!(*(u8*)val & GITS_CTLR_ENABLE);
> +
> +	return 0;
> +}
> +
> +static int vgic_mmio_read_its_typer(struct kvm_vcpu *vcpu,
> +				    struct kvm_io_device *this,
> +				    gpa_t addr, int len, void *val)
> +{
> +	u64 reg = GITS_TYPER_PLPIS;
> +
> +	/*
> +	 * We use linear CPU numbers for redistributor addressing,
> +	 * so GITS_TYPER.PTA is 0.
> +	 * To avoid memory waste on the guest side, we keep the
> +	 * number of IDBits and DevBits low for the time being.
> +	 * This could later be made configurable by userland.
> +	 * Since we have all collections in linked list, we claim
> +	 * that we can hold all of the collection tables in our
> +	 * own memory and that the ITT entry size is 1 byte (the
> +	 * smallest possible one).

All of this is going to bite us when we want to implement migration,
specially the HW collection bit.

> +	 */
> +	reg |= 0xff << GITS_TYPER_HWCOLLCNT_SHIFT;
> +	reg |= 0x0f << GITS_TYPER_DEVBITS_SHIFT;
> +	reg |= 0x0f << GITS_TYPER_IDBITS_SHIFT;
> +
> +	write_mask64(reg, addr & 7, len, val);
> +
> +	return 0;
> +}
> +
> +static int vgic_mmio_read_its_iidr(struct kvm_vcpu *vcpu,
> +				   struct kvm_io_device *this,
> +				   gpa_t addr, int len, void *val)
> +{
> +	u32 reg = (PRODUCT_ID_KVM << 24) | (IMPLEMENTER_ARM << 0);
> +
> +	write_mask32(reg, addr & 3, len, val);
> +
> +	return 0;
> +}
> +
> +static int vgic_mmio_read_its_idregs(struct kvm_vcpu *vcpu,
> +				     struct kvm_io_device *this,
> +				     gpa_t addr, int len, void *val)
> +{
> +	struct vgic_io_device *iodev = container_of(this,
> +						    struct vgic_io_device, dev);
> +	u32 reg = 0;
> +	int idreg = (addr & ~3) - iodev->base_addr + GITS_IDREGS_BASE;
> +
> +	switch (idreg) {
> +	case GITS_PIDR2:
> +		reg = GIC_PIDR2_ARCH_GICv3;

Are we leaving the lowest 4 bits to zero?

> +		break;
> +	case GITS_PIDR4:
> +		/* This is a 64K software visible page */
> +		reg = 0x40;

Same question.

Also, how about all the others PIDR registers?

> +		break;
> +	/* Those are the ID registers for (any) GIC. */
> +	case GITS_CIDR0:
> +		reg = 0x0d;
> +		break;
> +	case GITS_CIDR1:
> +		reg = 0xf0;
> +		break;
> +	case GITS_CIDR2:
> +		reg = 0x05;
> +		break;
> +	case GITS_CIDR3:
> +		reg = 0xb1;
> +		break;
> +	}

Given that these values are directly taken from the architecture, and
seem common to the whole GICv3 architecture when implemented by ARM, we
could have a common handler for the whole GICv3 implementatuin. Not a
bit deal though.

> +
> +	write_mask32(reg, addr & 3, len, val);
> +
> +	return 0;
> +}
> +
> +/*
> + * This function is called with both the ITS and the distributor lock dropped,
> + * so the actual command handlers must take the respective locks when needed.
> + */
> +static int vits_handle_command(struct kvm_vcpu *vcpu, u64 *its_cmd)
> +{
> +	return -ENODEV;
> +}
> +
> +static int vgic_mmio_read_its_cbaser(struct kvm_vcpu *vcpu,
> +				    struct kvm_io_device *this,
> +				    gpa_t addr, int len, void *val)
> +{
> +	struct vgic_its *its = &vcpu->kvm->arch.vgic.its;
> +
> +	write_mask64(its->cbaser, addr & 7, len, val);
> +
> +	return 0;
> +}
> +
> +static int vgic_mmio_write_its_cbaser(struct kvm_vcpu *vcpu,
> +				      struct kvm_io_device *this,
> +				      gpa_t addr, int len, const void *val)
> +{
> +	struct vgic_its *its = &vcpu->kvm->arch.vgic.its;
> +
> +	if (its->enabled)
> +		return 0;
> +
> +	its->cbaser = mask64(its->cbaser, addr & 7, len, val);
> +	its->creadr = 0;

Don't you need to acquire the command queue lock here?

> +
> +	return 0;
> +}
> +
> +static int its_cmd_buffer_size(struct kvm *kvm)
> +{
> +	struct vgic_its *its = &kvm->arch.vgic.its;
> +
> +	return ((its->cbaser & 0xff) + 1) << 12;
> +}
> +
> +static gpa_t its_cmd_buffer_base(struct kvm *kvm)
> +{
> +	struct vgic_its *its = &kvm->arch.vgic.its;
> +
> +	return BASER_BASE_ADDRESS(its->cbaser);
> +}
> +
> +/*
> + * By writing to CWRITER the guest announces new commands to be processed.
> + * Since we cannot read from guest memory inside the ITS spinlock, we
> + * iterate over the command buffer (with the lock dropped) until the read
> + * pointer matches the write pointer. Other VCPUs writing this register in the
> + * meantime will just update the write pointer, leaving the command
> + * processing to the first instance of the function.
> + */
> +static int vgic_mmio_write_its_cwriter(struct kvm_vcpu *vcpu,
> +				       struct kvm_io_device *this,
> +				       gpa_t addr, int len, const void *val)
> +{
> +	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
> +	struct vgic_its *its = &dist->its;
> +	gpa_t cbaser = its_cmd_buffer_base(vcpu->kvm);
> +	u64 cmd_buf[4];
> +	u32 reg;
> +	bool finished;
> +
> +	reg = mask64(its->cwriter & 0xfffe0, addr & 7, len, val);
> +	reg &= 0xfffe0;
> +	if (reg > its_cmd_buffer_size(vcpu->kvm))
> +		return 0;
> +
> +	spin_lock(&its->lock);
> +
> +	/*
> +	 * If there is still another VCPU handling commands, let this
> +	 * one pick up the new CWRITER and process "our" new commands as well.
> +	 */

How do you detect that condition? All I see is a massive race here, with
two threads processing the queue in parallel, possibly corrupting each
other's data.

Please explain why you think this is safe.

> +	finished = (its->cwriter != its->creadr);
> +	its->cwriter = reg;
> +
> +	spin_unlock(&its->lock);
> +
> +	while (!finished) {
> +		int ret = kvm_read_guest(vcpu->kvm, cbaser + its->creadr,
> +					 cmd_buf, 32);
> +		if (ret) {
> +			/*
> +			 * Gah, we are screwed. Reset CWRITER to that command
> +			 * that we have finished processing and return.
> +			 */
> +			spin_lock(&its->lock);
> +			its->cwriter = its->creadr;
> +			spin_unlock(&its->lock);
> +			break;
> +		}
> +		vits_handle_command(vcpu, cmd_buf);
> +
> +		spin_lock(&its->lock);
> +		its->creadr += 32;
> +		if (its->creadr == its_cmd_buffer_size(vcpu->kvm))
> +			its->creadr = 0;
> +		finished = (its->creadr == its->cwriter);
> +		spin_unlock(&its->lock);
> +	}
> +
> +	return 0;
> +}
> +
> +static int vgic_mmio_read_its_cwriter(struct kvm_vcpu *vcpu,
> +				      struct kvm_io_device *this,
> +				      gpa_t addr, int len, void *val)
> +{
> +	struct vgic_its *its = &vcpu->kvm->arch.vgic.its;
> +	u64 reg = its->cwriter & 0xfffe0;
> +
> +	write_mask64(reg, addr & 7, len, val);
> +
> +	return 0;
> +}
> +
> +static int vgic_mmio_read_its_creadr(struct kvm_vcpu *vcpu,
> +				     struct kvm_io_device *this,
> +				     gpa_t addr, int len, void *val)
> +{
> +	struct vgic_its *its = &vcpu->kvm->arch.vgic.its;
> +	u64 reg = its->creadr & 0xfffe0;
> +
> +	write_mask64(reg, addr & 7, len, val);
> +
> +	return 0;
> +}
> +
>  struct vgic_register_region its_registers[] = {
>  	REGISTER_DESC_WITH_LENGTH(GITS_CTLR,
> -		vgic_mmio_read_raz, vgic_mmio_write_wi, 4),
> +		vgic_mmio_read_its_ctlr, vgic_mmio_write_its_ctlr, 4),
>  	REGISTER_DESC_WITH_LENGTH(GITS_IIDR,
> -		vgic_mmio_read_raz, vgic_mmio_write_wi, 4),
> +		vgic_mmio_read_its_iidr, vgic_mmio_write_wi, 4),
>  	REGISTER_DESC_WITH_LENGTH(GITS_TYPER,
> -		vgic_mmio_read_raz, vgic_mmio_write_wi, 4),
> +		vgic_mmio_read_its_typer, vgic_mmio_write_wi, 4),
>  	REGISTER_DESC_WITH_LENGTH(GITS_CBASER,
> -		vgic_mmio_read_raz, vgic_mmio_write_wi, 8),
> +		vgic_mmio_read_its_cbaser, vgic_mmio_write_its_cbaser, 8),
>  	REGISTER_DESC_WITH_LENGTH(GITS_CWRITER,
> -		vgic_mmio_read_raz, vgic_mmio_write_wi, 8),
> +		vgic_mmio_read_its_cwriter, vgic_mmio_write_its_cwriter, 8),
>  	REGISTER_DESC_WITH_LENGTH(GITS_CREADR,
> -		vgic_mmio_read_raz, vgic_mmio_write_wi, 8),
> +		vgic_mmio_read_its_creadr, vgic_mmio_write_wi, 8),
>  	REGISTER_DESC_WITH_LENGTH(GITS_BASER,
>  		vgic_mmio_read_raz, vgic_mmio_write_wi, 0x40),
>  	REGISTER_DESC_WITH_LENGTH(GITS_IDREGS_BASE,
> -		vgic_mmio_read_raz, vgic_mmio_write_wi, 0x30),
> +		vgic_mmio_read_its_idregs, vgic_mmio_write_wi, 0x30),
>  };
>  
>  /* This is called on setting the LPI enable bit in the redistributor. */
> @@ -59,9 +299,14 @@ int vits_init(struct kvm *kvm)
>  {
>  	struct vgic_dist *dist = &kvm->arch.vgic;
>  	struct vgic_its *its = &dist->its;
> +	int nr_vcpus = atomic_read(&kvm->online_vcpus);
>  	struct vgic_io_device *regions;
>  	int ret, i;
>  
> +	dist->pendbaser = kcalloc(nr_vcpus, sizeof(u64), GFP_KERNEL);
> +	if (!dist->pendbaser)
> +		return -ENOMEM;
> +
>  	spin_lock_init(&its->lock);
>  
>  	regions = kmalloc_array(ARRAY_SIZE(its_registers),
> @@ -82,3 +327,16 @@ int vits_init(struct kvm *kvm)
>  
>  	return -ENXIO;
>  }
> +
> +void vits_destroy(struct kvm *kvm)
> +{
> +	struct vgic_dist *dist = &kvm->arch.vgic;
> +	struct vgic_its *its = &dist->its;
> +
> +	if (!vgic_has_its(kvm))
> +		return;
> +
> +	kfree(dist->pendbaser);
> +
> +	its->enabled = false;
> +}
> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
> index 4e7dcb8..08f97d1 100644
> --- a/virt/kvm/arm/vgic/vgic.h
> +++ b/virt/kvm/arm/vgic/vgic.h
> @@ -63,6 +63,7 @@ int vgic_register_redist_regions(struct kvm *kvm, gpa_t dist_base_address);
>  
>  int vits_init(struct kvm *kvm);
>  void vgic_enable_lpis(struct kvm_vcpu *vcpu);
> +void vits_destroy(struct kvm *kvm);
>  #else
>  static inline void vgic_v3_irq_change_affinity(struct kvm *kvm, u32 intid,
>  					       u64 mpidr)
> @@ -137,6 +138,11 @@ static inline void vgic_enable_lpis(struct kvm_vcpu *vcpu)
>  {
>  	return;
>  }
> +
> +static inline void vits_destroy(struct kvm *kvm)
> +{
> +	return;
> +}
>  #endif
>  
>  void vgic_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
> diff --git a/virt/kvm/arm/vgic/vgic_init.c b/virt/kvm/arm/vgic/vgic_init.c
> index dcfb93d..e4459e3 100644
> --- a/virt/kvm/arm/vgic/vgic_init.c
> +++ b/virt/kvm/arm/vgic/vgic_init.c
> @@ -298,6 +298,8 @@ void kvm_vgic_destroy(struct kvm *kvm)
>  
>  	kvm_vgic_dist_destroy(kvm);
>  
> +	vits_destroy(kvm);
> +
>  	kvm_for_each_vcpu(i, vcpu, kvm)
>  		kvm_vgic_vcpu_destroy(vcpu);
>  }
> 

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
