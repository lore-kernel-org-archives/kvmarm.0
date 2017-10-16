From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v3 03/11] KVM: arm/arm64: vgic-its: Improve error reporting on
 device table save
Date: Mon, 16 Oct 2017 17:03:24 +0200
Message-ID: <1508166212-9599-4-git-send-email-eric.auger@redhat.com>
References: <1508166212-9599-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 74BB049D34
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Oct 2017 11:03:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id m9HIyS5z8aeo for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Oct 2017 11:03:01 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7DBC749D4E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Oct 2017 11:03:01 -0400 (EDT)
In-Reply-To: <1508166212-9599-1-git-send-email-eric.auger@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, cdall@linaro.org, peter.maydell@linaro.org, andre.przywara@arm.com, wanghaibin.wang@huawei.com
Cc: wu.wubin@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

At the moment the device table save() returns -EINVAL if
vgic_its_check_id() fails to return the gpa of the entry
associated to the device/collection id. Let vgic_its_check_id()
return an int instead of a bool and return a more precised
error value:
- EINVAL in case the id is out of range
- EFAULT if the gpa is not provisionned or is not valid

We also check first the GITS_BASER<n> Valid bit is set.

This allows the userspace to discriminate failure reasons.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

need to CC stable

v2 -> v3:
- correct kerneldoc comment
---
 virt/kvm/arm/vgic/vgic-its.c | 55 +++++++++++++++++++++++++++++---------------
 1 file changed, 37 insertions(+), 18 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 23851189..51cb836 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -687,15 +687,25 @@ static int vgic_its_cmd_handle_movi(struct kvm *kvm, struct vgic_its *its,
 	return 0;
 }
 
-/*
- * Check whether an ID can be stored into the corresponding guest table.
+/**
+ * vgic_its_check_id - Check whether an ID can be stored into
+ * the corresponding guest table.
+ *
+ * @its: its handle
+ * @baser: GITS_BASER<n> register
+ * @id: id of the device/collection
+ * @eaddr: output gpa of the corresponding table entry
+ *
  * For a direct table this is pretty easy, but gets a bit nasty for
  * indirect tables. We check whether the resulting guest physical address
  * is actually valid (covered by a memslot and guest accessible).
  * For this we have to read the respective first level entry.
+ *
+ * Return: 0 on success, -EINVAL if @id is out of range, -EFAULT if
+ * the address cannot be computed or is not valid
  */
-static bool vgic_its_check_id(struct vgic_its *its, u64 baser, u32 id,
-			      gpa_t *eaddr)
+static int vgic_its_check_id(struct vgic_its *its, u64 baser, u32 id,
+			     gpa_t *eaddr)
 {
 	int l1_tbl_size = GITS_BASER_NR_PAGES(baser) * SZ_64K;
 	u64 indirect_ptr, type = GITS_BASER_TYPE(baser);
@@ -703,50 +713,56 @@ static bool vgic_its_check_id(struct vgic_its *its, u64 baser, u32 id,
 	int index;
 	gfn_t gfn;
 
+	if (!(baser & GITS_BASER_VALID))
+		return -EFAULT;
+
 	switch (type) {
 	case GITS_BASER_TYPE_DEVICE:
 		if (id >= BIT_ULL(VITS_TYPER_DEVBITS))
-			return false;
+			return -EINVAL;
 		break;
 	case GITS_BASER_TYPE_COLLECTION:
 		/* as GITS_TYPER.CIL == 0, ITS supports 16-bit collection ID */
 		if (id >= BIT_ULL(16))
-			return false;
+			return -EINVAL;
 		break;
 	default:
-		return false;
+		return -EINVAL;
 	}
 
 	if (!(baser & GITS_BASER_INDIRECT)) {
 		phys_addr_t addr;
 
 		if (id >= (l1_tbl_size / esz))
-			return false;
+			return -EINVAL;
 
 		addr = BASER_ADDRESS(baser) + id * esz;
 		gfn = addr >> PAGE_SHIFT;
 
 		if (eaddr)
 			*eaddr = addr;
-		return kvm_is_visible_gfn(its->dev->kvm, gfn);
+		if (kvm_is_visible_gfn(its->dev->kvm, gfn))
+			return 0;
+		else
+			return -EFAULT;
 	}
 
 	/* calculate and check the index into the 1st level */
 	index = id / (SZ_64K / esz);
 	if (index >= (l1_tbl_size / sizeof(u64)))
-		return false;
+		return -EINVAL;
 
 	/* Each 1st level entry is represented by a 64-bit value. */
 	if (kvm_read_guest(its->dev->kvm,
 			   BASER_ADDRESS(baser) + index * sizeof(indirect_ptr),
 			   &indirect_ptr, sizeof(indirect_ptr)))
-		return false;
+		return -EFAULT;
 
 	indirect_ptr = le64_to_cpu(indirect_ptr);
 
 	/* check the valid bit of the first level entry */
 	if (!(indirect_ptr & BIT_ULL(63)))
-		return false;
+		return -EFAULT;
 
 	/*
 	 * Mask the guest physical address and calculate the frame number.
@@ -762,7 +778,10 @@ static bool vgic_its_check_id(struct vgic_its *its, u64 baser, u32 id,
 
 	if (eaddr)
 		*eaddr = indirect_ptr;
-	return kvm_is_visible_gfn(its->dev->kvm, gfn);
+	if (kvm_is_visible_gfn(its->dev->kvm, gfn))
+		return 0;
+	else
+		return -EFAULT;
 }
 
 static int vgic_its_alloc_collection(struct vgic_its *its,
@@ -771,7 +790,7 @@ static int vgic_its_alloc_collection(struct vgic_its *its,
 {
 	struct its_collection *collection;
 
-	if (!vgic_its_check_id(its, its->baser_coll_table, coll_id, NULL))
+	if (vgic_its_check_id(its, its->baser_coll_table, coll_id, NULL))
 		return E_ITS_MAPC_COLLECTION_OOR;
 
 	collection = kzalloc(sizeof(*collection), GFP_KERNEL);
@@ -943,7 +962,7 @@ static int vgic_its_cmd_handle_mapd(struct kvm *kvm, struct vgic_its *its,
 	gpa_t itt_addr = its_cmd_get_ittaddr(its_cmd);
 	struct its_device *device;
 
-	if (!vgic_its_check_id(its, its->baser_device_table, device_id, NULL))
+	if (vgic_its_check_id(its, its->baser_device_table, device_id, NULL))
 		return E_ITS_MAPD_DEVICE_OOR;
 
 	if (valid && num_eventid_bits > VITS_TYPER_IDBITS)
@@ -2093,9 +2112,9 @@ static int vgic_its_save_device_tables(struct vgic_its *its)
 		int ret;
 		gpa_t eaddr;
 
-		if (!vgic_its_check_id(its, baser,
-				       dev->device_id, &eaddr))
-			return -EINVAL;
+		ret = vgic_its_check_id(its, baser, dev->device_id, &eaddr);
+		if (ret)
+			return ret;
 
 		ret = vgic_its_save_itt(its, dev);
 		if (ret)
-- 
2.5.5
