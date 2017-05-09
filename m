From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL 21/37] KVM: arm64: vgic-its: Collection table save/restore
Date: Tue,  9 May 2017 12:44:50 +0200
Message-ID: <20170509104506.30929-22-cdall@linaro.org>
References: <20170509104506.30929-1-cdall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170509104506.30929-1-cdall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Eric Auger <eric.auger@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Eric Auger <eric.auger@redhat.com>

The save path copies the collection entries into guest RAM
at the GPA specified in the BASER register. This obviously
requires the BASER to be set. The last written element is a
dummy collection table entry.

We do not index by collection ID as the collection entry
can fit into 8 bytes while containing the collection ID.

On restore path we re-allocate the collection objects.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Christoffer Dall <cdall@linaro.org>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-its.c | 100 ++++++++++++++++++++++++++++++++++++++++++-
 virt/kvm/arm/vgic/vgic.h     |   9 ++++
 2 files changed, 107 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index d5c0057..5523f0a 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -1838,13 +1838,89 @@ static int vgic_its_restore_device_tables(struct vgic_its *its)
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
@@ -1854,7 +1930,27 @@ static int vgic_its_save_collection_table(struct vgic_its *its)
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
index 79768c8..757de7a 100644
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
2.9.0
