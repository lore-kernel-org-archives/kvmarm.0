From: Eric Auger <eric.auger@redhat.com>
Subject: [RFC 07/12] KVM: arm/arm64: Helper to register a new redistributor region
Date: Mon, 19 Mar 2018 10:20:15 +0100
Message-ID: <1521451220-27754-8-git-send-email-eric.auger@redhat.com>
References: <1521451220-27754-1-git-send-email-eric.auger@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1521451220-27754-1-git-send-email-eric.auger@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, cdall@kernel.org, peter.maydell@linaro.org
Cc: andre.przywara@arm.com, drjones@redhat.com, wei@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

We introduce a new helper that creates and inserts a new redistributor
region into the rdist region list. This helper both handles the case
where the redistributor region size is known at registration time
and the legacy case where it is not (eventually depending on the number
of online vcpus). Depending on pfns, we perform all the possible checks
that we can do:

- end of memory crossing
- incorrect alignment of the base address
- collision with distributor region if already defined
- collision with already registered rdist regions
- check of the new index

Rdist regions must be inserted by increasing order of indices. Indices
must be contiguous.

We also introduce vgic_v3_rdist_region_from_index() which will be used
from the vgic kvm-device, later on.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 virt/kvm/arm/vgic/vgic-mmio-v3.c | 90 +++++++++++++++++++++++++++++++++-------
 virt/kvm/arm/vgic/vgic-v3.c      | 29 +++++++++++++
 virt/kvm/arm/vgic/vgic.h         | 14 +++++++
 3 files changed, 118 insertions(+), 15 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index 5768034..f139382 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -676,13 +676,62 @@ static int vgic_register_all_redist_iodevs(struct kvm *kvm)
 	return ret;
 }
 
-int vgic_v3_set_redist_base(struct kvm *kvm, u64 addr)
+/**
+ * vgic_v3_insert_redist_region - Insert a new redistributor region
+ *
+ * Performs various checks before inserting the rdist region in the list.
+ * Those tests depend on whether the size of the rdist region is known
+ * (ie. pfns != 0). The list is sorted by rdist region index.
+ *
+ * @kvm: kvm handle
+ * @index: redist region index
+ * @base: base of the new rdist region
+ * @pfns: number of 64kB pages the region is made of (of 0 in the old style
+ * single region, whose size is induced from the number of vcpus
+ *
+ * Return 0 on success, < 0 otherwise
+ */
+static int vgic_v3_insert_redist_region(struct kvm *kvm, uint32_t index,
+					gpa_t base, uint32_t pfns)
 {
-	struct vgic_dist *vgic = &kvm->arch.vgic;
+	struct vgic_dist *d = &kvm->arch.vgic;
 	struct vgic_redist_region *rdreg;
+	struct list_head *rd_regions = &d->rd_regions;
+	struct list_head *last = rd_regions->prev;
+
+	gpa_t new_start, new_end;
+	size_t size = pfns * SZ_64K;
 	int ret;
 
-	if (!list_empty(&vgic->rd_regions))
+	/* single rdist region already set ?*/
+	if (!pfns && !list_empty(rd_regions))
+		return -EINVAL;
+
+	/* cross the end of memory ? */
+	if (base + size < base)
+		return -EINVAL;
+
+	if (list_empty(rd_regions)) {
+		if (index != 0)
+			return -EINVAL;
+	} else {
+		rdreg = list_entry(last, struct vgic_redist_region, list);
+		if (index != rdreg->index + 1)
+			return -EINVAL;
+	}
+
+	/*
+	 * collision with already set dist region ?
+	 * this assumes we know the size of the new rdist region (pfns != 0)
+	 * otherwise we can only test this when all vcpus are registered
+	 */
+	if (!pfns && !IS_VGIC_ADDR_UNDEF(d->vgic_dist_base) &&
+		(!(d->vgic_dist_base + KVM_VGIC_V3_DIST_SIZE <= base)) &&
+		(!(base + size <= d->vgic_dist_base)))
+		return -EINVAL;
+
+	/* collision with any other rdist region? */
+	if (vgic_v3_rdist_overlap(kvm, base, size))
 		return -EINVAL;
 
 	rdreg = kzalloc(sizeof(*rdreg), GFP_KERNEL);
@@ -692,17 +741,32 @@ int vgic_v3_set_redist_base(struct kvm *kvm, u64 addr)
 	rdreg->base = VGIC_ADDR_UNDEF;
 
 	/* vgic_check_ioaddr makes sure we don't do this twice */
-	ret = vgic_check_ioaddr(kvm, &rdreg->base, addr, SZ_64K);
+	ret = vgic_check_ioaddr(kvm, &rdreg->base, base, SZ_64K);
 	if (ret)
-		goto out;
+		goto free;
 
-	rdreg->base = addr;
-	if (!vgic_v3_check_base(kvm)) {
-		ret = -EINVAL;
-		goto out;
-	}
+	rdreg->base = base;
+	rdreg->pfns = pfns;
+	rdreg->free_pfn_offset = 0;
+	rdreg->index = index;
+
+	new_start = base;
+	new_end = base + size - 1;
+
+	list_add_tail(&rdreg->list, rd_regions);
+	return 0;
+free:
+	kfree(rdreg);
+	return ret;
+}
+
+int vgic_v3_set_redist_base(struct kvm *kvm, u64 addr)
+{
+	int ret;
 
-	list_add(&rdreg->list, &vgic->rd_regions);
+	ret = vgic_v3_insert_redist_region(kvm, 0, addr, 0);
+	if (ret)
+		return ret;
 
 	/*
 	 * Register iodevs for each existing VCPU.  Adding more VCPUs
@@ -713,10 +777,6 @@ int vgic_v3_set_redist_base(struct kvm *kvm, u64 addr)
 		return ret;
 
 	return 0;
-
-out:
-	kfree(rdreg);
-	return ret;
 }
 
 int vgic_v3_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *attr)
diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index 68cae0e..c6ec636 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -397,6 +397,21 @@ int vgic_v3_save_pending_tables(struct kvm *kvm)
 	return 0;
 }
 
+/* return true if there is an overlap between any rdist */
+bool vgic_v3_rdist_overlap(struct kvm *kvm, gpa_t base, size_t size)
+{
+	struct vgic_dist *d = &kvm->arch.vgic;
+	struct vgic_redist_region *rdreg;
+
+	list_for_each_entry(rdreg, &d->rd_regions, list) {
+		if ((base + size <= rdreg->base) ||
+			(rdreg->base + vgic_v3_rd_region_size(kvm, rdreg) <= base))
+			continue;
+		return true;
+	}
+	return false;
+}
+
 /*
  * Check for overlapping regions and for regions crossing the end of memory
  * for base addresses which have already been set.
@@ -452,6 +467,20 @@ struct vgic_redist_region *vgic_v3_rdist_free_slot(struct list_head *rd_regions,
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
 	int ret = 0;
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index 04456d3..dcf43c7 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -263,9 +263,23 @@ vgic_v3_last_rdist(struct kvm_vcpu *vcpu, struct vgic_redist_region *region)
 	return vgic_v3_redist_region_full(region);
 }
 
+static inline size_t
+vgic_v3_rd_region_size(struct kvm *kvm, struct vgic_redist_region *rdreg)
+{
+	if (!rdreg->pfns)
+		return atomic_read(&kvm->online_vcpus) * KVM_VGIC_V3_REDIST_SIZE;
+	else
+		return rdreg->pfns * SZ_64K;
+}
+
+struct vgic_redist_region *vgic_v3_rdist_region_from_index(struct kvm *kvm,
+							   uint32_t index);
+
 struct vgic_redist_region *vgic_v3_rdist_free_slot(struct list_head *rd_regions,
 						   uint32_t *free_pfn_offset);
 
+bool vgic_v3_rdist_overlap(struct kvm *kvm, gpa_t base, size_t size);
+
 int vgic_its_resolve_lpi(struct kvm *kvm, struct vgic_its *its,
 			 u32 devid, u32 eventid, struct vgic_irq **irq);
 struct vgic_its *vgic_msi_to_its(struct kvm *kvm, struct kvm_msi *msi);
-- 
2.5.5
