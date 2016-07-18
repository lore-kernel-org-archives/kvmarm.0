From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 11/13] KVM: arm64: vgic-its: Turn device_id validation into
 generic ID validation
Date: Mon, 18 Jul 2016 16:54:13 +0100
Message-ID: <1468857255-9543-12-git-send-email-marc.zyngier@arm.com>
References: <1468857255-9543-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1314549B68
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2016 11:48:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zHhQSKO5zM7A for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Jul 2016 11:48:30 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E8EDF49B7D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2016 11:48:29 -0400 (EDT)
In-Reply-To: <1468857255-9543-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@redhat.com>, Andre Przywara <andre.przywara@arm.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

There is no need to have separate functions to validate devices
and collections, as the architecture doesn't really distinguish the
two, and they are supposed to be managed the same way.

Let's turn the DevID checker into a generic one.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-its.c | 134 ++++++++++++++++++++-----------------------
 1 file changed, 62 insertions(+), 72 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index dcae567..996e3e1 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -581,12 +581,73 @@ static int vgic_its_cmd_handle_movi(struct kvm *kvm, struct vgic_its *its,
 	return 0;
 }
 
+/*
+ * Check whether an ID can be stored into the corresponding guest table.
+ * For a direct table this is pretty easy, but gets a bit nasty for
+ * indirect tables. We check whether the resulting guest physical address
+ * is actually valid (covered by a memslot and guest accessbible).
+ * For this we have to read the respective first level entry.
+ */
+static bool vgic_its_check_id(struct vgic_its *its, u64 baser, int id)
+{
+	int l1_tbl_size = GITS_BASER_NR_PAGES(baser) * SZ_64K;
+	int index;
+	u64 indirect_ptr;
+	gfn_t gfn;
+
+	if (!(baser & GITS_BASER_INDIRECT)) {
+		phys_addr_t addr;
+
+		if (id >= (l1_tbl_size / GITS_BASER_ENTRY_SIZE(baser)))
+			return false;
+
+		addr = BASER_ADDRESS(baser) + id * GITS_BASER_ENTRY_SIZE(baser);
+		gfn = addr >> PAGE_SHIFT;
+
+		return kvm_is_visible_gfn(its->dev->kvm, gfn);
+	}
+
+	/* calculate and check the index into the 1st level */
+	index = id / (SZ_64K / GITS_BASER_ENTRY_SIZE(baser));
+	if (index >= (l1_tbl_size / sizeof(u64)))
+		return false;
+
+	/* Each 1st level entry is represented by a 64-bit value. */
+	if (kvm_read_guest(its->dev->kvm,
+			   BASER_ADDRESS(baser) + index * sizeof(indirect_ptr),
+			   &indirect_ptr, sizeof(indirect_ptr)))
+		return false;
+
+	indirect_ptr = le64_to_cpu(indirect_ptr);
+
+	/* check the valid bit of the first level entry */
+	if (!(indirect_ptr & BIT_ULL(63)))
+		return false;
+
+	/*
+	 * Mask the guest physical address and calculate the frame number.
+	 * Any address beyond our supported 48 bits of PA will be caught
+	 * by the actual check in the final step.
+	 */
+	indirect_ptr &= GENMASK_ULL(51, 16);
+
+	/* Find the address of the actual entry */
+	index = id % (SZ_64K / GITS_BASER_ENTRY_SIZE(baser));
+	indirect_ptr += index * GITS_BASER_ENTRY_SIZE(baser);
+	gfn = indirect_ptr >> PAGE_SHIFT;
+
+	return kvm_is_visible_gfn(its->dev->kvm, gfn);
+}
+
 static int vgic_its_alloc_collection(struct vgic_its *its,
 				     struct its_collection **colp,
 				     u32 coll_id)
 {
 	struct its_collection *collection;
 
+	if (!vgic_its_check_id(its, its->baser_coll_table, coll_id))
+		return E_ITS_MAPC_COLLECTION_OOR;
+
 	collection = kzalloc(sizeof(*collection), GFP_KERNEL);
 
 	collection->collection_id = coll_id;
@@ -709,67 +770,6 @@ static void vgic_its_unmap_device(struct kvm *kvm, struct its_device *device)
 }
 
 /*
- * Check whether a device ID can be stored into the guest device tables.
- * For a direct table this is pretty easy, but gets a bit nasty for
- * indirect tables. We check whether the resulting guest physical address
- * is actually valid (covered by a memslot and guest accessbible).
- * For this we have to read the respective first level entry.
- */
-static bool vgic_its_check_device_id(struct kvm *kvm, struct vgic_its *its,
-				     int device_id)
-{
-	u64 r = its->baser_device_table;
-	int l1_tbl_size = GITS_BASER_NR_PAGES(r) * SZ_64K;
-	int index;
-	u64 indirect_ptr;
-	gfn_t gfn;
-
-
-	if (!(r & GITS_BASER_INDIRECT)) {
-		phys_addr_t addr;
-
-		if (device_id >= (l1_tbl_size / GITS_BASER_ENTRY_SIZE(r)))
-			return false;
-
-		addr = BASER_ADDRESS(r) + device_id * GITS_BASER_ENTRY_SIZE(r);
-		gfn = addr >> PAGE_SHIFT;
-
-		return kvm_is_visible_gfn(kvm, gfn);
-	}
-
-	/* calculate and check the index into the 1st level */
-	index = device_id / (SZ_64K / GITS_BASER_ENTRY_SIZE(r));
-	if (index >= (l1_tbl_size / sizeof(u64)))
-		return false;
-
-	/* Each 1st level entry is represented by a 64-bit value. */
-	if (kvm_read_guest(kvm,
-			   BASER_ADDRESS(r) + index * sizeof(indirect_ptr),
-			   &indirect_ptr, sizeof(indirect_ptr)))
-		return false;
-
-	indirect_ptr = le64_to_cpu(indirect_ptr);
-
-	/* check the valid bit of the first level entry */
-	if (!(indirect_ptr & BIT_ULL(63)))
-		return false;
-
-	/*
-	 * Mask the guest physical address and calculate the frame number.
-	 * Any address beyond our supported 48 bits of PA will be caught
-	 * by the actual check in the final step.
-	 */
-	indirect_ptr &= GENMASK_ULL(51, 16);
-
-	/* Find the address of the actual entry */
-	index = device_id % (SZ_64K / GITS_BASER_ENTRY_SIZE(r));
-	indirect_ptr += index * GITS_BASER_ENTRY_SIZE(r);
-	gfn = indirect_ptr >> PAGE_SHIFT;
-
-	return kvm_is_visible_gfn(kvm, gfn);
-}
-
-/*
  * MAPD maps or unmaps a device ID to Interrupt Translation Tables (ITTs).
  * Must be called with the its_lock mutex held.
  */
@@ -780,7 +780,7 @@ static int vgic_its_cmd_handle_mapd(struct kvm *kvm, struct vgic_its *its,
 	bool valid = its_cmd_get_validbit(its_cmd);
 	struct its_device *device;
 
-	if (!vgic_its_check_device_id(kvm, its, device_id))
+	if (!vgic_its_check_id(its, its->baser_device_table, device_id))
 		return E_ITS_MAPD_DEVICE_OOR;
 
 	device = find_its_device(its, device_id);
@@ -812,13 +812,6 @@ static int vgic_its_cmd_handle_mapd(struct kvm *kvm, struct vgic_its *its,
 	return 0;
 }
 
-static int vgic_its_nr_collection_ids(struct vgic_its *its)
-{
-	u64 r = its->baser_coll_table;
-
-	return (GITS_BASER_NR_PAGES(r) * SZ_64K) / GITS_BASER_ENTRY_SIZE(r);
-}
-
 /*
  * The MAPC command maps collection IDs to redistributors.
  * Must be called with the its_lock mutex held.
@@ -838,9 +831,6 @@ static int vgic_its_cmd_handle_mapc(struct kvm *kvm, struct vgic_its *its,
 	if (target_addr >= atomic_read(&kvm->online_vcpus))
 		return E_ITS_MAPC_PROCNUM_OOR;
 
-	if (coll_id >= vgic_its_nr_collection_ids(its))
-		return E_ITS_MAPC_COLLECTION_OOR;
-
 	if (!valid) {
 		vgic_its_free_collection(its, coll_id);
 	} else {
-- 
2.1.4
