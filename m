From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH v2 09/15] KVM: arm64: implement basic ITS register handlers
Date: Thu, 13 Aug 2015 17:25:32 +0200
Message-ID: <55CCB6EC.50609@linaro.org>
References: <1436538111-4294-1-git-send-email-andre.przywara@arm.com> <1436538111-4294-10-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1436538111-4294-10-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>, marc.zyngier@arm.com, christoffer.dall@linaro.org, kvmarm@lists.cs.columbia.edu
Cc: Pavel Fedin <p.fedin@samsung.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 07/10/2015 04:21 PM, Andre Przywara wrote:
> Add emulation for some basic MMIO registers used in the ITS emulation.
> This includes:
> - GITS_{CTLR,TYPER,IIDR}
> - ID registers
> - GITS_{CBASER,CREADR,CWRITER}
>   those implement the ITS command buffer handling
> 
> Most of the handlers are pretty straight forward
straightforward?
, but CWRITER goes
> some extra miles to allow fine grained locking. The idea here
> is to let only the first instance iterate through the command ring
> buffer, CWRITER accesses on other VCPUs meanwhile will be picked up
> by that first instance and handled as well. The ITS lock is thus only
> hold for very small periods of time and is dropped before the actual
> command handler is called.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  include/kvm/arm_vgic.h             |   3 +
>  include/linux/irqchip/arm-gic-v3.h |   8 ++
>  virt/kvm/arm/its-emul.c            | 205 +++++++++++++++++++++++++++++++++++++
>  virt/kvm/arm/its-emul.h            |   1 +
>  virt/kvm/arm/vgic-v3-emul.c        |   2 +
>  5 files changed, 219 insertions(+)
> 
> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index 9e9d4aa..b432055 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -159,6 +159,9 @@ struct vgic_io_device {
>  struct vgic_its {
>  	bool			enabled;
>  	spinlock_t		lock;
> +	u64			cbaser;
> +	int			creadr;
> +	int			cwriter;
>  };
>  
>  struct vgic_dist {
> diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
> index df4e527..0b450c7 100644
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
> diff --git a/virt/kvm/arm/its-emul.c b/virt/kvm/arm/its-emul.c
> index 659dd39..b498f06 100644
> --- a/virt/kvm/arm/its-emul.c
> +++ b/virt/kvm/arm/its-emul.c
> @@ -32,10 +32,62 @@
>  #include "vgic.h"
>  #include "its-emul.h"
>  
> +#define BASER_BASE_ADDRESS(x) ((x) & 0xfffffffff000ULL)
> +
> +/* The distributor lock is held by the VGIC MMIO handler. */
>  static bool handle_mmio_misc_gits(struct kvm_vcpu *vcpu,
>  				  struct kvm_exit_mmio *mmio,
>  				  phys_addr_t offset)
>  {
> +	struct vgic_its *its = &vcpu->kvm->arch.vgic.its;
> +	u32 reg;
> +	bool was_enabled;
> +
> +	switch (offset & ~3) {
> +	case 0x00:		/* GITS_CTLR */
> +		/* We never defer any command execution. */
> +		reg = GITS_CTLR_QUIESCENT;
> +		if (its->enabled)
> +			reg |= GITS_CTLR_ENABLE;
> +		was_enabled = its->enabled;
> +		vgic_reg_access(mmio, &reg, offset & 3,
> +				ACCESS_READ_VALUE | ACCESS_WRITE_VALUE);
> +		its->enabled = !!(reg & GITS_CTLR_ENABLE);
> +		return !was_enabled && its->enabled;
> +	case 0x04:		/* GITS_IIDR */
> +		reg = (PRODUCT_ID_KVM << 24) | (IMPLEMENTER_ARM << 0);
> +		vgic_reg_access(mmio, &reg, offset & 3,
> +				ACCESS_READ_VALUE | ACCESS_WRITE_IGNORED);
> +		break;
> +	case 0x08:		/* GITS_TYPER */
> +		/*
> +		 * We use linear CPU numbers for redistributor addressing,
> +		 * so GITS_TYPER.PTA is 0.
> +		 * To avoid memory waste on the guest side, we keep the
> +		 * number of IDBits and DevBits low for the time being.
> +		 * This could later be made configurable by userland.
> +		 * Since we have all collections in linked list, we claim
> +		 * that we can hold all of the collection tables in our
> +		 * own memory and that the ITT entry size is 1 byte (the
> +		 * smallest possible one).
> +		 */
> +		reg = GITS_TYPER_PLPIS;
> +		reg |= 0xff << GITS_TYPER_HWCOLLCNT_SHIFT;
> +		reg |= 0x0f << GITS_TYPER_DEVBITS_SHIFT;
> +		reg |= 0x0f << GITS_TYPER_IDBITS_SHIFT;
> +		vgic_reg_access(mmio, &reg, offset & 3,
> +				ACCESS_READ_VALUE | ACCESS_WRITE_IGNORED);
> +		break;
> +	case 0x0c:
> +		/* The upper 32bits of TYPER are all 0 for the time being.
> +		 * Should we need more than 256 collections, we can enable
> +		 * some bits in here.
> +		 */
> +		vgic_reg_access(mmio, NULL, offset & 3,
> +				ACCESS_READ_RAZ | ACCESS_WRITE_IGNORED);
> +		break;
> +	}
> +
>  	return false;
>  }
>  
> @@ -43,20 +95,142 @@ static bool handle_mmio_gits_idregs(struct kvm_vcpu *vcpu,
>  				    struct kvm_exit_mmio *mmio,
>  				    phys_addr_t offset)
>  {
> +	u32 reg = 0;
> +	int idreg = (offset & ~3) + GITS_IDREGS_BASE;
> +
> +	switch (idreg) {
> +	case GITS_PIDR2:
> +		reg = GIC_PIDR2_ARCH_GICv3;
> +		break;
> +	case GITS_PIDR4:
> +		/* This is a 64K software visible page */
> +		reg = 0x40;
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
> +	vgic_reg_access(mmio, &reg, offset & 3,
> +			ACCESS_READ_VALUE | ACCESS_WRITE_IGNORED);
>  	return false;
>  }
>  
> +static int vits_handle_command(struct kvm_vcpu *vcpu, u64 *its_cmd)
> +{
> +	return -ENODEV;
> +}
> +
>  static bool handle_mmio_gits_cbaser(struct kvm_vcpu *vcpu,
>  				    struct kvm_exit_mmio *mmio,
>  				    phys_addr_t offset)
>  {
> +	struct vgic_its *its = &vcpu->kvm->arch.vgic.its;
> +	int mode = ACCESS_READ_VALUE;
> +
> +	mode |= its->enabled ? ACCESS_WRITE_IGNORED : ACCESS_WRITE_VALUE;
> +
> +	vgic_handle_base_register(vcpu, mmio, offset, &its->cbaser, mode);
> +
> +	/* Writing CBASER resets the read pointer. */
> +	if (mmio->is_write)
> +		its->creadr = 0;
> +
>  	return false;
>  }
>  
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
I am lost, isn't the dist lock hold by vgic_handle_mmio_access before
calling call_range_handler/range->handle_mmio ?

if confirmed we need to move the command enumeration + execution
somewhere else. Besides that piece of code may deserve to be
encaspulated in a function. what do you think?


>  static bool handle_mmio_gits_cwriter(struct kvm_vcpu *vcpu,
>  				     struct kvm_exit_mmio *mmio,
>  				     phys_addr_t offset)
>  {
> +	struct vgic_its *its = &vcpu->kvm->arch.vgic.its;
> +	gpa_t cbaser = its_cmd_buffer_base(vcpu->kvm);
> +	u64 cmd_buf[4];
> +	u32 reg;
> +	bool finished;
> +
> +	/* The upper 32 bits are RES0 */
> +	if ((offset & ~3) == 0x04) {
> +		vgic_reg_access(mmio, &reg, offset & 3,
> +				ACCESS_READ_RAZ | ACCESS_WRITE_IGNORED);
> +		return false;
> +	}
> +
> +	reg = its->cwriter & 0xfffe0;
> +	vgic_reg_access(mmio, &reg, offset & 3,
> +			ACCESS_READ_VALUE | ACCESS_WRITE_VALUE);
> +	if (!mmio->is_write)
> +		return false;
> +
> +	reg &= 0xfffe0;
> +	if (reg > its_cmd_buffer_size(vcpu->kvm))
> +		return false;
> +
> +	spin_lock(&its->lock);
> +
> +	/*
> +	 * If there is still another VCPU handling commands, let this
> +	 * one pick up the new CWRITER and process our new commands as well.
> +	 */
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
>  	return false;
>  }
>  
> @@ -64,6 +238,20 @@ static bool handle_mmio_gits_creadr(struct kvm_vcpu *vcpu,
>  				    struct kvm_exit_mmio *mmio,
>  				    phys_addr_t offset)
>  {
> +	struct vgic_its *its = &vcpu->kvm->arch.vgic.its;
> +	u32 reg;
> +
> +	switch (offset & ~3) {
> +	case 0x00:
> +		reg = its->creadr & 0xfffe0;
> +		vgic_reg_access(mmio, &reg, offset & 3,
> +				ACCESS_READ_VALUE | ACCESS_WRITE_IGNORED);
> +		break;
> +	case 0x04:
> +		vgic_reg_access(mmio, &reg, offset & 3,
> +				ACCESS_READ_RAZ | ACCESS_WRITE_IGNORED);
> +		break;
> +	}
>  	return false;
>  }
>  
> @@ -117,9 +305,26 @@ int vits_init(struct kvm *kvm)
>  	struct vgic_dist *dist = &kvm->arch.vgic;
>  	struct vgic_its *its = &dist->its;
>  
> +	dist->pendbaser = kmalloc(sizeof(u64) * dist->nr_cpus, GFP_KERNEL);
check_patch advises to use kmalloc_array here (warning). or kcalloc?

Eric

> +	if (!dist->pendbaser)
> +		return -ENOMEM;
> +
>  	spin_lock_init(&its->lock);
>  
>  	its->enabled = false;
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
> diff --git a/virt/kvm/arm/its-emul.h b/virt/kvm/arm/its-emul.h
> index 5dc8e2f..472a6d0 100644
> --- a/virt/kvm/arm/its-emul.h
> +++ b/virt/kvm/arm/its-emul.h
> @@ -31,5 +31,6 @@
>  
>  void vgic_enable_lpis(struct kvm_vcpu *vcpu);
>  int vits_init(struct kvm *kvm);
> +void vits_destroy(struct kvm *kvm);
>  
>  #endif
> diff --git a/virt/kvm/arm/vgic-v3-emul.c b/virt/kvm/arm/vgic-v3-emul.c
> index f5865e7..49be3c3 100644
> --- a/virt/kvm/arm/vgic-v3-emul.c
> +++ b/virt/kvm/arm/vgic-v3-emul.c
> @@ -928,6 +928,8 @@ static void vgic_v3_destroy_model(struct kvm *kvm)
>  {
>  	struct vgic_dist *dist = &kvm->arch.vgic;
>  
> +	vits_destroy(kvm);
> +
>  	kfree(dist->irq_spi_mpidr);
>  	dist->irq_spi_mpidr = NULL;
>  }
> 

