From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v6 19/24] KVM: arm64: vgic-its: Collection table save/restore
Date: Thu,  4 May 2017 13:44:39 +0200
Message-ID: <1493898284-29504-20-git-send-email-eric.auger@redhat.com>
References: <1493898284-29504-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F30340625
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 May 2017 07:43:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2N-LnVvZ-pYb for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 May 2017 07:43:48 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7C10D40190
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 May 2017 07:43:48 -0400 (EDT)
In-Reply-To: <1493898284-29504-1-git-send-email-eric.auger@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, andre.przywara@arm.com, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, peter.maydell@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Prasun.Kapoor@cavium.com, quintela@redhat.com, dgilbert@redhat.com, bjsprakash.linux@gmail.com, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

The save path copies the collection entries into guest RAM
at the GPA specified in the BASER register. This obviously
requires the BASER to be set. The last written element is a
dummy collection table entry.

We do not index by collection ID as the collection entry
can fit into 8 bytes while containing the collection ID.

On restore path we re-allocate the collection objects.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---
v5 -> v6:
- remove the valid pointer from vgic_its_restore_cte and
  return +1 if no error and last elt not found
- check the BASER valid bit
- add BUG_ON to check esz versus val size

v4 -> v5:
- add macros for field encoding/decoding
- use abi->cte_esz
- rename flush into save
- check the target_addr is valid

v3 -> v4:
- replaced u64 *ptr by gpa_t gpa
- check the collection does not exist before allocating it

v1 -> v2:
- reword commit message and directly use 8 as entry size
- no kvm parameter anymore
- add helper for flush/restore cte
- table size computed here
- add le64/cpu conversions
---
 virt/kvm/arm/vgic/vgic-its.c | 102 ++++++++++++++++++++++++++++++++++++++++++-
 virt/kvm/arm/vgic/vgic.h     |   9 ++++
 2 files changed, 109 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 1db7e38..6bef9147 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -1804,13 +1804,91 @@ static int vgic_its_restore_device_tables(struct vgic_its *its)
 	return -ENXIO;
 }
 
+static int vgic_its_save_cte(struct vgic_its *its,
+			     struct its_collection *collection,
+			     gpa_t gpa, int esz)
+{
+	u64 val;
+
+	val = (1ULL << KVM_ITS_CTE_VALID_SHIFT |
+	       ((u64)collection->target_addr << KVM_ITS_CTE_RDBASE_SHIFT) |
+	       collection->collection_id);
+	val = cpu_to_le64(val);
+	return kvm_write_guest(its->dev->kvm, gpa, &val, esz);
+}
+
+static int vgic_its_restore_cte(struct vgic_its *its, gpa_t gpa, int esz)
+{
+	struct its_collection *collection;
+	struct kvm *kvm = its->dev->kvm;
+	u32 target_addr, coll_id;
+	u64 val;
+	int ret;
+
+	BUG_ON(esz > sizeof(val));
+	ret = kvm_read_guest(kvm, gpa, &val, esz);
+	if (ret)
+		return ret;
+	val = le64_to_cpu(val);
+	if (!(val & KVM_ITS_CTE_VALID_MASK))
+		return 0;
+
+	target_addr = (u32)(val >> KVM_ITS_CTE_RDBASE_SHIFT);
+	coll_id = val & KVM_ITS_CTE_ICID_MASK;
+
+	if (target_addr >= atomic_read(&kvm->online_vcpus))
+		return -EINVAL;
+
+	collection = find_collection(its, coll_id);
+	if (collection)
+		return -EEXIST;
+	ret = vgic_its_alloc_collection(its, &collection, coll_id);
+	if (ret)
+		return ret;
+	collection->target_addr = target_addr;
+	return 1;
+}
+
 /**
  * vgic_its_save_collection_table - Save the collection table into
  * guest RAM
  */
 static int vgic_its_save_collection_table(struct vgic_its *its)
 {
-	return -ENXIO;
+	const struct vgic_its_abi *abi = vgic_its_get_abi(its);
+	struct its_collection *collection;
+	u64 val;
+	gpa_t gpa;
+	size_t max_size, filled = 0;
+	int ret, cte_esz = abi->cte_esz;
+
+	gpa = BASER_ADDRESS(its->baser_coll_table);
+	if (!gpa)
+		return 0;
+
+	max_size = GITS_BASER_NR_PAGES(its->baser_coll_table) * SZ_64K;
+
+	list_for_each_entry(collection, &its->collection_list, coll_list) {
+		if (filled == max_size)
+			return -ENOSPC;
+		ret = vgic_its_save_cte(its, collection, gpa, cte_esz);
+		if (ret)
+			return ret;
+		gpa += cte_esz;
+		filled += cte_esz;
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
+	BUG_ON(cte_esz > sizeof(val));
+	ret = kvm_write_guest(its->dev->kvm, gpa, &val, cte_esz);
+	return ret;
 }
 
 /**
@@ -1820,7 +1898,27 @@ static int vgic_its_save_collection_table(struct vgic_its *its)
  */
 static int vgic_its_restore_collection_table(struct vgic_its *its)
 {
-	return -ENXIO;
+	const struct vgic_its_abi *abi = vgic_its_get_abi(its);
+	int cte_esz = abi->cte_esz;
+	size_t max_size, read = 0;
+	gpa_t gpa;
+	int ret;
+
+	if (!(its->baser_coll_table & GITS_BASER_VALID))
+		return 0;
+
+	gpa = BASER_ADDRESS(its->baser_coll_table);
+
+	max_size = GITS_BASER_NR_PAGES(its->baser_coll_table) * SZ_64K;
+
+	while (read < max_size) {
+		ret = vgic_its_restore_cte(its, gpa, cte_esz);
+		if (ret <= 0)
+			break;
+		gpa += cte_esz;
+		read += cte_esz;
+	}
+	return ret;
 }
 
 /**
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index 309ab64..58adcae 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -73,6 +73,15 @@
 				      KVM_REG_ARM_VGIC_SYSREG_CRM_MASK | \
 				      KVM_REG_ARM_VGIC_SYSREG_OP2_MASK)
 
+/*
+ * As per Documentation/virtual/kvm/devices/arm-vgic-its.txt,
+ * below macros are defined for ITS table entry encoding.
+ */
+#define KVM_ITS_CTE_VALID_SHIFT		63
+#define KVM_ITS_CTE_VALID_MASK		BIT_ULL(63)
+#define KVM_ITS_CTE_RDBASE_SHIFT	16
+#define KVM_ITS_CTE_ICID_MASK		GENMASK_ULL(15, 0)
+
 static inline bool irq_is_pending(struct vgic_irq *irq)
 {
 	if (irq->config == VGIC_CONFIG_EDGE)
-- 
2.5.5
