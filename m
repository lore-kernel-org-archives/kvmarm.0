From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v2 15/17] vgic: Add support for 52bit guest physical address
Date: Tue, 27 Mar 2018 14:15:25 +0100
Message-ID: <1522156531-28348-16-git-send-email-suzuki.poulose@arm.com>
References: <1522156531-28348-1-git-send-email-suzuki.poulose@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1522156531-28348-1-git-send-email-suzuki.poulose@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, cdall@kernel.org, marc.zyngier@arm.com, punit.agrawal@arm.com, will.deacon@arm.com, catalin.marinas@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, ard.biesheuvel@linaro.org, peter.maydell@linaro.org, kristina.martsenko@arm.com, mark.rutland@arm.com, Suzuki K Poulose <suzuki.poulose@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Kristina Martsenko <kristina.martsenko@arm.com>

Add support for handling 52bit guest physical address to the
VGIC layer. So far we have limited the guest physical address
to 48bits, by explicitly masking the upper bits. This patch
removes the restriction. We do not have to check if the host
supports 52bit as the gpa is always validated during an access.
(e.g, kvm_{read/write}_guest, kvm_is_visible_gfn()).
Also, the ITS table save-restore is also not affected with
the enhancement. The DTE entries already store the bits[51:8]
of the ITT_addr (with a 256byte alignment).

Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <cdall@kernel.org>
Signed-off-by: Kristina Martsenko <kristina.martsenko@arm.com>
[ Macro clean ups, fix PROPBASER and PENDBASER accesses ]
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 include/linux/irqchip/arm-gic-v3.h |  5 +++++
 virt/kvm/arm/vgic/vgic-its.c       | 37 ++++++++++---------------------------
 virt/kvm/arm/vgic/vgic-mmio-v3.c   |  2 --
 3 files changed, 15 insertions(+), 29 deletions(-)

diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index c00c4c33..d9c60eb 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -344,6 +344,8 @@
 #define GITS_CBASER_RaWaWt	GIC_BASER_CACHEABILITY(GITS_CBASER, INNER, RaWaWt)
 #define GITS_CBASER_RaWaWb	GIC_BASER_CACHEABILITY(GITS_CBASER, INNER, RaWaWb)
 
+#define GITS_CBASER_ADDRESS(cbaser)	((cbaser) & GENMASK_ULL(52, 12))
+
 #define GITS_BASER_NR_REGS		8
 
 #define GITS_BASER_VALID			(1ULL << 63)
@@ -375,6 +377,9 @@
 #define GITS_BASER_ENTRY_SIZE_MASK	GENMASK_ULL(52, 48)
 #define GITS_BASER_PHYS_52_to_48(phys)					\
 	(((phys) & GENMASK_ULL(47, 16)) | (((phys) >> 48) & 0xf) << 12)
+#define GITS_BASER_ADDR_48_to_52(baser)					\
+	(((baser) & GENMASK_ULL(47, 16)) | (((baser) >> 12) & 0xf) << 48)
+
 #define GITS_BASER_SHAREABILITY_SHIFT	(10)
 #define GITS_BASER_InnerShareable					\
 	GIC_BASER_SHAREABILITY(GITS_BASER, InnerShareable)
diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 4650953..ae6bfaf 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -233,13 +233,6 @@ static struct its_ite *find_ite(struct vgic_its *its, u32 device_id,
 	list_for_each_entry(dev, &(its)->device_list, dev_list) \
 		list_for_each_entry(ite, &(dev)->itt_head, ite_list)
 
-/*
- * We only implement 48 bits of PA at the moment, although the ITS
- * supports more. Let's be restrictive here.
- */
-#define BASER_ADDRESS(x)	((x) & GENMASK_ULL(47, 16))
-#define CBASER_ADDRESS(x)	((x) & GENMASK_ULL(47, 12))
-
 #define GIC_LPI_OFFSET 8192
 
 #define VITS_TYPER_IDBITS 16
@@ -745,6 +738,7 @@ static bool vgic_its_check_id(struct vgic_its *its, u64 baser, u32 id,
 {
 	int l1_tbl_size = GITS_BASER_NR_PAGES(baser) * SZ_64K;
 	u64 indirect_ptr, type = GITS_BASER_TYPE(baser);
+	phys_addr_t base = GITS_BASER_ADDR_48_to_52(baser);
 	int esz = GITS_BASER_ENTRY_SIZE(baser);
 	int index;
 	gfn_t gfn;
@@ -769,7 +763,7 @@ static bool vgic_its_check_id(struct vgic_its *its, u64 baser, u32 id,
 		if (id >= (l1_tbl_size / esz))
 			return false;
 
-		addr = BASER_ADDRESS(baser) + id * esz;
+		addr = base + id * esz;
 		gfn = addr >> PAGE_SHIFT;
 
 		if (eaddr)
@@ -783,8 +777,7 @@ static bool vgic_its_check_id(struct vgic_its *its, u64 baser, u32 id,
 		return false;
 
 	/* Each 1st level entry is represented by a 64-bit value. */
-	if (kvm_read_guest(its->dev->kvm,
-			   BASER_ADDRESS(baser) + index * sizeof(indirect_ptr),
+	if (kvm_read_guest(its->dev->kvm, base + index * sizeof(indirect_ptr),
 			   &indirect_ptr, sizeof(indirect_ptr)))
 		return false;
 
@@ -794,11 +787,7 @@ static bool vgic_its_check_id(struct vgic_its *its, u64 baser, u32 id,
 	if (!(indirect_ptr & BIT_ULL(63)))
 		return false;
 
-	/*
-	 * Mask the guest physical address and calculate the frame number.
-	 * Any address beyond our supported 48 bits of PA will be caught
-	 * by the actual check in the final step.
-	 */
+	/* Mask the guest physical address and calculate the frame number. */
 	indirect_ptr &= GENMASK_ULL(51, 16);
 
 	/* Find the address of the actual entry */
@@ -1290,9 +1279,6 @@ static u64 vgic_sanitise_its_baser(u64 reg)
 				  GITS_BASER_OUTER_CACHEABILITY_SHIFT,
 				  vgic_sanitise_outer_cacheability);
 
-	/* Bits 15:12 contain bits 51:48 of the PA, which we don't support. */
-	reg &= ~GENMASK_ULL(15, 12);
-
 	/* We support only one (ITS) page size: 64K */
 	reg = (reg & ~GITS_BASER_PAGE_SIZE_MASK) | GITS_BASER_PAGE_SIZE_64K;
 
@@ -1311,11 +1297,8 @@ static u64 vgic_sanitise_its_cbaser(u64 reg)
 				  GITS_CBASER_OUTER_CACHEABILITY_SHIFT,
 				  vgic_sanitise_outer_cacheability);
 
-	/*
-	 * Sanitise the physical address to be 64k aligned.
-	 * Also limit the physical addresses to 48 bits.
-	 */
-	reg &= ~(GENMASK_ULL(51, 48) | GENMASK_ULL(15, 12));
+	/* Sanitise the physical address to be 64k aligned. */
+	reg &= ~GENMASK_ULL(15, 12);
 
 	return reg;
 }
@@ -1361,7 +1344,7 @@ static void vgic_its_process_commands(struct kvm *kvm, struct vgic_its *its)
 	if (!its->enabled)
 		return;
 
-	cbaser = CBASER_ADDRESS(its->cbaser);
+	cbaser = GITS_CBASER_ADDRESS(its->cbaser);
 
 	while (its->cwriter != its->creadr) {
 		int ret = kvm_read_guest(kvm, cbaser + its->creadr,
@@ -2219,7 +2202,7 @@ static int vgic_its_restore_device_tables(struct vgic_its *its)
 	if (!(baser & GITS_BASER_VALID))
 		return 0;
 
-	l1_gpa = BASER_ADDRESS(baser);
+	l1_gpa = GITS_BASER_ADDR_48_to_52(baser);
 
 	if (baser & GITS_BASER_INDIRECT) {
 		l1_esz = GITS_LVL1_ENTRY_SIZE;
@@ -2291,7 +2274,7 @@ static int vgic_its_save_collection_table(struct vgic_its *its)
 {
 	const struct vgic_its_abi *abi = vgic_its_get_abi(its);
 	u64 baser = its->baser_coll_table;
-	gpa_t gpa = BASER_ADDRESS(baser);
+	gpa_t gpa = GITS_BASER_ADDR_48_to_52(baser);
 	struct its_collection *collection;
 	u64 val;
 	size_t max_size, filled = 0;
@@ -2340,7 +2323,7 @@ static int vgic_its_restore_collection_table(struct vgic_its *its)
 	if (!(baser & GITS_BASER_VALID))
 		return 0;
 
-	gpa = BASER_ADDRESS(baser);
+	gpa = GITS_BASER_ADDR_48_to_52(baser);
 
 	max_size = GITS_BASER_NR_PAGES(baser) * SZ_64K;
 
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index 671fe81..80e0d15 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -333,7 +333,6 @@ static u64 vgic_sanitise_pendbaser(u64 reg)
 				  vgic_sanitise_outer_cacheability);
 
 	reg &= ~PENDBASER_RES0_MASK;
-	reg &= ~GENMASK_ULL(51, 48);
 
 	return reg;
 }
@@ -351,7 +350,6 @@ static u64 vgic_sanitise_propbaser(u64 reg)
 				  vgic_sanitise_outer_cacheability);
 
 	reg &= ~PROPBASER_RES0_MASK;
-	reg &= ~GENMASK_ULL(51, 48);
 	return reg;
 }
 
-- 
2.7.4
