From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v5 08/13] KVM: arm64: implement basic ITS register
 handlers
Date: Fri, 3 Jun 2016 15:36:38 +0100
Message-ID: <575195F6.3060009@arm.com>
References: <1464962572-3925-1-git-send-email-andre.przywara@arm.com>
 <1464962572-3925-9-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1464962572-3925-9-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Eric Auger <eric.auger@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 03/06/16 15:02, Andre Przywara wrote:
> Add emulation for some basic MMIO registers used in the ITS emulation.
> This includes:
> - GITS_{CTLR,TYPER,IIDR}
> - ID registers
> - GITS_{CBASER,CREADR,CWRITER}
>   (which implement the ITS command buffer handling)
> 
> Most of the handlers are pretty straight forward, but CWRITER goes
> some extra miles to allow fine grained locking. The idea here
> is to let only the first instance iterate through the command ring
> buffer, CWRITER accesses on other VCPUs meanwhile will be picked up
> by that first instance and handled as well. The ITS lock is thus only
> held for very small periods of time and is dropped before the actual
> command handler is called.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  include/kvm/vgic/vgic.h            |   6 +
>  include/linux/irqchip/arm-gic-v3.h |  10 ++
>  virt/kvm/arm/vgic/vgic-its.c       | 307 ++++++++++++++++++++++++++++++++++++-
>  virt/kvm/arm/vgic/vgic-mmio-v3.c   |   8 +-
>  virt/kvm/arm/vgic/vgic-mmio.h      |   6 +
>  5 files changed, 326 insertions(+), 11 deletions(-)
> 
> diff --git a/include/kvm/vgic/vgic.h b/include/kvm/vgic/vgic.h
> index 8cf8018f..77f4503 100644
> --- a/include/kvm/vgic/vgic.h
> +++ b/include/kvm/vgic/vgic.h
> @@ -22,6 +22,7 @@
>  #include <linux/spinlock.h>
>  #include <linux/types.h>
>  #include <kvm/iodev.h>
> +#include <linux/list.h>
>  
>  #define VGIC_V3_MAX_CPUS	255
>  #define VGIC_V2_MAX_CPUS	8
> @@ -125,6 +126,11 @@ struct vgic_its {
>  	bool			enabled;
>  	struct vgic_io_device	iodev;
>  	spinlock_t		lock;
> +	u64			cbaser;
> +	u32			creadr;
> +	u32			cwriter;
> +	struct list_head	device_list;
> +	struct list_head	collection_list;
>  };
>  
>  struct vgic_dist {
> diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
> index f210dd3..9e5fe01 100644
> --- a/include/linux/irqchip/arm-gic-v3.h
> +++ b/include/linux/irqchip/arm-gic-v3.h
> @@ -176,16 +176,26 @@
>  #define GITS_CREADR			0x0090
>  #define GITS_BASER			0x0100
>  #define GITS_IDREGS_BASE		0xffd0
> +#define GITS_PIDR0			0xffe0
> +#define GITS_PIDR1			0xffe4
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
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index 61f550d..3ec12ef 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -21,6 +21,7 @@
>  #include <linux/kvm.h>
>  #include <linux/kvm_host.h>
>  #include <linux/interrupt.h>
> +#include <linux/list.h>
>  #include <linux/uaccess.h>
>  
>  #include <linux/irqchip/arm-gic-v3.h>
> @@ -32,30 +33,291 @@
>  #include "vgic.h"
>  #include "vgic-mmio.h"
>  
> +static struct vgic_its *find_its(struct kvm *kvm, gpa_t base_address)
> +{
> +	struct vgic_its *its;
> +
> +	list_for_each_entry(its, &kvm->arch.vits_list, its_list) {
> +		if (its->vgic_its_base == base_address)
> +			return its;
> +	}
> +
> +	return NULL;
> +}
> +
> +struct its_device {
> +	struct list_head dev_list;
> +
> +	/* the head for the list of ITTEs */
> +	struct list_head itt;
> +	u32 device_id;
> +};
> +
> +#define COLLECTION_NOT_MAPPED ((u32)-1)
> +
> +struct its_collection {
> +	struct list_head coll_list;
> +
> +	u32 collection_id;
> +	u32 target_addr;
> +};
> +
> +#define its_is_collection_mapped(coll) ((coll) && \
> +				((coll)->target_addr != COLLECTION_NOT_MAPPED))
> +
> +struct its_itte {
> +	struct list_head itte_list;
> +
> +	struct its_collection *collection;
> +	u32 lpi;
> +	u32 event_id;
> +};
> +
> +#define BASER_BASE_ADDRESS(x) ((x) & 0xfffffffff000ULL)
> +
> +#define ITS_FRAME(addr) ((addr) & ~(SZ_64K - 1))
> +
> +static unsigned long vgic_mmio_read_its_ctlr(struct kvm_vcpu *vcpu,
> +					     gpa_t addr, unsigned int len)
> +{
> +	struct vgic_its *its = find_its(vcpu->kvm, ITS_FRAME(addr));
> +	u32 reg = 0;
> +
> +	spin_lock(&its->lock);
> +	if (its->creadr == its->cwriter)
> +		reg |= GITS_CTLR_QUIESCENT;
> +	if (its->enabled)
> +		reg |= GITS_CTLR_ENABLE;
> +	spin_unlock(&its->lock);
> +
> +	return reg;
> +}
> +
> +static void vgic_mmio_write_its_ctlr(struct kvm_vcpu *vcpu,
> +				     gpa_t addr, unsigned int len,
> +				     unsigned long val)
> +{
> +	struct vgic_its *its = find_its(vcpu->kvm, ITS_FRAME(addr));
> +
> +	its->enabled = !!(val & GITS_CTLR_ENABLE);
> +}
> +
> +static unsigned long vgic_mmio_read_its_typer(struct kvm_vcpu *vcpu,
> +					      gpa_t addr, unsigned int len)
> +{
> +	u64 reg = GITS_TYPER_PLPIS;
> +
> +	/*
> +	 * We use linear CPU numbers for redistributor addressing,
> +	 * so GITS_TYPER.PTA is 0.
> +	 * Also we force all PROPBASER registers to be the same, so
> +	 * CommonLPIAff is 0 as well.
> +	 * As we hold all LPI mapping related data structures in the kernel
> +	 * (mimicing what the spec describes as "held in hardware"), we can
> +	 * claim to support a high number of "hardware" mapped collections
> +	 * (since we use linked lists to store them).
> +	 * However to avoid memory waste, we keep the number of IDBits and
> +	 * DevBits low - as least for the time being.
> +	 */
> +	reg |= 0xff << GITS_TYPER_HWCOLLCNT_SHIFT;
> +	reg |= 0x0f << GITS_TYPER_DEVBITS_SHIFT;
> +	reg |= 0x0f << GITS_TYPER_IDBITS_SHIFT;
> +
> +	return extract_bytes(reg, addr & 7, len);
> +}
> +
> +static unsigned long vgic_mmio_read_its_iidr(struct kvm_vcpu *vcpu,
> +					     gpa_t addr, unsigned int len)
> +{
> +	return (PRODUCT_ID_KVM << 24) | (IMPLEMENTER_ARM << 0);
> +}
> +
> +static unsigned long vgic_mmio_read_its_idregs(struct kvm_vcpu *vcpu,
> +					       gpa_t addr, unsigned int len)
> +{
> +	switch (addr & 0xffff) {
> +	case GITS_PIDR0:
> +		return 0x92;	/* part number, bits[7:0] */
> +	case GITS_PIDR1:
> +		return 0xb4;	/* part number, bits[11:8] */
> +	case GITS_PIDR2:
> +		return GIC_PIDR2_ARCH_GICv3 | 0x0b;
> +	case GITS_PIDR4:
> +		return 0x40;	/* This is a 64K software visible page */
> +	/* The following are the ID registers for (any) GIC. */
> +	case GITS_CIDR0:
> +		return 0x0d;
> +	case GITS_CIDR1:
> +		return 0xf0;
> +	case GITS_CIDR2:
> +		return 0x05;
> +	case GITS_CIDR3:
> +		return 0xb1;
> +	}
> +
> +	return 0;
> +}
> +
> +static void its_free_itte(struct its_itte *itte)
> +{
> +	list_del(&itte->itte_list);
> +	kfree(itte);
> +}
> +
> +/*
> + * This function expects the ITS lock to be dropped, so the actual command
> + * handlers must take care of proper locking when needed.
> + */
> +static int vits_handle_command(struct kvm *kvm, struct vgic_its *its,
> +			       u64 *its_cmd)
> +{
> +	return -ENODEV;
> +}
> +
> +static unsigned long vgic_mmio_read_its_cbaser(struct kvm_vcpu *vcpu,
> +					       gpa_t addr, unsigned int len)
> +{
> +	struct vgic_its *its = find_its(vcpu->kvm, ITS_FRAME(addr));
> +
> +	return extract_bytes(its->cbaser, addr & 7, len);
> +}
> +
> +static void vgic_mmio_write_its_cbaser(struct kvm_vcpu *vcpu,
> +				       gpa_t addr, unsigned int len,
> +				       unsigned long val)
> +{
> +	struct vgic_its *its = find_its(vcpu->kvm, ITS_FRAME(addr));
> +
> +	/* When GITS_CTLR.Enable is 1, this register is RO. */
> +	if (its->enabled)
> +		return;
> +
> +	spin_lock(&its->lock);
> +	its->cbaser = update_64bit_reg(its->cbaser, addr & 7, len, val);
> +	its->creadr = 0;
> +	/*
> +	 * CWRITER is architecturally UNKNOWN on reset, but we need to reset
> +	 * it to CREADR to make sure we start with an empty command buffer.
> +	 */
> +	its->cwriter = its->creadr;
> +	spin_unlock(&its->lock);
> +}
> +
> +#define ITS_CMD_BUFFER_SIZE(baser) ((((baser) & 0xff) + 1) << 12)
> +
> +/*
> + * By writing to CWRITER the guest announces new commands to be processed.
> + * Since we cannot read from guest memory inside the ITS spinlock, we
> + * iterate over the command buffer (with the lock dropped) until the read
> + * pointer matches the write pointer. Other VCPUs writing this register in the
> + * meantime will just update the write pointer, leaving the command
> + * processing to the first instance of the function.
> + */

[...]

I already expressed my concerns about how fragile this code is, and
offered an alternative. I'm not going to copy-paste them here, but my
comments still stand.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
