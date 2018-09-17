From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v5 14/18] vgic: Add support for 52bit guest physical address
Date: Mon, 17 Sep 2018 11:41:36 +0100
Message-ID: <20180917104144.19188-15-suzuki.poulose@arm.com>
References: <20180917104144.19188-1-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180917104144.19188-1-suzuki.poulose@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, marc.zyngier@arm.com, cdall@kernel.org, eric.auger@redhat.com, pbonzini@redhat.com, rkrcmar@redhat.com, will.deacon@arm.com, catalin.marinas@arm.com, james.morse@arm.com, dave.martin@arm.com, julien.grall@arm.com, linux-kernel@vger.kernel.org, suzuki.poulose@arm.com, Kristina Martsenko <kristina.martsenko@arm.com>
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
 virt/kvm/arm/vgic/vgic-its.c       | 36 +++++++++---------------------
 virt/kvm/arm/vgic/vgic-mmio-v3.c   |  2 --
 3 files changed, 15 insertions(+), 28 deletions(-)

diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index 8bdbb5f29494..e961f40992d7 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -357,6 +357,8 @@
 #define GITS_CBASER_RaWaWt	GIC_BASER_CACHEABILITY(GITS_CBASER, INNER, RaWaWt)
 #define GITS_CBASER_RaWaWb	GIC_BASER_CACHEABILITY(GITS_CBASER, INNER, RaWaWb)
 
+#define GITS_CBASER_ADDRESS(cbaser)	((cbaser) & GENMASK_ULL(52, 12))
+
 #define GITS_BASER_NR_REGS		8
 
 #define GITS_BASER_VALID			(1ULL << 63)
@@ -388,6 +390,9 @@
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
index 12502251727e..eb2a390a6c86 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -241,13 +241,6 @@ static struct its_ite *find_ite(struct vgic_its *its, u32 device_id,
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
@@ -759,6 +752,7 @@ static bool vgic_its_check_id(struct vgic_its *its, u64 baser, u32 id,
 {
 	int l1_tbl_size = GITS_BASER_NR_PAGES(baser) * SZ_64K;
 	u64 indirect_ptr, type = GITS_BASER_TYPE(baser);
+	phys_addr_t base = GITS_BASER_ADDR_48_to_52(baser);
 	int esz = GITS_BASER_ENTRY_SIZE(baser);
 	int index;
 	gfn_t gfn;
@@ -783,7 +777,7 @@ static bool vgic_its_check_id(struct vgic_its *its, u64 baser, u32 id,
 		if (id >= (l1_tbl_size / esz))
 			return false;
 
-		addr = BASER_ADDRESS(baser) + id * esz;
+		addr = base + id * esz;
 		gfn = addr >> PAGE_SHIFT;
 
 		if (eaddr)
@@ -798,7 +792,7 @@ static bool vgic_its_check_id(struct vgic_its *its, u64 baser, u32 id,
 
 	/* Each 1st level entry is represented by a 64-bit value. */
 	if (kvm_read_guest_lock(its->dev->kvm,
-			   BASER_ADDRESS(baser) + index * sizeof(indirect_ptr),
+			   base + index * sizeof(indirect_ptr),
 			   &indirect_ptr, sizeof(indirect_ptr)))
 		return false;
 
@@ -808,11 +802,7 @@ static bool vgic_its_check_id(struct vgic_its *its, u64 baser, u32 id,
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
@@ -1304,9 +1294,6 @@ static u64 vgic_sanitise_its_baser(u64 reg)
 				  GITS_BASER_OUTER_CACHEABILITY_SHIFT,
 				  vgic_sanitise_outer_cacheability);
 
-	/* Bits 15:12 contain bits 51:48 of the PA, which we don't support. */
-	reg &= ~GENMASK_ULL(15, 12);
-
 	/* We support only one (ITS) page size: 64K */
 	reg = (reg & ~GITS_BASER_PAGE_SIZE_MASK) | GITS_BASER_PAGE_SIZE_64K;
 
@@ -1325,11 +1312,8 @@ static u64 vgic_sanitise_its_cbaser(u64 reg)
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
@@ -1375,7 +1359,7 @@ static void vgic_its_process_commands(struct kvm *kvm, struct vgic_its *its)
 	if (!its->enabled)
 		return;
 
-	cbaser = CBASER_ADDRESS(its->cbaser);
+	cbaser = GITS_CBASER_ADDRESS(its->cbaser);
 
 	while (its->cwriter != its->creadr) {
 		int ret = kvm_read_guest_lock(kvm, cbaser + its->creadr,
@@ -2233,7 +2217,7 @@ static int vgic_its_restore_device_tables(struct vgic_its *its)
 	if (!(baser & GITS_BASER_VALID))
 		return 0;
 
-	l1_gpa = BASER_ADDRESS(baser);
+	l1_gpa = GITS_BASER_ADDR_48_to_52(baser);
 
 	if (baser & GITS_BASER_INDIRECT) {
 		l1_esz = GITS_LVL1_ENTRY_SIZE;
@@ -2305,7 +2289,7 @@ static int vgic_its_save_collection_table(struct vgic_its *its)
 {
 	const struct vgic_its_abi *abi = vgic_its_get_abi(its);
 	u64 baser = its->baser_coll_table;
-	gpa_t gpa = BASER_ADDRESS(baser);
+	gpa_t gpa = GITS_BASER_ADDR_48_to_52(baser);
 	struct its_collection *collection;
 	u64 val;
 	size_t max_size, filled = 0;
@@ -2354,7 +2338,7 @@ static int vgic_its_restore_collection_table(struct vgic_its *its)
 	if (!(baser & GITS_BASER_VALID))
 		return 0;
 
-	gpa = BASER_ADDRESS(baser);
+	gpa = GITS_BASER_ADDR_48_to_52(baser);
 
 	max_size = GITS_BASER_NR_PAGES(baser) * SZ_64K;
 
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index a2a175b08b17..b3d1f0985117 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -364,7 +364,6 @@ static u64 vgic_sanitise_pendbaser(u64 reg)
 				  vgic_sanitise_outer_cacheability);
 
 	reg &= ~PENDBASER_RES0_MASK;
-	reg &= ~GENMASK_ULL(51, 48);
 
 	return reg;
 }
@@ -382,7 +381,6 @@ static u64 vgic_sanitise_propbaser(u64 reg)
 				  vgic_sanitise_outer_cacheability);
 
 	reg &= ~PROPBASER_RES0_MASK;
-	reg &= ~GENMASK_ULL(51, 48);
 	return reg;
 }
 
-- 
2.19.0
