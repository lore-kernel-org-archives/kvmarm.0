From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL 24/37] KVM: arm64: vgic-its: ITT save and restore
Date: Tue,  9 May 2017 12:44:53 +0200
Message-ID: <20170509104506.30929-25-cdall@linaro.org>
References: <20170509104506.30929-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7339B40CC6
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 May 2017 06:42:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DQfEpblY3RHP for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 May 2017 06:42:24 -0400 (EDT)
Received: from mail-qk0-f182.google.com (mail-qk0-f182.google.com
 [209.85.220.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AD2DD40C32
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 May 2017 06:42:20 -0400 (EDT)
Received: by mail-qk0-f182.google.com with SMTP id u75so75016370qka.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 09 May 2017 03:45:35 -0700 (PDT)
In-Reply-To: <20170509104506.30929-1-cdall@linaro.org>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Eric Auger <eric.auger@redhat.com>

Implement routines to save and restore device ITT and their
interrupt table entries (ITE).

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Christoffer Dall <cdall@linaro.org>
---
 virt/kvm/arm/vgic/vgic-its.c | 116 +++++++++++++++++++++++++++++++++++++++++--
 virt/kvm/arm/vgic/vgic.h     |   4 ++
 2 files changed, 117 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 3dea626..adb3d9e 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -1750,7 +1750,7 @@ static u32 compute_next_devid_offset(struct list_head *h,
 	return min_t(u32, next_offset, VITS_DTE_MAX_DEVID_OFFSET);
 }
 
-u32 compute_next_eventid_offset(struct list_head *h, struct its_ite *ite)
+static u32 compute_next_eventid_offset(struct list_head *h, struct its_ite *ite)
 {
 	struct its_ite *next;
 	u32 next_offset;
@@ -1827,14 +1827,124 @@ static int scan_its_table(struct vgic_its *its, gpa_t base, int size, int esz,
 	return ret;
 }
 
+/**
+ * vgic_its_save_ite - Save an interrupt translation entry at @gpa
+ */
+static int vgic_its_save_ite(struct vgic_its *its, struct its_device *dev,
+			      struct its_ite *ite, gpa_t gpa, int ite_esz)
+{
+	struct kvm *kvm = its->dev->kvm;
+	u32 next_offset;
+	u64 val;
+
+	next_offset = compute_next_eventid_offset(&dev->itt_head, ite);
+	val = ((u64)next_offset << KVM_ITS_ITE_NEXT_SHIFT) |
+	       ((u64)ite->lpi << KVM_ITS_ITE_PINTID_SHIFT) |
+		ite->collection->collection_id;
+	val = cpu_to_le64(val);
+	return kvm_write_guest(kvm, gpa, &val, ite_esz);
+}
+
+/**
+ * vgic_its_restore_ite - restore an interrupt translation entry
+ * @event_id: id used for indexing
+ * @ptr: pointer to the ITE entry
+ * @opaque: pointer to the its_device
+ */
+static int vgic_its_restore_ite(struct vgic_its *its, u32 event_id,
+				void *ptr, void *opaque)
+{
+	struct its_device *dev = (struct its_device *)opaque;
+	struct its_collection *collection;
+	struct kvm *kvm = its->dev->kvm;
+	struct kvm_vcpu *vcpu = NULL;
+	u64 val;
+	u64 *p = (u64 *)ptr;
+	struct vgic_irq *irq;
+	u32 coll_id, lpi_id;
+	struct its_ite *ite;
+	u32 offset;
+
+	val = *p;
+
+	val = le64_to_cpu(val);
+
+	coll_id = val & KVM_ITS_ITE_ICID_MASK;
+	lpi_id = (val & KVM_ITS_ITE_PINTID_MASK) >> KVM_ITS_ITE_PINTID_SHIFT;
+
+	if (!lpi_id)
+		return 1; /* invalid entry, no choice but to scan next entry */
+
+	if (lpi_id < VGIC_MIN_LPI)
+		return -EINVAL;
+
+	offset = val >> KVM_ITS_ITE_NEXT_SHIFT;
+	if (event_id + offset >= BIT_ULL(dev->num_eventid_bits))
+		return -EINVAL;
+
+	collection = find_collection(its, coll_id);
+	if (!collection)
+		return -EINVAL;
+
+	ite = vgic_its_alloc_ite(dev, collection, lpi_id, event_id);
+	if (IS_ERR(ite))
+		return PTR_ERR(ite);
+
+	if (its_is_collection_mapped(collection))
+		vcpu = kvm_get_vcpu(kvm, collection->target_addr);
+
+	irq = vgic_add_lpi(kvm, lpi_id, vcpu);
+	if (IS_ERR(irq))
+		return PTR_ERR(irq);
+	ite->irq = irq;
+
+	return offset;
+}
+
+static int vgic_its_ite_cmp(void *priv, struct list_head *a,
+			    struct list_head *b)
+{
+	struct its_ite *itea = container_of(a, struct its_ite, ite_list);
+	struct its_ite *iteb = container_of(b, struct its_ite, ite_list);
+
+	if (itea->event_id < iteb->event_id)
+		return -1;
+	else
+		return 1;
+}
+
 static int vgic_its_save_itt(struct vgic_its *its, struct its_device *device)
 {
-	return -ENXIO;
+	const struct vgic_its_abi *abi = vgic_its_get_abi(its);
+	gpa_t base = device->itt_addr;
+	struct its_ite *ite;
+	int ret;
+	int ite_esz = abi->ite_esz;
+
+	list_sort(NULL, &device->itt_head, vgic_its_ite_cmp);
+
+	list_for_each_entry(ite, &device->itt_head, ite_list) {
+		gpa_t gpa = base + ite->event_id * ite_esz;
+
+		ret = vgic_its_save_ite(its, device, ite, gpa, ite_esz);
+		if (ret)
+			return ret;
+	}
+	return 0;
 }
 
 static int vgic_its_restore_itt(struct vgic_its *its, struct its_device *dev)
 {
-	return -ENXIO;
+	const struct vgic_its_abi *abi = vgic_its_get_abi(its);
+	gpa_t base = dev->itt_addr;
+	int ret;
+	int ite_esz = abi->ite_esz;
+	size_t max_size = BIT_ULL(dev->num_eventid_bits) * ite_esz;
+
+	ret = scan_its_table(its, base, max_size, ite_esz, 0,
+			     vgic_its_restore_ite, dev);
+
+	return ret;
 }
 
 /**
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index f35e993..433449b 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -81,6 +81,10 @@
 #define KVM_ITS_CTE_VALID_MASK		BIT_ULL(63)
 #define KVM_ITS_CTE_RDBASE_SHIFT	16
 #define KVM_ITS_CTE_ICID_MASK		GENMASK_ULL(15, 0)
+#define KVM_ITS_ITE_NEXT_SHIFT		48
+#define KVM_ITS_ITE_PINTID_SHIFT	16
+#define KVM_ITS_ITE_PINTID_MASK		GENMASK_ULL(47, 16)
+#define KVM_ITS_ITE_ICID_MASK		GENMASK_ULL(15, 0)
 #define KVM_ITS_DTE_VALID_SHIFT		63
 #define KVM_ITS_DTE_VALID_MASK		BIT_ULL(63)
 #define KVM_ITS_DTE_NEXT_SHIFT		49
-- 
2.9.0
