From: Eric Auger <eric.auger@redhat.com>
Subject: [RFC 12/12] KVM: arm/arm64: Implement KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION
Date: Mon, 19 Mar 2018 10:20:20 +0100
Message-ID: <1521451220-27754-13-git-send-email-eric.auger@redhat.com>
References: <1521451220-27754-1-git-send-email-eric.auger@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1521451220-27754-1-git-send-email-eric.auger@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, cdall@kernel.org, peter.maydell@linaro.org
Cc: andre.przywara@arm.com, drjones@redhat.com, wei@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Now all the internals are ready to handle multiple redistributor
regions, let's allow the userspace to register them.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 virt/kvm/arm/vgic/vgic-kvm-device.c | 34 +++++++++++++++++++++++++++++++++-
 virt/kvm/arm/vgic/vgic-mmio-v3.c    |  4 ++--
 virt/kvm/arm/vgic/vgic.h            |  7 ++++++-
 3 files changed, 41 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c b/virt/kvm/arm/vgic/vgic-kvm-device.c
index e7b5a86..6a7f8ee 100644
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
@@ -103,6 +103,38 @@ int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write)
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
+			uint32_t pfns = (*addr & KVM_VGIC_V3_RDIST_PFNS_MASK)
+					>> KVM_VGIC_V3_RDIST_PFNS_SHIFT;
+
+			if (!pfns)
+				r = -EINVAL;
+			else
+				r = vgic_v3_set_redist_base(kvm, index,
+							    base, pfns);
+			goto out;
+		}
+
+		rdreg = vgic_v3_rdist_region_from_index(kvm, index);
+		if (!rdreg)
+			r = -ENODEV;
+
+		*addr_ptr = rdreg->base & index &
+			(uint64_t)rdreg->pfns << KVM_VGIC_V3_RDIST_PFNS_SHIFT;
+		break;
+	}
 	default:
 		r = -ENODEV;
 	}
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index ea34412..8fa6c08 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -763,11 +763,11 @@ static int vgic_v3_insert_redist_region(struct kvm *kvm, uint32_t index,
 	return ret;
 }
 
-int vgic_v3_set_redist_base(struct kvm *kvm, u64 addr)
+int vgic_v3_set_redist_base(struct kvm *kvm, u32 index, u64 addr, u32 pfns)
 {
 	int ret;
 
-	ret = vgic_v3_insert_redist_region(kvm, 0, addr, 0);
+	ret = vgic_v3_insert_redist_region(kvm, index, addr, pfns);
 	if (ret)
 		return ret;
 
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index dcf43c7..57165fe 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -96,6 +96,11 @@
 /* we only support 64 kB translation table page size */
 #define KVM_ITS_L1E_ADDR_MASK		GENMASK_ULL(51, 16)
 
+#define KVM_VGIC_V3_RDIST_INDEX_MASK	GENMASK_ULL(1, 0)
+#define KVM_VGIC_V3_RDIST_BASE_MASK	GENMASK_ULL(51, 12)
+#define KVM_VGIC_V3_RDIST_PFNS_MASK	GENMASK_ULL(63, 52)
+#define KVM_VGIC_V3_RDIST_PFNS_SHIFT	52
+
 static inline bool irq_is_pending(struct vgic_irq *irq)
 {
 	if (irq->config == VGIC_CONFIG_EDGE)
@@ -195,7 +200,7 @@ int vgic_v3_probe(const struct gic_kvm_info *info);
 int vgic_v3_map_resources(struct kvm *kvm);
 int vgic_v3_lpi_sync_pending_status(struct kvm *kvm, struct vgic_irq *irq);
 int vgic_v3_save_pending_tables(struct kvm *kvm);
-int vgic_v3_set_redist_base(struct kvm *kvm, u64 addr);
+int vgic_v3_set_redist_base(struct kvm *kvm, u32 index, u64 addr, u32 pfns);
 int vgic_register_redist_iodev(struct kvm_vcpu *vcpu);
 bool vgic_v3_check_base(struct kvm *kvm);
 
-- 
2.5.5
