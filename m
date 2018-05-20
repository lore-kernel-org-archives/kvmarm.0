From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v7 06/13] KVM: arm/arm64: Adapt vgic_v3_check_base to multiple rdist regions
Date: Sun, 20 May 2018 23:22:45 +0200
Message-ID: <1526851372-13009-7-git-send-email-eric.auger@redhat.com>
References: <1526851372-13009-1-git-send-email-eric.auger@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1526851372-13009-1-git-send-email-eric.auger@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, christoffer.dall@arm.com, peter.maydell@linaro.org
Cc: andre.przywara@arm.com, drjones@redhat.com, wei@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

vgic_v3_check_base() currently only handles the case of a unique
legacy redistributor region whose size is not explicitly set but
inferred, instead, from the number of online vcpus.

We adapt it to handle the case of multiple redistributor regions
with explicitly defined size. We rely on two new helpers:
- vgic_v3_rdist_overlap() is used to detect overlap with the dist
  region if defined
- vgic_v3_rd_region_size computes the size of the redist region,
  would it be a legacy unique region or a new explicitly sized
  region.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Christoffer Dall <christoffer.dall@arm.com>

---

v4 -> v5:
- s/infered/inferred in the commit msg
- Added Christoffer's R-b

v3 -> v4:
- squash vgic_v3_check_base adaptation and vgic_v3_rdist_overlap
  + vgic_v3_rd_region_size introduction  and put this patch
  before v3 patch 6
---
 virt/kvm/arm/vgic/vgic-v3.c | 49 +++++++++++++++++++++++++++++----------------
 virt/kvm/arm/vgic/vgic.h    | 10 +++++++++
 2 files changed, 42 insertions(+), 17 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index 6a1c932..a006914 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -419,6 +419,29 @@ int vgic_v3_save_pending_tables(struct kvm *kvm)
 	return 0;
 }
 
+/**
+ * vgic_v3_rdist_overlap - check if a region overlaps with any
+ * existing redistributor region
+ *
+ * @kvm: kvm handle
+ * @base: base of the region
+ * @size: size of region
+ *
+ * Return: true if there is an overlap
+ */
+bool vgic_v3_rdist_overlap(struct kvm *kvm, gpa_t base, size_t size)
+{
+	struct vgic_dist *d = &kvm->arch.vgic;
+	struct vgic_redist_region *rdreg;
+
+	list_for_each_entry(rdreg, &d->rd_regions, list) {
+		if ((base + size > rdreg->base) &&
+			(base < rdreg->base + vgic_v3_rd_region_size(kvm, rdreg)))
+			return true;
+	}
+	return false;
+}
+
 /*
  * Check for overlapping regions and for regions crossing the end of memory
  * for base addresses which have already been set.
@@ -426,31 +449,23 @@ int vgic_v3_save_pending_tables(struct kvm *kvm)
 bool vgic_v3_check_base(struct kvm *kvm)
 {
 	struct vgic_dist *d = &kvm->arch.vgic;
-	gpa_t redist_size = KVM_VGIC_V3_REDIST_SIZE;
-	struct vgic_redist_region *rdreg =
-		list_first_entry(&d->rd_regions,
-				 struct vgic_redist_region, list);
-
-	redist_size *= atomic_read(&kvm->online_vcpus);
+	struct vgic_redist_region *rdreg;
 
 	if (!IS_VGIC_ADDR_UNDEF(d->vgic_dist_base) &&
 	    d->vgic_dist_base + KVM_VGIC_V3_DIST_SIZE < d->vgic_dist_base)
 		return false;
 
-	if (rdreg && (rdreg->base + redist_size < rdreg->base))
-		return false;
+	list_for_each_entry(rdreg, &d->rd_regions, list) {
+		if (rdreg->base + vgic_v3_rd_region_size(kvm, rdreg) <
+			rdreg->base)
+			return false;
+	}
 
-	/* Both base addresses must be set to check if they overlap */
-	if (IS_VGIC_ADDR_UNDEF(d->vgic_dist_base) || !rdreg)
+	if (IS_VGIC_ADDR_UNDEF(d->vgic_dist_base))
 		return true;
 
-	if (d->vgic_dist_base + KVM_VGIC_V3_DIST_SIZE <= rdreg->base)
-		return true;
-
-	if (rdreg->base + redist_size <= d->vgic_dist_base)
-		return true;
-
-	return false;
+	return !vgic_v3_rdist_overlap(kvm, d->vgic_dist_base,
+				      KVM_VGIC_V3_DIST_SIZE);
 }
 
 /**
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index fddd57f..e9f1926 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -276,6 +276,16 @@ vgic_v3_redist_region_full(struct vgic_redist_region *region)
 
 struct vgic_redist_region *vgic_v3_rdist_free_slot(struct list_head *rdregs);
 
+static inline size_t
+vgic_v3_rd_region_size(struct kvm *kvm, struct vgic_redist_region *rdreg)
+{
+	if (!rdreg->count)
+		return atomic_read(&kvm->online_vcpus) * KVM_VGIC_V3_REDIST_SIZE;
+	else
+		return rdreg->count * KVM_VGIC_V3_REDIST_SIZE;
+}
+bool vgic_v3_rdist_overlap(struct kvm *kvm, gpa_t base, size_t size);
+
 int vgic_its_resolve_lpi(struct kvm *kvm, struct vgic_its *its,
 			 u32 devid, u32 eventid, struct vgic_irq **irq);
 struct vgic_its *vgic_msi_to_its(struct kvm *kvm, struct kvm_msi *msi);
-- 
2.5.5
