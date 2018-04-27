From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v4 11/12] KVM: arm/arm64: Implement KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION
Date: Fri, 27 Apr 2018 16:15:04 +0200
Message-ID: <1524838505-3823-12-git-send-email-eric.auger@redhat.com>
References: <1524838505-3823-1-git-send-email-eric.auger@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1524838505-3823-1-git-send-email-eric.auger@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, cdall@kernel.org, peter.maydell@linaro.org
Cc: andre.przywara@arm.com, drjones@redhat.com, wei@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Now all the internals are ready to handle multiple redistributor
regions, let's allow the userspace to register them.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---
v3 -> v4:
- vgic_v3_rdist_region_from_index is introduced in this patch

v2 -> v3:
- early exit if vgic_v3_rdist_region_from_index() fails
---
 virt/kvm/arm/vgic/vgic-kvm-device.c | 42 +++++++++++++++++++++++++++++++++++--
 virt/kvm/arm/vgic/vgic-mmio-v3.c    |  4 ++--
 virt/kvm/arm/vgic/vgic-v3.c         | 14 +++++++++++++
 virt/kvm/arm/vgic/vgic.h            | 13 +++++++++++-
 4 files changed, 68 insertions(+), 5 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c b/virt/kvm/arm/vgic/vgic-kvm-device.c
index e7b5a86..00e03d3 100644
--- a/virt/kvm/arm/vgic/vgic-kvm-device.c
+++ b/virt/kvm/arm/vgic/vgic-kvm-device.c
@@ -65,7 +65,8 @@ int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write)
 {
 	int r = 0;
 	struct vgic_dist *vgic = &kvm->arch.vgic;
-	phys_addr_t *addr_ptr, alignment;
+	phys_addr_t *addr_ptr = NULL;
+	phys_addr_t alignment;
 	uint64_t undef_value = VGIC_ADDR_UNDEF;
 
 	mutex_lock(&kvm->lock);
@@ -92,7 +93,7 @@ int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write)
 		if (r)
 			break;
 		if (write) {
-			r = vgic_v3_set_redist_base(kvm, *addr);
+			r = vgic_v3_set_redist_base(kvm, 0, *addr, 0);
 			goto out;
 		}
 		rdreg = list_first_entry(&vgic->rd_regions,
@@ -103,6 +104,42 @@ int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write)
 			addr_ptr = &rdreg->base;
 		break;
 	}
+	case KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION:
+	{
+		struct vgic_redist_region *rdreg;
+		uint8_t index;
+
+		r = vgic_check_type(kvm, KVM_DEV_TYPE_ARM_VGIC_V3);
+		if (r)
+			break;
+
+		index = *addr & KVM_VGIC_V3_RDIST_INDEX_MASK;
+
+		if (write) {
+			gpa_t base = *addr & KVM_VGIC_V3_RDIST_BASE_MASK;
+			uint32_t count = (*addr & KVM_VGIC_V3_RDIST_COUNT_MASK)
+					>> KVM_VGIC_V3_RDIST_COUNT_SHIFT;
+			uint8_t flags = (*addr & KVM_VGIC_V3_RDIST_FLAGS_MASK)
+					>> KVM_VGIC_V3_RDIST_FLAGS_SHIFT;
+
+			if (!count || flags)
+				r = -EINVAL;
+			else
+				r = vgic_v3_set_redist_base(kvm, index,
+							    base, count);
+			goto out;
+		}
+
+		rdreg = vgic_v3_rdist_region_from_index(kvm, index);
+		if (!rdreg) {
+			r = -ENODEV;
+			goto out;
+		}
+
+		*addr_ptr = rdreg->base & index &
+			(uint64_t)rdreg->count << KVM_VGIC_V3_RDIST_COUNT_SHIFT;
+		break;
+	}
 	default:
 		r = -ENODEV;
 	}
@@ -674,6 +711,7 @@ static int vgic_v3_has_attr(struct kvm_device *dev,
 		switch (attr->attr) {
 		case KVM_VGIC_V3_ADDR_TYPE_DIST:
 		case KVM_VGIC_V3_ADDR_TYPE_REDIST:
+		case KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION:
 			return 0;
 		}
 		break;
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index 1b1e07f..fcebd42 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -764,11 +764,11 @@ static int vgic_v3_insert_redist_region(struct kvm *kvm, uint32_t index,
 	return ret;
 }
 
-int vgic_v3_set_redist_base(struct kvm *kvm, u64 addr)
+int vgic_v3_set_redist_base(struct kvm *kvm, u32 index, u64 addr, u32 count)
 {
 	int ret;
 
-	ret = vgic_v3_insert_redist_region(kvm, 0, addr, 0);
+	ret = vgic_v3_insert_redist_region(kvm, index, addr, count);
 	if (ret)
 		return ret;
 
diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index 5563671..ba3baa2 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -482,6 +482,20 @@ struct vgic_redist_region *vgic_v3_rdist_free_slot(struct list_head *rd_regions)
 	return NULL;
 }
 
+struct vgic_redist_region *vgic_v3_rdist_region_from_index(struct kvm *kvm,
+							   uint32_t index)
+{
+	struct list_head *rd_regions = &kvm->arch.vgic.rd_regions;
+	struct vgic_redist_region *rdreg;
+
+	list_for_each_entry(rdreg, rd_regions, list) {
+		if (rdreg->index == index)
+			return rdreg;
+	}
+	return NULL;
+}
+
+
 int vgic_v3_map_resources(struct kvm *kvm)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index 6af7d8a..9552d26 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -96,6 +96,13 @@
 /* we only support 64 kB translation table page size */
 #define KVM_ITS_L1E_ADDR_MASK		GENMASK_ULL(51, 16)
 
+#define KVM_VGIC_V3_RDIST_INDEX_MASK	GENMASK_ULL(11, 0)
+#define KVM_VGIC_V3_RDIST_FLAGS_MASK	GENMASK_ULL(15, 12)
+#define KVM_VGIC_V3_RDIST_FLAGS_SHIFT	12
+#define KVM_VGIC_V3_RDIST_BASE_MASK	GENMASK_ULL(51, 16)
+#define KVM_VGIC_V3_RDIST_COUNT_MASK	GENMASK_ULL(63, 52)
+#define KVM_VGIC_V3_RDIST_COUNT_SHIFT	52
+
 /* Requires the irq_lock to be held by the caller. */
 static inline bool irq_is_pending(struct vgic_irq *irq)
 {
@@ -201,7 +208,7 @@ int vgic_v3_probe(const struct gic_kvm_info *info);
 int vgic_v3_map_resources(struct kvm *kvm);
 int vgic_v3_lpi_sync_pending_status(struct kvm *kvm, struct vgic_irq *irq);
 int vgic_v3_save_pending_tables(struct kvm *kvm);
-int vgic_v3_set_redist_base(struct kvm *kvm, u64 addr);
+int vgic_v3_set_redist_base(struct kvm *kvm, u32 index, u64 addr, u32 count);
 int vgic_register_redist_iodev(struct kvm_vcpu *vcpu);
 bool vgic_v3_check_base(struct kvm *kvm);
 
@@ -270,6 +277,10 @@ vgic_v3_rd_region_size(struct kvm *kvm, struct vgic_redist_region *rdreg)
 	else
 		return rdreg->count * KVM_VGIC_V3_REDIST_SIZE;
 }
+
+struct vgic_redist_region *vgic_v3_rdist_region_from_index(struct kvm *kvm,
+							   uint32_t index);
+
 bool vgic_v3_rdist_overlap(struct kvm *kvm, gpa_t base, size_t size);
 
 static inline bool vgic_dist_overlap(struct kvm *kvm, gpa_t base, size_t size)
-- 
2.5.5
