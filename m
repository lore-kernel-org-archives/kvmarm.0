From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v1 16/16] vgic: its: Add support for 52bit guest physical
 address
Date: Tue,  9 Jan 2018 19:04:11 +0000
Message-ID: <20180109190414.4017-17-suzuki.poulose@arm.com>
References: <20180109190414.4017-1-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 561CC49D62
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Jan 2018 14:00:52 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 86xaxsiOZB9u for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Jan 2018 14:00:51 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BE9DE49DA2
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Jan 2018 14:00:50 -0500 (EST)
In-Reply-To: <20180109190414.4017-1-suzuki.poulose@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: ard.biesheuvel@linaro.org, kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, kristina.martsenko@arm.com, Christoffer Dall <cdall@linaro.org>, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

From: Kristina Martsenko <kristina.martsenko@arm.com>

We only support 64K for the VGIC, which makes it easier to
support the 52bit guest PA by simply removing the restriction
that we put in to limit the bits to 48.

Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <cdall@linaro.org>
Signed-off-by: Kristina Martsenko <kristina.martsenko@arm.com>
[ Clean up macro usages, Add fixes for propbaser handling ]
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 virt/kvm/arm/vgic/vgic-its.c     | 36 ++++++++++--------------------------
 virt/kvm/arm/vgic/vgic-mmio-v3.c |  1 -
 2 files changed, 10 insertions(+), 27 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 8e633bd9cc1e..60ab293ec542 100644
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
@@ -769,7 +762,7 @@ static bool vgic_its_check_id(struct vgic_its *its, u64 baser, u32 id,
 		if (id >= (l1_tbl_size / esz))
 			return false;
 
-		addr = BASER_ADDRESS(baser) + id * esz;
+		addr = GITS_BASER_ADDR64K_TO_PHYS(baser) + id * esz;
 		gfn = addr >> PAGE_SHIFT;
 
 		if (eaddr)
@@ -784,7 +777,8 @@ static bool vgic_its_check_id(struct vgic_its *its, u64 baser, u32 id,
 
 	/* Each 1st level entry is represented by a 64-bit value. */
 	if (kvm_read_guest(its->dev->kvm,
-			   BASER_ADDRESS(baser) + index * sizeof(indirect_ptr),
+			   GITS_BASER_ADDR64K_TO_PHYS(baser) +
+				 index * sizeof(indirect_ptr),
 			   &indirect_ptr, sizeof(indirect_ptr)))
 		return false;
 
@@ -794,11 +788,7 @@ static bool vgic_its_check_id(struct vgic_its *its, u64 baser, u32 id,
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
@@ -1292,9 +1282,6 @@ static u64 vgic_sanitise_its_baser(u64 reg)
 				  GITS_BASER_OUTER_CACHEABILITY_SHIFT,
 				  vgic_sanitise_outer_cacheability);
 
-	/* Bits 15:12 contain bits 51:48 of the PA, which we don't support. */
-	reg &= ~GENMASK_ULL(15, 12);
-
 	/* We support only one (ITS) page size: 64K */
 	reg = (reg & ~GITS_BASER_PAGE_SIZE_MASK) | GITS_BASER_PAGE_SIZE_64K;
 
@@ -1313,11 +1300,8 @@ static u64 vgic_sanitise_its_cbaser(u64 reg)
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
@@ -1363,7 +1347,7 @@ static void vgic_its_process_commands(struct kvm *kvm, struct vgic_its *its)
 	if (!its->enabled)
 		return;
 
-	cbaser = CBASER_ADDRESS(its->cbaser);
+	cbaser = GITS_CBASER_ADDRESS(its->cbaser);
 
 	while (its->cwriter != its->creadr) {
 		int ret = kvm_read_guest(kvm, cbaser + its->creadr,
@@ -2221,7 +2205,7 @@ static int vgic_its_restore_device_tables(struct vgic_its *its)
 	if (!(baser & GITS_BASER_VALID))
 		return 0;
 
-	l1_gpa = BASER_ADDRESS(baser);
+	l1_gpa = GITS_BASER_ADDR64K_TO_PHYS(baser);
 
 	if (baser & GITS_BASER_INDIRECT) {
 		l1_esz = GITS_LVL1_ENTRY_SIZE;
@@ -2293,7 +2277,7 @@ static int vgic_its_save_collection_table(struct vgic_its *its)
 {
 	const struct vgic_its_abi *abi = vgic_its_get_abi(its);
 	u64 baser = its->baser_coll_table;
-	gpa_t gpa = BASER_ADDRESS(baser);
+	gpa_t gpa = GITS_BASER_ADDR64K_TO_PHYS(baser);
 	struct its_collection *collection;
 	u64 val;
 	size_t max_size, filled = 0;
@@ -2342,7 +2326,7 @@ static int vgic_its_restore_collection_table(struct vgic_its *its)
 	if (!(baser & GITS_BASER_VALID))
 		return 0;
 
-	gpa = BASER_ADDRESS(baser);
+	gpa = GITS_BASER_ADDR64K_TO_PHYS(baser);
 
 	max_size = GITS_BASER_NR_PAGES(baser) * SZ_64K;
 
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index 671fe81f8e1d..90f36d9c946b 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -351,7 +351,6 @@ static u64 vgic_sanitise_propbaser(u64 reg)
 				  vgic_sanitise_outer_cacheability);
 
 	reg &= ~PROPBASER_RES0_MASK;
-	reg &= ~GENMASK_ULL(51, 48);
 	return reg;
 }
 
-- 
2.13.6
