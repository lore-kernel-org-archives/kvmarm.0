From: Eric Auger <eric.auger@redhat.com>
Subject: [RFC 07/13] KVM: arm64: ITS: Change entry_size and indirect bit in
 BASER
Date: Thu, 12 Jan 2017 16:56:47 +0100
Message-ID: <1484236613-24633-8-git-send-email-eric.auger@redhat.com>
References: <1484236613-24633-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D06140284
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Jan 2017 10:55:41 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NhfMuH78aGDQ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Jan 2017 10:55:40 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C69C840670
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Jan 2017 10:55:40 -0500 (EST)
In-Reply-To: <1484236613-24633-1-git-send-email-eric.auger@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, peter.maydell@linaro.org, linux-arm-kernel@lists.infradead.org, drjones@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: andre.przywara@arm.com, pbonzini@redhat.com, dgilbert@redhat.com, Prasun.Kapoor@cavium.com
List-Id: kvmarm@lists.cs.columbia.edu

Change the device table entry_size to 16 bytes instead of 8.
We also Store the device and collection device in the its
struct.

The patch also clears the indirect bit for the device BASER.
The indirect bit is set as read-only.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

TODO: investigate support of 2 level tables, ie. enabling
Indirect = 1. Support of 2 level tables is implementation
defined.
---
 include/kvm/arm_vgic.h       |  3 +++
 virt/kvm/arm/vgic/vgic-its.c | 25 ++++++++++++++++---------
 2 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 730a18a..e6fc727 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -156,6 +156,9 @@ struct vgic_its {
 	u64			baser_device_table;
 	u64			baser_coll_table;
 
+	size_t			device_table_size;
+	size_t			collection_table_size;
+
 	/* Protects the command queue */
 	struct mutex		cmd_lock;
 	u64			cbaser;
diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 96378b8..358ae38 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -34,6 +34,8 @@
 #include "vgic-mmio.h"
 
 #define ITTE_SIZE 16
+#define DEV_ENTRY_SIZE 16
+#define COLL_ENTRY_SIZE 16
 
 /*
  * Creates a new (reference to a) struct vgic_irq for a given LPI.
@@ -1269,14 +1271,16 @@ static unsigned long vgic_mmio_read_its_baser(struct kvm *kvm,
 	return extract_bytes(reg, addr & 7, len);
 }
 
-#define GITS_BASER_RO_MASK	(GENMASK_ULL(52, 48) | GENMASK_ULL(58, 56))
+#define GITS_BASER_RO_MASK	(GENMASK_ULL(52, 48) | GENMASK_ULL(58, 56) | \
+				 GENMASK_ULL(62, 62))
 static void vgic_mmio_write_its_baser(struct kvm *kvm,
 				      struct vgic_its *its,
 				      gpa_t addr, unsigned int len,
 				      unsigned long val)
 {
 	u64 entry_size, device_type;
-	u64 reg, *regptr, clearbits = 0;
+	u64 reg, *regptr;
+	size_t *psize;
 
 	/* When GITS_CTLR.Enable is 1, we ignore write accesses. */
 	if (its->enabled)
@@ -1285,14 +1289,15 @@ static void vgic_mmio_write_its_baser(struct kvm *kvm,
 	switch (BASER_INDEX(addr)) {
 	case 0:
 		regptr = &its->baser_device_table;
-		entry_size = 8;
+		entry_size = DEV_ENTRY_SIZE;
 		device_type = GITS_BASER_TYPE_DEVICE;
+		psize = &its->device_table_size;
 		break;
 	case 1:
 		regptr = &its->baser_coll_table;
-		entry_size = 8;
+		entry_size = COLL_ENTRY_SIZE;
 		device_type = GITS_BASER_TYPE_COLLECTION;
-		clearbits = GITS_BASER_INDIRECT;
+		psize = &its->collection_table_size;
 		break;
 	default:
 		return;
@@ -1300,12 +1305,13 @@ static void vgic_mmio_write_its_baser(struct kvm *kvm,
 
 	reg = update_64bit_reg(*regptr, addr & 7, len, val);
 	reg &= ~GITS_BASER_RO_MASK;
-	reg &= ~clearbits;
 
 	reg |= (entry_size - 1) << GITS_BASER_ENTRY_SIZE_SHIFT;
 	reg |= device_type << GITS_BASER_TYPE_SHIFT;
 	reg = vgic_sanitise_its_baser(reg);
 
+	*psize = ((reg & 0xFF) + 1) << 16;
+
 	*regptr = reg;
 }
 
@@ -1390,7 +1396,6 @@ static int vgic_register_its_iodev(struct kvm *kvm, struct vgic_its *its)
 	(GIC_BASER_CACHEABILITY(GITS_BASER, INNER, RaWb)		| \
 	 GIC_BASER_CACHEABILITY(GITS_BASER, OUTER, SameAsInner)		| \
 	 GIC_BASER_SHAREABILITY(GITS_BASER, InnerShareable)		| \
-	 ((8ULL - 1) << GITS_BASER_ENTRY_SIZE_SHIFT)			| \
 	 GITS_BASER_PAGE_SIZE_64K)
 
 #define INITIAL_PROPBASER_VALUE						  \
@@ -1423,9 +1428,11 @@ static int vgic_its_create(struct kvm_device *dev, u32 type)
 	its->dev = dev;
 
 	its->baser_device_table = INITIAL_BASER_VALUE			|
-		((u64)GITS_BASER_TYPE_DEVICE << GITS_BASER_TYPE_SHIFT);
+		((u64)GITS_BASER_TYPE_DEVICE << GITS_BASER_TYPE_SHIFT)  |
+		((u64)(DEV_ENTRY_SIZE - 1) << GITS_BASER_ENTRY_SIZE_SHIFT);
 	its->baser_coll_table = INITIAL_BASER_VALUE |
-		((u64)GITS_BASER_TYPE_COLLECTION << GITS_BASER_TYPE_SHIFT);
+		((u64)GITS_BASER_TYPE_COLLECTION << GITS_BASER_TYPE_SHIFT) |
+		((u64)(COLL_ENTRY_SIZE - 1) << GITS_BASER_ENTRY_SIZE_SHIFT);
 	dev->kvm->arch.vgic.propbaser = INITIAL_PROPBASER_VALUE;
 
 	dev->private = its;
-- 
2.5.5
