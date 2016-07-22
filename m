From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 36/55] KVM: arm64: vgic-its: Implement basic ITS register
 handlers
Date: Fri, 22 Jul 2016 18:28:53 +0100
Message-ID: <1469208552-4155-37-git-send-email-marc.zyngier@arm.com>
References: <1469208552-4155-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8DB5949BB0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jul 2016 13:24:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9Y0cr5r82Fcw for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Jul 2016 13:24:42 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 92B8849BD2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jul 2016 13:24:41 -0400 (EDT)
In-Reply-To: <1469208552-4155-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, Dan Carpenter <dan.carpenter@oracle.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Andre Przywara <andre.przywara@arm.com>

Add emulation for some basic MMIO registers used in the ITS emulation.
This includes:
- GITS_{CTLR,TYPER,IIDR}
- ID registers
- GITS_{CBASER,CREADR,CWRITER}
  (which implement the ITS command buffer handling)
- GITS_BASER<n>

Most of the handlers are pretty straight forward, only the CWRITER
handler is a bit more involved by taking the new its_cmd mutex and
then iterating over the command buffer.
The registers holding base addresses and attributes are sanitised before
storing them.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Tested-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 include/kvm/arm_vgic.h           |  16 ++
 virt/kvm/arm/vgic/vgic-its.c     | 399 +++++++++++++++++++++++++++++++++++++--
 virt/kvm/arm/vgic/vgic-mmio-v3.c |   8 +-
 virt/kvm/arm/vgic/vgic-mmio.h    |   6 +
 virt/kvm/arm/vgic/vgic.c         |  12 +-
 5 files changed, 420 insertions(+), 21 deletions(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 8609fac..6186749 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -22,6 +22,7 @@
 #include <linux/spinlock.h>
 #include <linux/types.h>
 #include <kvm/iodev.h>
+#include <linux/list.h>
 
 #define VGIC_V3_MAX_CPUS	255
 #define VGIC_V2_MAX_CPUS	8
@@ -136,6 +137,21 @@ struct vgic_its {
 	bool			enabled;
 	bool			initialized;
 	struct vgic_io_device	iodev;
+
+	/* These registers correspond to GITS_BASER{0,1} */
+	u64			baser_device_table;
+	u64			baser_coll_table;
+
+	/* Protects the command queue */
+	struct mutex		cmd_lock;
+	u64			cbaser;
+	u32			creadr;
+	u32			cwriter;
+
+	/* Protects the device and collection lists */
+	struct mutex		its_lock;
+	struct list_head	device_list;
+	struct list_head	collection_list;
 };
 
 struct vgic_dist {
diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 6b47b36..11cfe2f 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -21,6 +21,7 @@
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
 #include <linux/interrupt.h>
+#include <linux/list.h>
 #include <linux/uaccess.h>
 
 #include <linux/irqchip/arm-gic-v3.h>
@@ -32,6 +33,329 @@
 #include "vgic.h"
 #include "vgic-mmio.h"
 
+struct its_device {
+	struct list_head dev_list;
+
+	/* the head for the list of ITTEs */
+	struct list_head itt_head;
+	u32 device_id;
+};
+
+#define COLLECTION_NOT_MAPPED ((u32)~0)
+
+struct its_collection {
+	struct list_head coll_list;
+
+	u32 collection_id;
+	u32 target_addr;
+};
+
+#define its_is_collection_mapped(coll) ((coll) && \
+				((coll)->target_addr != COLLECTION_NOT_MAPPED))
+
+struct its_itte {
+	struct list_head itte_list;
+
+	struct its_collection *collection;
+	u32 lpi;
+	u32 event_id;
+};
+
+/*
+ * We only implement 48 bits of PA at the moment, although the ITS
+ * supports more. Let's be restrictive here.
+ */
+#define CBASER_ADDRESS(x)	((x) & GENMASK_ULL(47, 12))
+
+static unsigned long vgic_mmio_read_its_ctlr(struct kvm *vcpu,
+					     struct vgic_its *its,
+					     gpa_t addr, unsigned int len)
+{
+	u32 reg = 0;
+
+	mutex_lock(&its->cmd_lock);
+	if (its->creadr == its->cwriter)
+		reg |= GITS_CTLR_QUIESCENT;
+	if (its->enabled)
+		reg |= GITS_CTLR_ENABLE;
+	mutex_unlock(&its->cmd_lock);
+
+	return reg;
+}
+
+static void vgic_mmio_write_its_ctlr(struct kvm *kvm, struct vgic_its *its,
+				     gpa_t addr, unsigned int len,
+				     unsigned long val)
+{
+	its->enabled = !!(val & GITS_CTLR_ENABLE);
+}
+
+static unsigned long vgic_mmio_read_its_typer(struct kvm *kvm,
+					      struct vgic_its *its,
+					      gpa_t addr, unsigned int len)
+{
+	u64 reg = GITS_TYPER_PLPIS;
+
+	/*
+	 * We use linear CPU numbers for redistributor addressing,
+	 * so GITS_TYPER.PTA is 0.
+	 * Also we force all PROPBASER registers to be the same, so
+	 * CommonLPIAff is 0 as well.
+	 * To avoid memory waste in the guest, we keep the number of IDBits and
+	 * DevBits low - as least for the time being.
+	 */
+	reg |= 0x0f << GITS_TYPER_DEVBITS_SHIFT;
+	reg |= 0x0f << GITS_TYPER_IDBITS_SHIFT;
+
+	return extract_bytes(reg, addr & 7, len);
+}
+
+static unsigned long vgic_mmio_read_its_iidr(struct kvm *kvm,
+					     struct vgic_its *its,
+					     gpa_t addr, unsigned int len)
+{
+	return (PRODUCT_ID_KVM << 24) | (IMPLEMENTER_ARM << 0);
+}
+
+static unsigned long vgic_mmio_read_its_idregs(struct kvm *kvm,
+					       struct vgic_its *its,
+					       gpa_t addr, unsigned int len)
+{
+	switch (addr & 0xffff) {
+	case GITS_PIDR0:
+		return 0x92;	/* part number, bits[7:0] */
+	case GITS_PIDR1:
+		return 0xb4;	/* part number, bits[11:8] */
+	case GITS_PIDR2:
+		return GIC_PIDR2_ARCH_GICv3 | 0x0b;
+	case GITS_PIDR4:
+		return 0x40;	/* This is a 64K software visible page */
+	/* The following are the ID registers for (any) GIC. */
+	case GITS_CIDR0:
+		return 0x0d;
+	case GITS_CIDR1:
+		return 0xf0;
+	case GITS_CIDR2:
+		return 0x05;
+	case GITS_CIDR3:
+		return 0xb1;
+	}
+
+	return 0;
+}
+
+/* Requires the its_lock to be held. */
+static void its_free_itte(struct kvm *kvm, struct its_itte *itte)
+{
+	list_del(&itte->itte_list);
+	kfree(itte);
+}
+
+static int vgic_its_handle_command(struct kvm *kvm, struct vgic_its *its,
+				   u64 *its_cmd)
+{
+	return -ENODEV;
+}
+
+static u64 vgic_sanitise_its_baser(u64 reg)
+{
+	reg = vgic_sanitise_field(reg, GITS_BASER_SHAREABILITY_MASK,
+				  GITS_BASER_SHAREABILITY_SHIFT,
+				  vgic_sanitise_shareability);
+	reg = vgic_sanitise_field(reg, GITS_BASER_INNER_CACHEABILITY_MASK,
+				  GITS_BASER_INNER_CACHEABILITY_SHIFT,
+				  vgic_sanitise_inner_cacheability);
+	reg = vgic_sanitise_field(reg, GITS_BASER_OUTER_CACHEABILITY_MASK,
+				  GITS_BASER_OUTER_CACHEABILITY_SHIFT,
+				  vgic_sanitise_outer_cacheability);
+
+	/* Bits 15:12 contain bits 51:48 of the PA, which we don't support. */
+	reg &= ~GENMASK_ULL(15, 12);
+
+	/* We support only one (ITS) page size: 64K */
+	reg = (reg & ~GITS_BASER_PAGE_SIZE_MASK) | GITS_BASER_PAGE_SIZE_64K;
+
+	return reg;
+}
+
+static u64 vgic_sanitise_its_cbaser(u64 reg)
+{
+	reg = vgic_sanitise_field(reg, GITS_CBASER_SHAREABILITY_MASK,
+				  GITS_CBASER_SHAREABILITY_SHIFT,
+				  vgic_sanitise_shareability);
+	reg = vgic_sanitise_field(reg, GITS_CBASER_INNER_CACHEABILITY_MASK,
+				  GITS_CBASER_INNER_CACHEABILITY_SHIFT,
+				  vgic_sanitise_inner_cacheability);
+	reg = vgic_sanitise_field(reg, GITS_CBASER_OUTER_CACHEABILITY_MASK,
+				  GITS_CBASER_OUTER_CACHEABILITY_SHIFT,
+				  vgic_sanitise_outer_cacheability);
+
+	/*
+	 * Sanitise the physical address to be 64k aligned.
+	 * Also limit the physical addresses to 48 bits.
+	 */
+	reg &= ~(GENMASK_ULL(51, 48) | GENMASK_ULL(15, 12));
+
+	return reg;
+}
+
+static unsigned long vgic_mmio_read_its_cbaser(struct kvm *kvm,
+					       struct vgic_its *its,
+					       gpa_t addr, unsigned int len)
+{
+	return extract_bytes(its->cbaser, addr & 7, len);
+}
+
+static void vgic_mmio_write_its_cbaser(struct kvm *kvm, struct vgic_its *its,
+				       gpa_t addr, unsigned int len,
+				       unsigned long val)
+{
+	/* When GITS_CTLR.Enable is 1, this register is RO. */
+	if (its->enabled)
+		return;
+
+	mutex_lock(&its->cmd_lock);
+	its->cbaser = update_64bit_reg(its->cbaser, addr & 7, len, val);
+	its->cbaser = vgic_sanitise_its_cbaser(its->cbaser);
+	its->creadr = 0;
+	/*
+	 * CWRITER is architecturally UNKNOWN on reset, but we need to reset
+	 * it to CREADR to make sure we start with an empty command buffer.
+	 */
+	its->cwriter = its->creadr;
+	mutex_unlock(&its->cmd_lock);
+}
+
+#define ITS_CMD_BUFFER_SIZE(baser)	((((baser) & 0xff) + 1) << 12)
+#define ITS_CMD_SIZE			32
+#define ITS_CMD_OFFSET(reg)		((reg) & GENMASK(19, 5))
+
+/*
+ * By writing to CWRITER the guest announces new commands to be processed.
+ * To avoid any races in the first place, we take the its_cmd lock, which
+ * protects our ring buffer variables, so that there is only one user
+ * per ITS handling commands at a given time.
+ */
+static void vgic_mmio_write_its_cwriter(struct kvm *kvm, struct vgic_its *its,
+					gpa_t addr, unsigned int len,
+					unsigned long val)
+{
+	gpa_t cbaser;
+	u64 cmd_buf[4];
+	u32 reg;
+
+	if (!its)
+		return;
+
+	mutex_lock(&its->cmd_lock);
+
+	reg = update_64bit_reg(its->cwriter, addr & 7, len, val);
+	reg = ITS_CMD_OFFSET(reg);
+	if (reg >= ITS_CMD_BUFFER_SIZE(its->cbaser)) {
+		mutex_unlock(&its->cmd_lock);
+		return;
+	}
+
+	its->cwriter = reg;
+	cbaser = CBASER_ADDRESS(its->cbaser);
+
+	while (its->cwriter != its->creadr) {
+		int ret = kvm_read_guest(kvm, cbaser + its->creadr,
+					 cmd_buf, ITS_CMD_SIZE);
+		/*
+		 * If kvm_read_guest() fails, this could be due to the guest
+		 * programming a bogus value in CBASER or something else going
+		 * wrong from which we cannot easily recover.
+		 * According to section 6.3.2 in the GICv3 spec we can just
+		 * ignore that command then.
+		 */
+		if (!ret)
+			vgic_its_handle_command(kvm, its, cmd_buf);
+
+		its->creadr += ITS_CMD_SIZE;
+		if (its->creadr == ITS_CMD_BUFFER_SIZE(its->cbaser))
+			its->creadr = 0;
+	}
+
+	mutex_unlock(&its->cmd_lock);
+}
+
+static unsigned long vgic_mmio_read_its_cwriter(struct kvm *kvm,
+						struct vgic_its *its,
+						gpa_t addr, unsigned int len)
+{
+	return extract_bytes(its->cwriter, addr & 0x7, len);
+}
+
+static unsigned long vgic_mmio_read_its_creadr(struct kvm *kvm,
+					       struct vgic_its *its,
+					       gpa_t addr, unsigned int len)
+{
+	return extract_bytes(its->creadr, addr & 0x7, len);
+}
+
+#define BASER_INDEX(addr) (((addr) / sizeof(u64)) & 0x7)
+static unsigned long vgic_mmio_read_its_baser(struct kvm *kvm,
+					      struct vgic_its *its,
+					      gpa_t addr, unsigned int len)
+{
+	u64 reg;
+
+	switch (BASER_INDEX(addr)) {
+	case 0:
+		reg = its->baser_device_table;
+		break;
+	case 1:
+		reg = its->baser_coll_table;
+		break;
+	default:
+		reg = 0;
+		break;
+	}
+
+	return extract_bytes(reg, addr & 7, len);
+}
+
+#define GITS_BASER_RO_MASK	(GENMASK_ULL(52, 48) | GENMASK_ULL(58, 56))
+static void vgic_mmio_write_its_baser(struct kvm *kvm,
+				      struct vgic_its *its,
+				      gpa_t addr, unsigned int len,
+				      unsigned long val)
+{
+	u64 entry_size, device_type;
+	u64 reg, *regptr, clearbits = 0;
+
+	/* When GITS_CTLR.Enable is 1, we ignore write accesses. */
+	if (its->enabled)
+		return;
+
+	switch (BASER_INDEX(addr)) {
+	case 0:
+		regptr = &its->baser_device_table;
+		entry_size = 8;
+		device_type = GITS_BASER_TYPE_DEVICE;
+		break;
+	case 1:
+		regptr = &its->baser_coll_table;
+		entry_size = 8;
+		device_type = GITS_BASER_TYPE_COLLECTION;
+		clearbits = GITS_BASER_INDIRECT;
+		break;
+	default:
+		return;
+	}
+
+	reg = update_64bit_reg(*regptr, addr & 7, len, val);
+	reg &= ~GITS_BASER_RO_MASK;
+	reg &= ~clearbits;
+
+	reg |= (entry_size - 1) << GITS_BASER_ENTRY_SIZE_SHIFT;
+	reg |= device_type << GITS_BASER_TYPE_SHIFT;
+	reg = vgic_sanitise_its_baser(reg);
+
+	*regptr = reg;
+}
+
 #define REGISTER_ITS_DESC(off, rd, wr, length, acc)		\
 {								\
 	.reg_offset = off,					\
@@ -41,12 +365,6 @@
 	.its_write = wr,					\
 }
 
-static unsigned long its_mmio_read_raz(struct kvm *kvm, struct vgic_its *its,
-				       gpa_t addr, unsigned int len)
-{
-	return 0;
-}
-
 static void its_mmio_write_wi(struct kvm *kvm, struct vgic_its *its,
 			      gpa_t addr, unsigned int len, unsigned long val)
 {
@@ -55,28 +373,28 @@ static void its_mmio_write_wi(struct kvm *kvm, struct vgic_its *its,
 
 static struct vgic_register_region its_registers[] = {
 	REGISTER_ITS_DESC(GITS_CTLR,
-		its_mmio_read_raz, its_mmio_write_wi, 4,
+		vgic_mmio_read_its_ctlr, vgic_mmio_write_its_ctlr, 4,
 		VGIC_ACCESS_32bit),
 	REGISTER_ITS_DESC(GITS_IIDR,
-		its_mmio_read_raz, its_mmio_write_wi, 4,
+		vgic_mmio_read_its_iidr, its_mmio_write_wi, 4,
 		VGIC_ACCESS_32bit),
 	REGISTER_ITS_DESC(GITS_TYPER,
-		its_mmio_read_raz, its_mmio_write_wi, 8,
+		vgic_mmio_read_its_typer, its_mmio_write_wi, 8,
 		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
 	REGISTER_ITS_DESC(GITS_CBASER,
-		its_mmio_read_raz, its_mmio_write_wi, 8,
+		vgic_mmio_read_its_cbaser, vgic_mmio_write_its_cbaser, 8,
 		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
 	REGISTER_ITS_DESC(GITS_CWRITER,
-		its_mmio_read_raz, its_mmio_write_wi, 8,
+		vgic_mmio_read_its_cwriter, vgic_mmio_write_its_cwriter, 8,
 		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
 	REGISTER_ITS_DESC(GITS_CREADR,
-		its_mmio_read_raz, its_mmio_write_wi, 8,
+		vgic_mmio_read_its_creadr, its_mmio_write_wi, 8,
 		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
 	REGISTER_ITS_DESC(GITS_BASER,
-		its_mmio_read_raz, its_mmio_write_wi, 0x40,
+		vgic_mmio_read_its_baser, vgic_mmio_write_its_baser, 0x40,
 		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
 	REGISTER_ITS_DESC(GITS_IDREGS_BASE,
-		its_mmio_read_raz, its_mmio_write_wi, 0x30,
+		vgic_mmio_read_its_idregs, its_mmio_write_wi, 0x30,
 		VGIC_ACCESS_32bit),
 };
 
@@ -109,6 +427,18 @@ static int vgic_its_init_its(struct kvm *kvm, struct vgic_its *its)
 	return ret;
 }
 
+#define INITIAL_BASER_VALUE						  \
+	(GIC_BASER_CACHEABILITY(GITS_BASER, INNER, RaWb)		| \
+	 GIC_BASER_CACHEABILITY(GITS_BASER, OUTER, SameAsInner)		| \
+	 GIC_BASER_SHAREABILITY(GITS_BASER, InnerShareable)		| \
+	 ((8ULL - 1) << GITS_BASER_ENTRY_SIZE_SHIFT)			| \
+	 GITS_BASER_PAGE_SIZE_64K)
+
+#define INITIAL_PROPBASER_VALUE						  \
+	(GIC_BASER_CACHEABILITY(GICR_PROPBASER, INNER, RaWb)		| \
+	 GIC_BASER_CACHEABILITY(GICR_PROPBASER, OUTER, SameAsInner)	| \
+	 GIC_BASER_SHAREABILITY(GICR_PROPBASER, InnerShareable))
+
 static int vgic_its_create(struct kvm_device *dev, u32 type)
 {
 	struct vgic_its *its;
@@ -120,12 +450,24 @@ static int vgic_its_create(struct kvm_device *dev, u32 type)
 	if (!its)
 		return -ENOMEM;
 
+	mutex_init(&its->its_lock);
+	mutex_init(&its->cmd_lock);
+
 	its->vgic_its_base = VGIC_ADDR_UNDEF;
 
+	INIT_LIST_HEAD(&its->device_list);
+	INIT_LIST_HEAD(&its->collection_list);
+
 	dev->kvm->arch.vgic.has_its = true;
 	its->initialized = false;
 	its->enabled = false;
 
+	its->baser_device_table = INITIAL_BASER_VALUE			|
+		((u64)GITS_BASER_TYPE_DEVICE << GITS_BASER_TYPE_SHIFT);
+	its->baser_coll_table = INITIAL_BASER_VALUE |
+		((u64)GITS_BASER_TYPE_COLLECTION << GITS_BASER_TYPE_SHIFT);
+	dev->kvm->arch.vgic.propbaser = INITIAL_PROPBASER_VALUE;
+
 	dev->private = its;
 
 	return 0;
@@ -133,7 +475,36 @@ static int vgic_its_create(struct kvm_device *dev, u32 type)
 
 static void vgic_its_destroy(struct kvm_device *kvm_dev)
 {
+	struct kvm *kvm = kvm_dev->kvm;
 	struct vgic_its *its = kvm_dev->private;
+	struct its_device *dev;
+	struct its_itte *itte;
+	struct list_head *dev_cur, *dev_temp;
+	struct list_head *cur, *temp;
+
+	/*
+	 * We may end up here without the lists ever having been initialized.
+	 * Check this and bail out early to avoid dereferencing a NULL pointer.
+	 */
+	if (!its->device_list.next)
+		return;
+
+	mutex_lock(&its->its_lock);
+	list_for_each_safe(dev_cur, dev_temp, &its->device_list) {
+		dev = container_of(dev_cur, struct its_device, dev_list);
+		list_for_each_safe(cur, temp, &dev->itt_head) {
+			itte = (container_of(cur, struct its_itte, itte_list));
+			its_free_itte(kvm, itte);
+		}
+		list_del(dev_cur);
+		kfree(dev);
+	}
+
+	list_for_each_safe(cur, temp, &its->collection_list) {
+		list_del(cur);
+		kfree(container_of(cur, struct its_collection, coll_list));
+	}
+	mutex_unlock(&its->its_lock);
 
 	kfree(its);
 }
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index a5c3505..84a301d 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -23,15 +23,15 @@
 #include "vgic-mmio.h"
 
 /* extract @num bytes at @offset bytes offset in data */
-static unsigned long extract_bytes(unsigned long data, unsigned int offset,
-				   unsigned int num)
+unsigned long extract_bytes(unsigned long data, unsigned int offset,
+			    unsigned int num)
 {
 	return (data >> (offset * 8)) & GENMASK_ULL(num * 8 - 1, 0);
 }
 
 /* allows updates of any half of a 64-bit register (or the whole thing) */
-static u64 update_64bit_reg(u64 reg, unsigned int offset, unsigned int len,
-			    unsigned long val)
+u64 update_64bit_reg(u64 reg, unsigned int offset, unsigned int len,
+		     unsigned long val)
 {
 	int lower = (offset & 4) * 8;
 	int upper = lower + 8 * len - 1;
diff --git a/virt/kvm/arm/vgic/vgic-mmio.h b/virt/kvm/arm/vgic/vgic-mmio.h
index 366d663..0b3ecf9 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.h
+++ b/virt/kvm/arm/vgic/vgic-mmio.h
@@ -96,6 +96,12 @@ unsigned long vgic_data_mmio_bus_to_host(const void *val, unsigned int len);
 void vgic_data_host_to_mmio_bus(void *buf, unsigned int len,
 				unsigned long data);
 
+unsigned long extract_bytes(unsigned long data, unsigned int offset,
+			    unsigned int num);
+
+u64 update_64bit_reg(u64 reg, unsigned int offset, unsigned int len,
+		     unsigned long val);
+
 unsigned long vgic_mmio_read_raz(struct kvm_vcpu *vcpu,
 				 gpa_t addr, unsigned int len);
 
diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index fb19a55..d3ba1b4 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -33,10 +33,16 @@ struct vgic_global __section(.hyp.text) kvm_vgic_global_state;
 
 /*
  * Locking order is always:
- *   vgic_cpu->ap_list_lock
- *     vgic_irq->irq_lock
+ * its->cmd_lock (mutex)
+ *   its->its_lock (mutex)
+ *     vgic_cpu->ap_list_lock
+ *       vgic_irq->irq_lock
  *
- * (that is, always take the ap_list_lock before the struct vgic_irq lock).
+ * If you need to take multiple locks, always take the upper lock first,
+ * then the lower ones, e.g. first take the its_lock, then the irq_lock.
+ * If you are already holding a lock and need to take a higher one, you
+ * have to drop the lower ranking lock first and re-aquire it after having
+ * taken the upper one.
  *
  * When taking more than one ap_list_lock at the same time, always take the
  * lowest numbered VCPU's ap_list_lock first, so:
-- 
2.8.1
