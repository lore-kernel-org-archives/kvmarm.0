From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v6 09/15] KVM: arm64: implement basic ITS register handlers
Date: Wed, 22 Jun 2016 17:19:48 +0100
Message-ID: <576ABAA4.4000606@arm.com>
References: <1466165327-32060-1-git-send-email-andre.przywara@arm.com>
 <1466165327-32060-10-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C6C449B35
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jun 2016 12:15:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ko3f-NFr8fOh for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Jun 2016 12:14:58 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D95749B2F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jun 2016 12:14:57 -0400 (EDT)
In-Reply-To: <1466165327-32060-10-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 17/06/16 13:08, Andre Przywara wrote:
> Add emulation for some basic MMIO registers used in the ITS emulation.
> This includes:
> - GITS_{CTLR,TYPER,IIDR}
> - ID registers
> - GITS_{CBASER,CREADR,CWRITER}
>   (which implement the ITS command buffer handling)
> - GITS_BASER<n>
> 
> Most of the handlers are pretty straight forward, only the CWRITER
> handler is a bit more involved by taking the new its_cmd mutex and
> then iterating over the command buffer.
> The registers holding base addresses and attributes are sanitised before
> storing them.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  include/kvm/vgic/vgic.h            |  15 ++
>  include/linux/irqchip/arm-gic-v3.h |  11 ++
>  virt/kvm/arm/vgic/vgic-its.c       | 343 +++++++++++++++++++++++++++++++++++--
>  virt/kvm/arm/vgic/vgic-mmio-v3.c   |  15 +-
>  virt/kvm/arm/vgic/vgic-mmio.h      |  10 ++
>  5 files changed, 380 insertions(+), 14 deletions(-)
> 
> diff --git a/include/kvm/vgic/vgic.h b/include/kvm/vgic/vgic.h
> index 979d8c3..891775e 100644
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
> @@ -126,6 +127,20 @@ struct vgic_its {
>  
>  	bool			enabled;
>  	struct vgic_io_device	iodev;
> +
> +	u64			baser_device_table;
> +	u64			baser_coll_table;

Maybe add a comment saying that these correspond to GITS_BASER{0,1}?

> +
> +	/* Protects the command queue */
> +	struct mutex		cmd_lock;
> +	u64			cbaser;
> +	u32			creadr;
> +	u32			cwriter;
> +
> +	/* Protects the device and collection lists */
> +	struct mutex		its_lock;
> +	struct list_head	device_list;
> +	struct list_head	collection_list;
>  };
>  
>  struct vgic_dist {
> diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
> index 92d5da8..fe5a7fe 100644
> --- a/include/linux/irqchip/arm-gic-v3.h
> +++ b/include/linux/irqchip/arm-gic-v3.h
> @@ -177,16 +177,26 @@
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
> @@ -214,6 +224,7 @@
>  #define GITS_BASER_WaWb			(5UL << 59)
>  #define GITS_BASER_RaWaWt		(6UL << 59)
>  #define GITS_BASER_RaWaWb		(7UL << 59)
> +#define GITS_BASER_CACHEABILITY_SHIFT	(59)

If you start adding this, please express all the GITS_BASER_*
cacheability attributes in terms of the shift you've defined.

>  #define GITS_BASER_CACHEABILITY_MASK	(7UL << 59)
>  #define GITS_BASER_TYPE_SHIFT		(56)
>  #define GITS_BASER_TYPE(r)		(((r) >> GITS_BASER_TYPE_SHIFT) & 7)
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index 4ae3c82..d7f8834 100644
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
> @@ -32,6 +33,289 @@
>  #include "vgic.h"
>  #include "vgic-mmio.h"
>  
> +struct its_device {
> +	struct list_head dev_list;
> +
> +	/* the head for the list of ITTEs */
> +	struct list_head itt_head;
> +	u32 device_id;
> +};
> +
> +#define COLLECTION_NOT_MAPPED ((u32)-1)

Nit: I always shiver when I see -1 cast to an unsigned value. How about
((u32)~0) instead?

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
> +#define CBASER_ADDRESS(x)	((x) & GENMASK_ULL(51, 12))
> +#define BASER_ADDRESS(x)	((x) & GENMASK_ULL(47, 12))

Warning, this is a slippery one. From the spec:

<quote>
When Page_Size is 64KB:
- Bits[47:16] of the register provide bits[47:16] of the base physical
address of the table.
- Bits[15:12] of the register provide bits[51:48] of the base physical
address of the table.
- Bits[15:0] of the base physical address are 0.

In implementations that support fewer than 52 bits of physical address,
any unimplemented upper bits may be RAZ/WI.
</quote>

Can you please define what you are planning to support here?
CBASER_ADDRESS tends to indicate that you're in for 52bit PAs, but
BASER_ADDRESS suggests otherwise.

> +
> +#define ITS_FRAME(addr) ((addr) & ~(SZ_64K - 1))
> +
> +static unsigned long vgic_mmio_read_its_ctlr(struct kvm *vcpu,
> +					     struct vgic_its *its,
> +					     gpa_t addr, unsigned int len)
> +{
> +	u32 reg = 0;
> +
> +	mutex_lock(&its->cmd_lock);
> +	if (its->creadr == its->cwriter)
> +		reg |= GITS_CTLR_QUIESCENT;
> +	if (its->enabled)
> +		reg |= GITS_CTLR_ENABLE;
> +	mutex_unlock(&its->cmd_lock);
> +
> +	return reg;
> +}
> +
> +static void vgic_mmio_write_its_ctlr(struct kvm *kvm, struct vgic_its *its,
> +				     gpa_t addr, unsigned int len,
> +				     unsigned long val)
> +{
> +	its->enabled = !!(val & GITS_CTLR_ENABLE);
> +}
> +
> +static unsigned long vgic_mmio_read_its_typer(struct kvm *kvm,
> +					      struct vgic_its *its,
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

I though I had convinced you to get rid of the HW collections??? What is
happening here?

> +	reg |= 0x0f << GITS_TYPER_DEVBITS_SHIFT;
> +	reg |= 0x0f << GITS_TYPER_IDBITS_SHIFT;
> +
> +	return extract_bytes(reg, addr & 7, len);
> +}
> +
> +static unsigned long vgic_mmio_read_its_iidr(struct kvm *kvm,
> +					     struct vgic_its *its,
> +					     gpa_t addr, unsigned int len)
> +{
> +	return (PRODUCT_ID_KVM << 24) | (IMPLEMENTER_ARM << 0);
> +}
> +
> +static unsigned long vgic_mmio_read_its_idregs(struct kvm *kvm,
> +					       struct vgic_its *its,
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

Please document the locking requirements.

> +}
> +
> +static int vits_handle_command(struct kvm *kvm, struct vgic_its *its,
> +			       u64 *its_cmd)
> +{
> +	return -ENODEV;
> +}
> +
> +static unsigned long vgic_mmio_read_its_cbaser(struct kvm *kvm,
> +					       struct vgic_its *its,
> +					       gpa_t addr, unsigned int len)
> +{
> +	return extract_bytes(its->cbaser, addr & 7, len);
> +}
> +
> +static void vgic_mmio_write_its_cbaser(struct kvm *kvm, struct vgic_its *its,
> +				       gpa_t addr, unsigned int len,
> +				       unsigned long val)
> +{
> +	/* When GITS_CTLR.Enable is 1, this register is RO. */
> +	if (its->enabled)
> +		return;
> +
> +	mutex_lock(&its->cmd_lock);
> +	its->cbaser = update_64bit_reg(its->cbaser, addr & 7, len, val);
> +	vgic_sanitise_its_baser(&its->cbaser);
> +	its->creadr = 0;
> +	/*
> +	 * CWRITER is architecturally UNKNOWN on reset, but we need to reset
> +	 * it to CREADR to make sure we start with an empty command buffer.
> +	 */
> +	its->cwriter = its->creadr;
> +	mutex_unlock(&its->cmd_lock);
> +}
> +
> +#define ITS_CMD_BUFFER_SIZE(baser) ((((baser) & 0xff) + 1) << 12)
> +
> +/*
> + * By writing to CWRITER the guest announces new commands to be processed.
> + * To avoid any races in the first place, we take the its_cmd lock, which
> + * protects our ring buffer variables, so that there is only one user
> + * per ITS handling commands at a given time.
> + */
> +static void vgic_mmio_write_its_cwriter(struct kvm *kvm, struct vgic_its *its,
> +					gpa_t addr, unsigned int len,
> +					unsigned long val)
> +{
> +	gpa_t cbaser;
> +	u64 cmd_buf[4];
> +	u32 reg;
> +
> +	if (!its)
> +		return;
> +
> +	cbaser = CBASER_ADDRESS(its->cbaser);
> +
> +	reg = update_64bit_reg(its->cwriter & 0xfffe0, addr & 7, len, val);
> +	reg &= 0xfffe0;
> +	if (reg > ITS_CMD_BUFFER_SIZE(its->cbaser))
> +		return;
> +
> +	mutex_lock(&its->cmd_lock);
> +
> +	its->cwriter = reg;
> +
> +	while (its->cwriter != its->creadr) {
> +		int ret = kvm_read_guest(kvm, cbaser + its->creadr,
> +					 cmd_buf, 32);

How about having a #define for this 32? Or even better, make struct
its_cmd_block available and use it all over the map?

> +		if (ret) {
> +			/*
> +			 * Gah, we are screwed. Either the guest programmed
> +			 * bogus values in CBASER or something else went
> +			 * wrong from which we cannot easily recover.
> +			 * Reset CWRITER to the command that we have finished
> +			 * processing and return.
> +			 */
> +			its->cwriter = its->creadr;
> +			break;

Have you looked at 6.3.2 (Command errors) recently? It now describes the
acceptable behaviours (yeah, it took a long time...), and the behaviour
you have here doesn't seem to be acceptable (it is a mix between
"ignore" and "stall"). I suggest that you implement ignore (dead easy),
and we can upgrade it to stall later.

> +		}
> +		vits_handle_command(kvm, its, cmd_buf);
> +
> +		its->creadr += 32;
> +		if (its->creadr == ITS_CMD_BUFFER_SIZE(its->cbaser))
> +			its->creadr = 0;
> +	}
> +
> +	mutex_unlock(&its->cmd_lock);

Overall, this function looks much better than the previous versions.

> +}
> +
> +static unsigned long vgic_mmio_read_its_cwriter(struct kvm *kvm,
> +						struct vgic_its *its,
> +						gpa_t addr, unsigned int len)
> +{
> +	return extract_bytes(its->cwriter & 0xfffe0, addr & 0x7, len);
> +}
> +
> +static unsigned long vgic_mmio_read_its_creadr(struct kvm *kvm,
> +					       struct vgic_its *its,
> +					       gpa_t addr, unsigned int len)
> +{
> +	return extract_bytes(its->creadr & 0xfffe0, addr & 0x7, len);
> +}
> +
> +#define BASER_INDEX(addr) (((addr) / sizeof(u64)) & 0x7)
> +static unsigned long vgic_mmio_read_its_baser(struct kvm *kvm,
> +					      struct vgic_its *its,
> +					      gpa_t addr, unsigned int len)
> +{
> +	u64 reg;
> +
> +	switch (BASER_INDEX(addr)) {
> +	case 0:
> +		reg = its->baser_device_table;
> +		break;
> +	case 1:
> +		reg = its->baser_coll_table;
> +		break;
> +	default:
> +		reg = 0;
> +		break;
> +	}
> +
> +	return extract_bytes(reg, addr & 7, len);
> +}
> +
> +#define GITS_BASER_RO_MASK	\
> +	((0x1fLL << GITS_BASER_ENTRY_SIZE_SHIFT) | \
> +	 (0x07LL << GITS_BASER_TYPE_SHIFT))

GENMASK_ULL?

> +static void vgic_mmio_write_its_baser(struct kvm *kvm,
> +				      struct vgic_its *its,
> +				      gpa_t addr, unsigned int len,
> +				      unsigned long val)
> +{
> +	u64 reg, *regptr;
> +	u64 entry_size, device_type;
> +
> +	/* When GITS_CTLR.Enable is 1, we ignore write accesses. */
> +	if (its->enabled)
> +		return;
> +
> +	switch (BASER_INDEX(addr)) {
> +	case 0:
> +		regptr = &its->baser_device_table;
> +		entry_size = 8;
> +		device_type = GITS_BASER_TYPE_DEVICE;
> +		break;
> +	case 1:
> +		regptr = &its->baser_coll_table;
> +		entry_size = 8;
> +		device_type = GITS_BASER_TYPE_COLLECTION;
> +		break;
> +	default:
> +		return;
> +	}
> +
> +	reg = update_64bit_reg(*regptr, addr & 7, len, val);
> +	reg &= ~GITS_BASER_RO_MASK;
> +	reg |= (entry_size - 1) << GITS_BASER_ENTRY_SIZE_SHIFT;
> +	reg |= device_type << GITS_BASER_TYPE_SHIFT;
> +	vgic_sanitise_its_baser(&reg);
> +
> +	*regptr = reg;
> +}
> +
>  #define REGISTER_ITS_DESC(off, rd, wr, length, acc)		\
>  {								\
>  	.reg_offset = off,					\
> @@ -43,8 +327,8 @@
>  	.its_write = wr,					\
>  }
>  
> -static unsigned long its_mmio_read_raz(struct kvm *kvm, struct vgic_its *its,
> -				       gpa_t addr, unsigned int len)
> +unsigned long its_mmio_read_raz(struct kvm *kvm, struct vgic_its *its,
> +				gpa_t addr, unsigned int len)
>  {
>  	return 0;
>  }
> @@ -57,28 +341,28 @@ static void its_mmio_write_wi(struct kvm *kvm, struct vgic_its *its,
>  
>  struct vgic_register_region its_registers[] = {
>  	REGISTER_ITS_DESC(GITS_CTLR,
> -		its_mmio_read_raz, its_mmio_write_wi, 4,
> +		vgic_mmio_read_its_ctlr, vgic_mmio_write_its_ctlr, 4,
>  		VGIC_ACCESS_32bit),
>  	REGISTER_ITS_DESC(GITS_IIDR,
> -		its_mmio_read_raz, its_mmio_write_wi, 4,
> +		vgic_mmio_read_its_iidr, its_mmio_write_wi, 4,
>  		VGIC_ACCESS_32bit),
>  	REGISTER_ITS_DESC(GITS_TYPER,
> -		its_mmio_read_raz, its_mmio_write_wi, 8,
> +		vgic_mmio_read_its_typer, its_mmio_write_wi, 8,
>  		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
>  	REGISTER_ITS_DESC(GITS_CBASER,
> -		its_mmio_read_raz, its_mmio_write_wi, 8,
> +		vgic_mmio_read_its_cbaser, vgic_mmio_write_its_cbaser, 8,
>  		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
>  	REGISTER_ITS_DESC(GITS_CWRITER,
> -		its_mmio_read_raz, its_mmio_write_wi, 8,
> +		vgic_mmio_read_its_cwriter, vgic_mmio_write_its_cwriter, 8,
>  		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
>  	REGISTER_ITS_DESC(GITS_CREADR,
> -		its_mmio_read_raz, its_mmio_write_wi, 8,
> +		vgic_mmio_read_its_creadr, its_mmio_write_wi, 8,
>  		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
>  	REGISTER_ITS_DESC(GITS_BASER,
> -		its_mmio_read_raz, its_mmio_write_wi, 0x40,
> +		vgic_mmio_read_its_baser, vgic_mmio_write_its_baser, 0x40,
>  		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
>  	REGISTER_ITS_DESC(GITS_IDREGS_BASE,
> -		its_mmio_read_raz, its_mmio_write_wi, 0x30,
> +		vgic_mmio_read_its_idregs, its_mmio_write_wi, 0x30,
>  		VGIC_ACCESS_32bit),
>  };
>  
> @@ -103,10 +387,40 @@ static int vits_register(struct kvm *kvm, struct vgic_its *its)
>  
>  static void vits_destroy(struct kvm *kvm, struct vgic_its *its)
>  {
> +	struct its_device *dev;
> +	struct its_itte *itte;
> +	struct list_head *dev_cur, *dev_temp;
> +	struct list_head *cur, *temp;
> +
> +	/*
> +	 * We may end up here without the lists ever having been initialized.
> +	 * Check this and bail out early to avoid dereferencing a NULL pointer.
> +	 */
> +	if (!its->device_list.next)
> +		return;
> +
> +	mutex_lock(&its->its_lock);
> +	list_for_each_safe(dev_cur, dev_temp, &its->device_list) {
> +		dev = container_of(dev_cur, struct its_device, dev_list);
> +		list_for_each_safe(cur, temp, &dev->itt_head) {
> +			itte = (container_of(cur, struct its_itte, itte_list));
> +			its_free_itte(itte);
> +		}
> +		list_del(dev_cur);
> +		kfree(dev);
> +	}
> +
> +	list_for_each_safe(cur, temp, &its->collection_list) {
> +		list_del(cur);
> +		kfree(container_of(cur, struct its_collection, coll_list));
> +	}
> +	mutex_unlock(&its->its_lock);
>  
>  	its->enabled = false;
>  }
>  
> +#define INITIAL_BASER_VALUE	(GITS_BASER_WaWb | GITS_BASER_PAGE_SIZE_64K)

How about the entry size? Shareability? The type? An ITS driver won't
even use this because the type is 0 (just boot a guest and tell me what
tables are allocated...). Grmbl...

> +
>  static int vgic_its_create(struct kvm_device *dev, u32 type)
>  {
>  	struct vgic_its *its;
> @@ -118,11 +432,20 @@ static int vgic_its_create(struct kvm_device *dev, u32 type)
>  	if (!its)
>  		return -ENOMEM;
>  
> +	mutex_init(&its->its_lock);
> +	mutex_init(&its->cmd_lock);
> +
>  	its->vgic_its_base = VGIC_ADDR_UNDEF;
>  
> +	INIT_LIST_HEAD(&its->device_list);
> +	INIT_LIST_HEAD(&its->collection_list);
> +
>  	dev->kvm->arch.vgic.has_its = true;
>  	its->enabled = false;
>  
> +	its->baser_device_table = INITIAL_BASER_VALUE;

I also asked for the device table to advertize indirect support. Can't
see it anywhere, unfortunately.

> +	its->baser_coll_table = INITIAL_BASER_VALUE;
> +
>  	dev->private = its;
>  
>  	return 0;
> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> index 3a72308..da74d67 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> @@ -23,15 +23,15 @@
>  #include "vgic-mmio.h"
>  
>  /* extract @num bytes at @offset bytes offset in data */
> -static unsigned long extract_bytes(unsigned long data, unsigned int offset,
> -				   unsigned int num)
> +unsigned long extract_bytes(unsigned long data, unsigned int offset,
> +			    unsigned int num)
>  {
>  	return (data >> (offset * 8)) & GENMASK_ULL(num * 8 - 1, 0);
>  }
>  
>  /* allows updates of any half of a 64-bit register (or the whole thing) */
> -static u64 update_64bit_reg(u64 reg, unsigned int offset, unsigned int len,
> -			    unsigned long val)
> +u64 update_64bit_reg(u64 reg, unsigned int offset, unsigned int len,
> +		     unsigned long val)
>  {
>  	int lower = (offset & 4) * 8;
>  	int upper = lower + 8 * len - 1;
> @@ -239,6 +239,13 @@ static void vgic_sanitise_redist_baser(u64 *reg)
>  	vgic_sanitise_outer_cacheability(reg, 56);
>  }
>  
> +void vgic_sanitise_its_baser(u64 *reg)
> +{
> +	vgic_sanitise_shareability(reg);
> +	vgic_sanitise_inner_cacheability(reg, GITS_BASER_CACHEABILITY_SHIFT);
> +	vgic_sanitise_outer_cacheability(reg, 53);
> +}

As previous patches, drop these and do in in the accessor.

> +
>  #define PROPBASER_RES0_MASK 0xf8f0000000000060
>  #define PENDBASER_RES0_MASK 0xb8f000000000f07f
>  
> diff --git a/virt/kvm/arm/vgic/vgic-mmio.h b/virt/kvm/arm/vgic/vgic-mmio.h
> index 6dfc2f0..f6fd662 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio.h
> +++ b/virt/kvm/arm/vgic/vgic-mmio.h
> @@ -91,6 +91,12 @@ unsigned long vgic_data_mmio_bus_to_host(const void *val, unsigned int len);
>  void vgic_data_host_to_mmio_bus(void *buf, unsigned int len,
>  				unsigned long data);
>  
> +unsigned long extract_bytes(unsigned long data, unsigned int offset,
> +			    unsigned int num);
> +
> +u64 update_64bit_reg(u64 reg, unsigned int offset, unsigned int len,
> +		     unsigned long val);
> +
>  unsigned long vgic_mmio_read_raz(struct kvm_vcpu *vcpu,
>  				 gpa_t addr, unsigned int len);
>  
> @@ -151,4 +157,8 @@ unsigned int vgic_v2_init_dist_iodev(struct vgic_io_device *dev);
>  
>  unsigned int vgic_v3_init_dist_iodev(struct vgic_io_device *dev);
>  
> +#ifdef CONFIG_KVM_ARM_VGIC_V3
> +void vgic_sanitise_its_baser(u64 *reg);
> +#endif
> +
>  #endif
> 

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
