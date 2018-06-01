From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 32/33] KVM: arm/arm64: Implement
 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION
Date: Fri,  1 Jun 2018 16:27:46 +0100
Message-ID: <20180601152747.23613-33-marc.zyngier@arm.com>
References: <20180601152747.23613-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A98D74A153
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Jun 2018 11:22:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TgNyEPCheVGh for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Jun 2018 11:22:22 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8001C4A133
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Jun 2018 11:18:21 -0400 (EDT)
In-Reply-To: <20180601152747.23613-1-marc.zyngier@arm.com>
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
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Eric Auger <eric.auger@redhat.com>

Now all the internals are ready to handle multiple redistributor
regions, let's allow the userspace to register them.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-kvm-device.c | 40 ++++++++++++++++++++++++++++-
 virt/kvm/arm/vgic/vgic-mmio-v3.c    |  4 +--
 virt/kvm/arm/vgic/vgic-v3.c         | 14 ++++++++++
 virt/kvm/arm/vgic/vgic.h            | 13 +++++++++-
 4 files changed, 67 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c b/virt/kvm/arm/vgic/vgic-kvm-device.c
index 76ab3691f7fe..6ada2432e37c 100644
--- a/virt/kvm/arm/vgic/vgic-kvm-device.c
+++ b/virt/kvm/arm/vgic/vgic-kvm-device.c
@@ -92,7 +92,7 @@ int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write)
 		if (r)
 			break;
 		if (write) {
-			r = vgic_v3_set_redist_base(kvm, *addr);
+			r = vgic_v3_set_redist_base(kvm, 0, *addr, 0);
 			goto out;
 		}
 		rdreg = list_first_entry(&vgic->rd_regions,
@@ -103,6 +103,43 @@ int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write)
 			addr_ptr = &rdreg->base;
 		break;
 	}
+	case KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION:
+	{
+		struct vgic_redist_region *rdreg;
+		u8 index;
+
+		r = vgic_check_type(kvm, KVM_DEV_TYPE_ARM_VGIC_V3);
+		if (r)
+			break;
+
+		index = *addr & KVM_VGIC_V3_RDIST_INDEX_MASK;
+
+		if (write) {
+			gpa_t base = *addr & KVM_VGIC_V3_RDIST_BASE_MASK;
+			u32 count = (*addr & KVM_VGIC_V3_RDIST_COUNT_MASK)
+					>> KVM_VGIC_V3_RDIST_COUNT_SHIFT;
+			u8 flags = (*addr & KVM_VGIC_V3_RDIST_FLAGS_MASK)
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
+			r = -ENOENT;
+			goto out;
+		}
+
+		*addr = index;
+		*addr |= rdreg->base;
+		*addr |= (u64)rdreg->count << KVM_VGIC_V3_RDIST_COUNT_SHIFT;
+		goto out;
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
index 1c6c535585e1..287784095b5b 100644
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
index eb32b213f600..7c6d278b8aee 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -491,6 +491,20 @@ struct vgic_redist_region *vgic_v3_rdist_free_slot(struct list_head *rd_regions)
 	return NULL;
 }
 
+struct vgic_redist_region *vgic_v3_rdist_region_from_index(struct kvm *kvm,
+							   u32 index)
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
index 1c8af4e4131c..6879cf48652a 100644
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
@@ -215,7 +222,7 @@ int vgic_v3_probe(const struct gic_kvm_info *info);
 int vgic_v3_map_resources(struct kvm *kvm);
 int vgic_v3_lpi_sync_pending_status(struct kvm *kvm, struct vgic_irq *irq);
 int vgic_v3_save_pending_tables(struct kvm *kvm);
-int vgic_v3_set_redist_base(struct kvm *kvm, u64 addr);
+int vgic_v3_set_redist_base(struct kvm *kvm, u32 index, u64 addr, u32 count);
 int vgic_register_redist_iodev(struct kvm_vcpu *vcpu);
 bool vgic_v3_check_base(struct kvm *kvm);
 
@@ -284,6 +291,10 @@ vgic_v3_rd_region_size(struct kvm *kvm, struct vgic_redist_region *rdreg)
 	else
 		return rdreg->count * KVM_VGIC_V3_REDIST_SIZE;
 }
+
+struct vgic_redist_region *vgic_v3_rdist_region_from_index(struct kvm *kvm,
+							   u32 index);
+
 bool vgic_v3_rdist_overlap(struct kvm *kvm, gpa_t base, size_t size);
 
 static inline bool vgic_dist_overlap(struct kvm *kvm, gpa_t base, size_t size)
-- 
2.17.1
