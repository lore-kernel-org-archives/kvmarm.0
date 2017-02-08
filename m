From: Eric Auger <eric.auger@redhat.com>
Subject: [RFC v2 15/19] KVM: arm64: ITS: Collection table save/restore
Date: Wed,  8 Feb 2017 12:43:28 +0100
Message-ID: <1486554212-2774-16-git-send-email-eric.auger@redhat.com>
References: <1486554212-2774-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F346408E9
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Feb 2017 06:44:09 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aTnXC+84HCNv for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Feb 2017 06:44:08 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6952840A63
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Feb 2017 06:44:08 -0500 (EST)
In-Reply-To: <1486554212-2774-1-git-send-email-eric.auger@redhat.com>
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
Cc: andre.przywara@arm.com, pbonzini@redhat.com, dgilbert@redhat.com, quintela@redhat.com, Prasun.Kapoor@cavium.com
List-Id: kvmarm@lists.cs.columbia.edu

The flush path copies the collection entries into guest RAM
at the GPA specified in the BASER register. This obviously
requires the BASER to be set. The last written element
is a dummy collection table entry.

We do not index by collection ID as the collection entry
can fit into 8 bytes while containing the collection ID.

On restore path we re-allocate the collection objects.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v1 -> v2:
- reword commit message and directly use 8 as entry size
- no kvm parameter anymore
- add helper for flush/restore cte
- table size computed here
- add le64/cpu conversions
---
 virt/kvm/arm/vgic/vgic-its.c | 94 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 92 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index cf04776..ad67759 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -1761,13 +1761,84 @@ static int vgic_its_restore_device_tables(struct vgic_its *its)
 	return -ENXIO;
 }
 
+static int vgic_its_flush_cte(struct vgic_its *its,
+			      struct its_collection *collection, u64 *ptr)
+{
+	u64 val;
+	int ret;
+
+	val = ((u64)1 << 63 | ((u64)collection->target_addr << 16) |
+	       collection->collection_id);
+	val = cpu_to_le64(val);
+	ret = kvm_write_guest(its->dev->kvm, (gpa_t)ptr, &val, 8);
+	return ret;
+}
+
+static int vgic_its_restore_cte(struct vgic_its *its, u64 *ptr, bool *valid)
+{
+	struct its_collection *collection;
+	u32 target_addr;
+	u32 coll_id;
+	u64 val;
+	int ret;
+
+	*valid = false;
+
+	ret = kvm_read_guest(its->dev->kvm, (gpa_t)ptr, &val, 8);
+	if (ret)
+		return ret;
+	val = le64_to_cpu(val);
+	*valid = val & BIT_ULL(63);
+
+	if (!*valid)
+		return 0;
+
+	target_addr = (u32)(val >> 16);
+	coll_id = val & 0xFFFF;
+	ret = vgic_its_alloc_collection(its, &collection, coll_id);
+	if (ret)
+		return ret;
+	collection->target_addr = target_addr;
+	return 0;
+}
+
 /**
  * vgic_its_flush_collection_table - flush the collection table into
  * guest RAM
  */
 static int vgic_its_flush_collection_table(struct vgic_its *its)
 {
-	return -ENXIO;
+	struct its_collection *collection;
+	u64 val, *ptr;
+	size_t max_size, filled = 0;
+	int ret;
+
+	ptr = (u64 *)(BASER_ADDRESS(its->baser_coll_table));
+	if (!ptr)
+		return 0;
+
+	max_size = GITS_BASER_NR_PAGES(its->baser_coll_table) * SZ_64K;
+
+	list_for_each_entry(collection, &its->collection_list, coll_list) {
+		if (filled == max_size)
+			return -ENOSPC;
+		ret = vgic_its_flush_cte(its, collection, ptr);
+		if (ret)
+			return ret;
+		ptr++;
+		filled += 8;
+	}
+
+	if (filled == max_size)
+		return 0;
+
+	/*
+	 * table is not fully filled, add a last dummy element
+	 * with valid bit unset
+	 */
+	val = 0;
+	ret = kvm_write_guest(its->dev->kvm, (gpa_t)ptr, &val, 8);
+	return ret;
 }
 
 /**
@@ -1777,7 +1848,26 @@ static int vgic_its_flush_collection_table(struct vgic_its *its)
  */
 static int vgic_its_restore_collection_table(struct vgic_its *its)
 {
-	return -ENXIO;
+	size_t max_size, read = 0;
+	u64 *ptr;
+	int ret;
+
+	ptr = (u64 *)(BASER_ADDRESS(its->baser_coll_table));
+	if (!ptr)
+		return 0;
+
+	max_size = GITS_BASER_NR_PAGES(its->baser_coll_table) * SZ_64K;
+
+	while (read < max_size) {
+		bool valid;
+
+		ret = vgic_its_restore_cte(its, ptr, &valid);
+		if (!valid || ret)
+			break;
+		ptr++;
+		read += 8;
+	}
+	return ret;
 }
 
 /**
-- 
2.5.5
